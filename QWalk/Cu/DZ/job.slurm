#!/bin/bash
#SBATCH -J Cu_DZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                    # total number of mpi tasks requested
#SBATCH -n 68                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#SBATCH -t 15:59:00             # run time (hh:mm:ss) - 1.5 hours
#!SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours

module load python3
module load intel
module load texlive

#### ~~~~~~~~ CONSTANTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

declare -a timestep=("0.02" "0.01" "0.005" "0.0025" "0.001")

### ~~~~~~~~~~~~~~ DMC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
date

for t in "${timestep[@]}"
do
	ibrun -np 1088 qwalk-stampede Cu.dmc_${t}
	cp Cu.dmc_${t}.config Cu.dmci.config
done


### ~~~~~~~~~~~~ POST-PROCESSING ~~~~~~~~~~~~~~~~~~~

echo 'Timestep DMC STD' > timedmc.csv
for t in "${timestep[@]}"
do
	echo 'Type Energy STD Sigma' > Cu.dmc_${t}.csv
	gosling-stampede Cu.dmc_${t}.log | grep 'total_energy0' >> Cu.dmc_${t}.csv
	gosling-stampede Cu.dmc_${t}.log | grep 'kinetic0' >> Cu.dmc_${t}.csv 
	gosling-stampede Cu.dmc_${t}.log | grep 'potential0' >> Cu.dmc_${t}.csv
	gosling-stampede Cu.dmc_${t}.log | grep 'nonlocal0' >> Cu.dmc_${t}.csv
	gosling-stampede Cu.dmc_${t}.log | grep 'weight0' >> Cu.dmc_${t}.csv
	sed -i "s/+\/-//g" Cu.dmc_${t}.csv
	sed -i "s/(sigma//g" Cu.dmc_${t}.csv
	sed -i "s/)//g" Cu.dmc_${t}.csv
	
	dmc=`gosling-stampede Cu.dmc_${t}.log | grep 'total_energy0' | awk '{print $2}'`
	std=`gosling-stampede Cu.dmc_${t}.log | grep 'total_energy0' | awk '{print $4}'`
	echo ${t} $dmc $std >> timedmc.csv
done

python timedmc.py > timedmc.log

date
