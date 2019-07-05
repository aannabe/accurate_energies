#!/bin/bash
#SBATCH -J Ne_5z			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                    # total number of mpi tasks requested
#SBATCH -n 64                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#SBATCH -p development
#!SBATCH -t 47:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours


module load python3
module load intel

#### ~~~~~~~~ CONSTANTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

N_OPT=3
declare -a timestep=("0.02" "0.01" "0.005" "0.001")


### Things that already need to be ready:
### Ne.inp
### Ne.hf	No initial conf
### Ne.vmc	HF initial conf, initial opt.wfout
### Ne.dmc
### Ne.opt       HF initial conf
### Ne.linear    VMC initial conf

### ~~~~~~~~~~~~~~~~~~~~~~~~ HF ~~~~~~~~~~~~~~~~~~~~~

#rungms Ne.inp > Ne.log
#
#if grep -q 'EXECUTION OF GAMESS TERMINATED NORMALLY' Ne.log; then
#	echo 'GAMESS exited successfully'
#else
#	echo 'GAMESS exited with errors; aborting'
#	exit 1
#fi
#
#gamess_hf=`grep 'TOTAL ENERGY =' Ne.log | awk '{print $4}'`
#echo "GAMESS HF:"
#echo $gamess_hf
#
### Convert GAMESS orbitals to qwalk
#gamess2qmc-stampede Ne
#cp ../Ne.jast3 .
#
### Run HF WFN to check and to distrubate configurations
#mpirun -np 64 qwalk-stampede Ne.hf
#
#qwalk_hf=`gosling-stampede Ne.hf.log | grep 'total_energy0' | awk '{print $2}'`
#echo "QWALK HF:"
#echo $qwalk_hf
#
#diff=`echo "print(abs($gamess_hf-$qwalk_hf))" | python`
#echo "HF Difference:"
#echo $diff
#thresh=0.001
#res=`echo "res = 1 if $diff > $thresh else 0 ; print(res)" | python`
#echo $res
#
#if [ "$res" -eq 1 ]
#then
#	echo "HF numbers don't match; aborting"
##	exit 1
#else
#	echo "HF numbers look good"
#fi


### ~~~~~~~~~~~~~~ OPTIMIZATION ~~~~~~~~~~~~~~~~~~~~~~~~~~


#mpirun -np 64 qwalk-stampede Ne.opt
#mpirun -np 64 qwalk-stampede Ne.vmc
#sed s/OPTIMIZEBASIS//g Ne.opt.wfout > fixed_basis.wf
#mpirun -np 64 qwalk-stampede Ne.linear
#cp Ne.linear.wfout Ne.last.wfout
#cp Ne.vmc.config Ne.vmci.config
#
#for ((i=0; i<$N_OPT; i++))
#do
#	echo "Optimization Round:"
#	echo $i
#	mpirun -np 64 qwalk-stampede Ne.var
#	cp Ne.var.wfout Ne.last.wfout
#	mpirun -np 64 qwalk-stampede Ne.vmci
#	sed s/OPTIMIZEBASIS//g Ne.last.wfout > fixed_basis.wf
#	mpirun -np 64 qwalk-stampede Ne.linear
#	cp Ne.linear.wfout Ne.last.wfout
#done


#### ~~~~~~~~~~~ CHECK FINAL VMC ENERGY ~~~~~~~~~~~~~~~~

#mpirun -np 64 qwalk-stampede Ne.vmcf

### ~~~~~~~~~~~~~~ DMC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#sed -i 's/READCONFIG Ne.dmci.config/READCONFIG Ne.vmci.config/g' Ne.dmc_${timestep[0]}

#for t in "${timestep[@]}"
#do
#	mpirun -np 64 qwalk-stampede Ne.dmc_${t}
#	cp Ne.dmc_${t}.config Ne.dmci.config
#done


### ~~~~~~~~~~~~ POST-PROCESSING ~~~~~~~~~~~~~~~~~~~

echo 'Timestep DMC STD' > timedmc.csv
for t in "${timestep[@]}"
do
	echo 'Type Energy STD Sigma' > Ne.dmc_${t}.csv
	gosling-stampede Ne.dmc_${t}.log | grep 'total_energy0' >> Ne.dmc_${t}.csv
	gosling-stampede Ne.dmc_${t}.log | grep 'kinetic0' >> Ne.dmc_${t}.csv 
	gosling-stampede Ne.dmc_${t}.log | grep 'potential0' >> Ne.dmc_${t}.csv
	gosling-stampede Ne.dmc_${t}.log | grep 'nonlocal0' >> Ne.dmc_${t}.csv
	gosling-stampede Ne.dmc_${t}.log | grep 'weight0' >> Ne.dmc_${t}.csv
	sed -i "s/+\/-//g" Ne.dmc_${t}.csv
	sed -i "s/(sigma//g" Ne.dmc_${t}.csv
	sed -i "s/)//g" Ne.dmc_${t}.csv
	
	dmc=`gosling-stampede Ne.dmc_${t}.log | grep 'total_energy0' | awk '{print $2}'`
	std=`gosling-stampede Ne.dmc_${t}.log | grep 'total_energy0' | awk '{print $4}'`
	echo ${t} $dmc $std >> timedmc.csv
done

python timedmc.py


