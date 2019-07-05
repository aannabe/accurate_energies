#!/bin/bash
#SBATCH -J Al_QZ			# job name
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

rungms Al.inp > Al.log

if grep -q 'EXECUTION OF GAMESS TERMINATED NORMALLY' Al.log; then
	echo 'GAMESS exited successfully'
else
	echo 'GAMESS exited with errors; aborting'
	exit 1
fi

gamess_hf=`grep 'TOTAL ENERGY =' Al.log | awk '{print $4}'`
echo "GAMESS HF:"
echo $gamess_hf

## Convert GAMESS orbitals to qwalk
gamess2qmc-stampede Al
sed -i "s/CUTOFF 7.5/CUTOFF 20.0/g" Al.jast3
sed -i "s/RCUT 7.5/RCUT 20.0/g" Al.jast3
sed -i "s/NFUNC 3/NFUNC 4/g" Al.jast3
sed -i "s/COEFFICIENTS { 0 0 0 }/COEFFICIENTS { 0 0 0 0 }/g" Al.jast3

## Run HF WFN to check and to distrubate configurations
mpirun -np 64 qwalk-stampede Al.hf

qwalk_hf=`gosling-stampede Al.hf.log | grep 'total_energy0' | awk '{print $2}'`
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


mpirun -np 64 qwalk-stampede Al.opt
mpirun -np 64 qwalk-stampede Al.vmc
sed s/OPTIMIZEBASIS//g Al.opt.wfout > fixed_basis.wf
mpirun -np 64 qwalk-stampede Al.linear
cp Al.linear.wfout Al.last.wfout
cp Al.vmc.config Al.vmci.config

for ((i=0; i<$N_OPT; i++))
do
	echo "Optimization Round:"
	echo $i
	mpirun -np 64 qwalk-stampede Al.var
	cp Al.var.wfout Al.last.wfout
	mpirun -np 64 qwalk-stampede Al.vmci
	sed s/OPTIMIZEBASIS//g Al.last.wfout > fixed_basis.wf
	mpirun -np 64 qwalk-stampede Al.linear
	cp Al.linear.wfout Al.last.wfout
done


#### ~~~~~~~~~~~ CHECK FINAL VMC ENERGY ~~~~~~~~~~~~~~~~

mpirun -np 64 qwalk-stampede Al.vmcf

### ~~~~~~~~~~~~~~ DMC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sed -i 's/READCONFIG Al.dmci.config/READCONFIG Al.vmcf.config/g' Al.dmc_${timestep[0]}

for t in "${timestep[@]}"
do
	mpirun -np 64 qwalk-stampede Al.dmc_${t}
	cp Al.dmc_${t}.config Al.dmci.config
done


### ~~~~~~~~~~~~ POST-PROCESSING ~~~~~~~~~~~~~~~~~~~

echo 'Timestep DMC STD' > timedmc.csv
for t in "${timestep[@]}"
do
	echo 'Type Energy STD Sigma' > Al.dmc_${t}.csv
	gosling-stampede Al.dmc_${t}.log | grep 'total_energy0' >> Al.dmc_${t}.csv
	gosling-stampede Al.dmc_${t}.log | grep 'kinetic0' >> Al.dmc_${t}.csv 
	gosling-stampede Al.dmc_${t}.log | grep 'potential0' >> Al.dmc_${t}.csv
	gosling-stampede Al.dmc_${t}.log | grep 'nonlocal0' >> Al.dmc_${t}.csv
	gosling-stampede Al.dmc_${t}.log | grep 'weight0' >> Al.dmc_${t}.csv
	sed -i "s/+\/-//g" Al.dmc_${t}.csv
	sed -i "s/(sigma//g" Al.dmc_${t}.csv
	sed -i "s/)//g" Al.dmc_${t}.csv
	
	dmc=`gosling-stampede Al.dmc_${t}.log | grep 'total_energy0' | awk '{print $2}'`
	std=`gosling-stampede Al.dmc_${t}.log | grep 'total_energy0' | awk '{print $4}'`
	echo ${t} $dmc $std >> timedmc.csv
done

python timedmc.py > timedmc.log


