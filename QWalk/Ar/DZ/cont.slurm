#!/bin/bash
#SBATCH -J Ar_DZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                    # total number of mpi tasks requested
#SBATCH -n 64                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#SBATCH -p development
#!SBATCH -t 15:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours


module load python3
module load intel
module load texlive

#### ~~~~~~~~ CONSTANTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

declare -a timestep=("0.02" "0.01" "0.005" "0.0025" "0.001")

### ~~~~~~~~~~~~~~~~~~~~~~~~ HF ~~~~~~~~~~~~~~~~~~~~~

### ~~~~~~~~~~~~~~ DMC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mpirun -np 64 qwalk-stampede Ar.dmc_0.001

### ~~~~~~~~~~~~ POST-PROCESSING ~~~~~~~~~~~~~~~~~~~

echo 'Timestep DMC STD' > timedmc.csv
for t in "${timestep[@]}"
do
	echo 'Type Energy STD Sigma' > Ar.dmc_${t}.csv
	gosling-stampede Ar.dmc_${t}.log | grep 'total_energy0' >> Ar.dmc_${t}.csv
	gosling-stampede Ar.dmc_${t}.log | grep 'kinetic0' >> Ar.dmc_${t}.csv 
	gosling-stampede Ar.dmc_${t}.log | grep 'potential0' >> Ar.dmc_${t}.csv
	gosling-stampede Ar.dmc_${t}.log | grep 'nonlocal0' >> Ar.dmc_${t}.csv
	gosling-stampede Ar.dmc_${t}.log | grep 'weight0' >> Ar.dmc_${t}.csv
	sed -i "s/+\/-//g" Ar.dmc_${t}.csv
	sed -i "s/(sigma//g" Ar.dmc_${t}.csv
	sed -i "s/)//g" Ar.dmc_${t}.csv
	
	dmc=`gosling-stampede Ar.dmc_${t}.log | grep 'total_energy0' | awk '{print $2}'`
	std=`gosling-stampede Ar.dmc_${t}.log | grep 'total_energy0' | awk '{print $4}'`
	echo ${t} $dmc $std >> timedmc.csv
done

#python timedmc.py > timedmc.log


