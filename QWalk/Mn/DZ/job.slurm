#!/bin/bash
#SBATCH -J Mn_DZ			# job name
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
	ibrun -np 1088 qwalk-stampede Mn.dmc_${t}
	cp Mn.dmc_${t}.config Mn.dmci.config
done


### ~~~~~~~~~~~~ POST-PROCESSING ~~~~~~~~~~~~~~~~~~~

echo 'Timestep DMC STD' > timedmc.csv
for t in "${timestep[@]}"
do
	echo 'Type Energy STD Sigma' > Mn.dmc_${t}.csv
	gosling-stampede Mn.dmc_${t}.log | grep 'total_energy0' >> Mn.dmc_${t}.csv
	gosling-stampede Mn.dmc_${t}.log | grep 'kinetic0' >> Mn.dmc_${t}.csv 
	gosling-stampede Mn.dmc_${t}.log | grep 'potential0' >> Mn.dmc_${t}.csv
	gosling-stampede Mn.dmc_${t}.log | grep 'nonlocal0' >> Mn.dmc_${t}.csv
	gosling-stampede Mn.dmc_${t}.log | grep 'weight0' >> Mn.dmc_${t}.csv
	sed -i "s/+\/-//g" Mn.dmc_${t}.csv
	sed -i "s/(sigma//g" Mn.dmc_${t}.csv
	sed -i "s/)//g" Mn.dmc_${t}.csv
	
	dmc=`gosling-stampede Mn.dmc_${t}.log | grep 'total_energy0' | awk '{print $2}'`
	std=`gosling-stampede Mn.dmc_${t}.log | grep 'total_energy0' | awk '{print $4}'`
	echo ${t} $dmc $std >> timedmc.csv
done

python timedmc.py > timedmc.log

date
