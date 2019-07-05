#!/bin/bash
#SBATCH -J Fe_TZ			# job name
#SBATCH -o myMP.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                    # total number of mpi tasks requested
#SBATCH -n 1064                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#SBATCH -p development
#!SBATCH -t 14:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours


module load python3
module load intel
module load texlive

#### ~~~~~~~~ CONSTANTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

N_OPT=3		# Extra optimization cycles
#declare -a timestep=("0.02" "0.01" "0.005" "0.0025" "0.001")
declare -a timestep=("0.01" "0.005" "0.0025" "0.001")

### ~~~~~~~~~~~~~~~~~~~~~~~~ HF ~~~~~~~~~~~~~~~~~~~~~

#cp /work/04843/aannabe/stampede2/repos/scripts/pp_totals/qwalk/pyscf_tm/Fe_STU/5Z/Fe.* .

## Run HF WFN to check and to distrubate configurations
#ibrun -np 1064 qwalk-stampede Fe.hf


#### ~~~~~~~~~~~~~~ OPTIMIZATION ~~~~~~~~~~~~~~~~~~~~~~~~~~


#ibrun -np 1064 qwalk-stampede Fe.opt

#sed s/OPTIMIZEBASIS//g Fe.opt.wfout > fixed_basis.wf
#ibrun -np 1024 qwalk-mixed Fe.mix
#ibrun -np 1024 qwalk-mixed Fe.linear
#ibrun -np 1024 qwalk-stampede Fe.linear


#ibrun -np 1064 qwalk-stampede Fe.vmc




### ~~~~~~~~~~~~~~ DMC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#for t in "${timestep[@]}"
#do
#	ibrun -np 1064 qwalk-stampede Fe.dmc_${t}
#	cp Fe.dmc_${t}.config Fe.dmci.config
#done


#### ~~~~~~~~~~~~ POST-PROCESSING ~~~~~~~~~~~~~~~~~~~

echo 'Timestep DMC STD' > timedmc.csv
for t in "${timestep[@]}"
do
	echo 'Type Energy STD Sigma' > Fe.dmc_${t}.csv
	gosling-stampede Fe.dmc_${t}.log | grep 'total_energy0' >> Fe.dmc_${t}.csv
	gosling-stampede Fe.dmc_${t}.log | grep 'kinetic0' >> Fe.dmc_${t}.csv 
	gosling-stampede Fe.dmc_${t}.log | grep 'potential0' >> Fe.dmc_${t}.csv
	gosling-stampede Fe.dmc_${t}.log | grep 'nonlocal0' >> Fe.dmc_${t}.csv
	gosling-stampede Fe.dmc_${t}.log | grep 'weight0' >> Fe.dmc_${t}.csv
	sed -i "s/+\/-//g" Fe.dmc_${t}.csv
	sed -i "s/(sigma//g" Fe.dmc_${t}.csv
	sed -i "s/)//g" Fe.dmc_${t}.csv
	
	dmc=`gosling-stampede Fe.dmc_${t}.log | grep 'total_energy0' | awk '{print $2}'`
	std=`gosling-stampede Fe.dmc_${t}.log | grep 'total_energy0' | awk '{print $4}'`
	echo ${t} $dmc $std >> timedmc.csv
done

python timedmc.py > timedmc.log


