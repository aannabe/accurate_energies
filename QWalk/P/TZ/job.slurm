#!/bin/bash
#SBATCH -J P_TZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                    # total number of mpi tasks requested
#SBATCH -n 64                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#SBATCH -t 14:59:00             # run time (hh:mm:ss) - 1.5 hours
#!SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours


module load python3
module load intel
module load texlive

#### ~~~~~~~~ CONSTANTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

N_OPT=2		# Extra optimization cycles
declare -a timestep=("0.02" "0.01" "0.005" "0.0025" "0.001")

### ~~~~~~~~~~~~~~~~~~~~~~~~ HF ~~~~~~~~~~~~~~~~~~~~~

rungms P.inp > P.log

if grep -q 'EXECUTION OF GAMESS TERMINATED NORMALLY' P.log; then
	echo 'GAMESS exited successfully'
else
	echo 'GAMESS exited with errors; aborting'
	exit 1
fi

gamess_hf=`grep 'TOTAL ENERGY =' P.log | awk '{print $4}'`
echo "GAMESS HF:"
echo $gamess_hf

## Convert GAMESS orbitals to qwalk
gamess2qmc-stampede P
sed -i "s/CUTOFF 7.5/CUTOFF 20.0/g" P.jast3
sed -i "s/RCUT 7.5/RCUT 20.0/g" P.jast3
sed -i "s/NFUNC 3/NFUNC 4/g" P.jast3
sed -i "s/COEFFICIENTS { 0 0 0 }/COEFFICIENTS { 0 0 0 0 }/g" P.jast3

## Run HF WFN to check and to distrubate configurations
mpirun -np 64 qwalk-stampede P.hf

qwalk_hf=`gosling-stampede P.hf.log | grep 'total_energy0' | awk '{print $2}'`
echo "QWALK HF:"
echo $qwalk_hf

diff=`echo "print(abs($gamess_hf-$qwalk_hf))" | python`
echo "HF Difference:"
echo $diff
thresh=0.001
res=`echo "res = 1 if $diff > $thresh else 0 ; print(res)" | python`
echo $res

if [ "$res" -eq 1 ]
then
	echo "HF numbers don't match; aborting"
###	exit 1
else
	echo "HF numbers look good"
fi


### ~~~~~~~~~~~~~~ OPTIMIZATION ~~~~~~~~~~~~~~~~~~~~~~~~~~


mpirun -np 64 qwalk-stampede P.opt
mpirun -np 64 qwalk-stampede P.vmc
sed s/OPTIMIZEBASIS//g P.opt.wfout > fixed_basis.wf
mpirun -np 64 qwalk-stampede P.linear
cp P.linear.wfout P.last.wfout
cp P.vmc.config P.vmci.config

for ((i=0; i<$N_OPT; i++))
do
	echo "Optimization Round:"
	echo $i
	mpirun -np 64 qwalk-stampede P.var
	cp P.var.wfout P.last.wfout
	mpirun -np 64 qwalk-stampede P.vmci
	sed s/OPTIMIZEBASIS//g P.last.wfout > fixed_basis.wf
	mpirun -np 64 qwalk-stampede P.linear
	cp P.linear.wfout P.last.wfout
done


#### ~~~~~~~~~~~ CHECK FINAL VMC ENERGY ~~~~~~~~~~~~~~~~

mpirun -np 64 qwalk-stampede P.vmcf

### ~~~~~~~~~~~~~~ DMC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sed -i 's/READCONFIG P.dmci.config/READCONFIG P.vmcf.config/g' P.dmc_${timestep[0]}

for t in "${timestep[@]}"
do
	mpirun -np 64 qwalk-stampede P.dmc_${t}
	cp P.dmc_${t}.config P.dmci.config
done


### ~~~~~~~~~~~~ POST-PROCESSING ~~~~~~~~~~~~~~~~~~~

echo 'Timestep DMC STD' > timedmc.csv
for t in "${timestep[@]}"
do
	echo 'Type Energy STD Sigma' > P.dmc_${t}.csv
	gosling-stampede P.dmc_${t}.log | grep 'total_energy0' >> P.dmc_${t}.csv
	gosling-stampede P.dmc_${t}.log | grep 'kinetic0' >> P.dmc_${t}.csv 
	gosling-stampede P.dmc_${t}.log | grep 'potential0' >> P.dmc_${t}.csv
	gosling-stampede P.dmc_${t}.log | grep 'nonlocal0' >> P.dmc_${t}.csv
	gosling-stampede P.dmc_${t}.log | grep 'weight0' >> P.dmc_${t}.csv
	sed -i "s/+\/-//g" P.dmc_${t}.csv
	sed -i "s/(sigma//g" P.dmc_${t}.csv
	sed -i "s/)//g" P.dmc_${t}.csv
	
	dmc=`gosling-stampede P.dmc_${t}.log | grep 'total_energy0' | awk '{print $2}'`
	std=`gosling-stampede P.dmc_${t}.log | grep 'total_energy0' | awk '{print $4}'`
	echo ${t} $dmc $std >> timedmc.csv
done

python timedmc.py > timedmc.log


