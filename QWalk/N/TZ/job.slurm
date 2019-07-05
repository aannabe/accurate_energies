#!/bin/bash
#SBATCH -J N_TZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                    # total number of mpi tasks requested
#SBATCH -n 64                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#SBATCH -t 11:59:00             # run time (hh:mm:ss) - 1.5 hours
#!SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours


module load python3
module load intel
module load texlive

#### ~~~~~~~~ CONSTANTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

N_OPT=2		# Extra optimization cycles
declare -a timestep=("0.02" "0.01" "0.005" "0.0025" "0.001")

### ~~~~~~~~~~~~~~~~~~~~~~~~ HF ~~~~~~~~~~~~~~~~~~~~~

rungms N.inp > N.log

if grep -q 'EXECUTION OF GAMESS TERMINATED NORMALLY' N.log; then
	echo 'GAMESS exited successfully'
else
	echo 'GAMESS exited with errors; aborting'
	exit 1
fi

gamess_hf=`grep 'TOTAL ENERGY =' N.log | awk '{print $4}'`
echo "GAMESS HF:"
echo $gamess_hf

## Convert GAMESS orbitals to qwalk
gamess2qmc-stampede N
sed -i "s/CUTOFF 7.5/CUTOFF 20.0/g" N.jast3
sed -i "s/RCUT 7.5/RCUT 20.0/g" N.jast3
sed -i "s/NFUNC 3/NFUNC 4/g" N.jast3
sed -i "s/COEFFICIENTS { 0 0 0 }/COEFFICIENTS { 0 0 0 0 }/g" N.jast3

## Run HF WFN to check and to distrubate configurations
mpirun -np 64 qwalk-stampede N.hf

qwalk_hf=`gosling-stampede N.hf.log | grep 'total_energy0' | awk '{print $2}'`
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


mpirun -np 64 qwalk-stampede N.opt
mpirun -np 64 qwalk-stampede N.vmc
sed s/OPTIMIZEBASIS//g N.opt.wfout > fixed_basis.wf
mpirun -np 64 qwalk-stampede N.linear
cp N.linear.wfout N.last.wfout
cp N.vmc.config N.vmci.config

for ((i=0; i<$N_OPT; i++))
do
	echo "Optimization Round:"
	echo $i
	mpirun -np 64 qwalk-stampede N.var
	cp N.var.wfout N.last.wfout
	mpirun -np 64 qwalk-stampede N.vmci
	sed s/OPTIMIZEBASIS//g N.last.wfout > fixed_basis.wf
	mpirun -np 64 qwalk-stampede N.linear
	cp N.linear.wfout N.last.wfout
done


#### ~~~~~~~~~~~ CHECK FINAL VMC ENERGY ~~~~~~~~~~~~~~~~

mpirun -np 64 qwalk-stampede N.vmcf

### ~~~~~~~~~~~~~~ DMC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sed -i 's/READCONFIG N.dmci.config/READCONFIG N.vmcf.config/g' N.dmc_${timestep[0]}

for t in "${timestep[@]}"
do
	mpirun -np 64 qwalk-stampede N.dmc_${t}
	cp N.dmc_${t}.config N.dmci.config
done


### ~~~~~~~~~~~~ POST-PROCESSING ~~~~~~~~~~~~~~~~~~~

echo 'Timestep DMC STD' > timedmc.csv
for t in "${timestep[@]}"
do
	echo 'Type Energy STD Sigma' > N.dmc_${t}.csv
	gosling-stampede N.dmc_${t}.log | grep 'total_energy0' >> N.dmc_${t}.csv
	gosling-stampede N.dmc_${t}.log | grep 'kinetic0' >> N.dmc_${t}.csv 
	gosling-stampede N.dmc_${t}.log | grep 'potential0' >> N.dmc_${t}.csv
	gosling-stampede N.dmc_${t}.log | grep 'nonlocal0' >> N.dmc_${t}.csv
	gosling-stampede N.dmc_${t}.log | grep 'weight0' >> N.dmc_${t}.csv
	sed -i "s/+\/-//g" N.dmc_${t}.csv
	sed -i "s/(sigma//g" N.dmc_${t}.csv
	sed -i "s/)//g" N.dmc_${t}.csv
	
	dmc=`gosling-stampede N.dmc_${t}.log | grep 'total_energy0' | awk '{print $2}'`
	std=`gosling-stampede N.dmc_${t}.log | grep 'total_energy0' | awk '{print $4}'`
	echo ${t} $dmc $std >> timedmc.csv
done

python timedmc.py > timedmc.log


