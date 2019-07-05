#!/bin/bash
#SBATCH -J Ca_TZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                   # total number of mpi tasks requested
#SBATCH -n 1024                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours

#module load gaussian
#export OMP_NUM_THREADS=64

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#g16 < Ca.gjf > Ca.out
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ca/TZ/Ca.dat .
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ca/TZ/Ca.log .


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

convert4qmc -gamess Ca.log -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Ca/ccECP/Ca.ccECP.xml Ca.qmcpp.xml
sed -i 's/rcut="5"/rcut="15.0"/g' Ca.log.wfj.xml
sed -i 's/rcut="10"/rcut="15.0"/g' Ca.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Ca.log.wfj.xml

cd J12
sed -i 's/atom/Ca/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ca.log.qmc.in-wfj.xml
cp ../Ca.log.wfj.xml .
cp ../Ca.log.orbs.h5 .
cp ../Ca.log.structure.xml .
cp ../Ca.qmcpp.xml .
ibrun -n 1024 qmcpack Ca.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/Ca/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ca.log.qmc.in-wfj.xml
cp ../J12/Ca.log.s020.opt.xml Ca.log.wfj.xml
cp ../Ca.log.orbs.h5 .
cp ../Ca.log.structure.xml .
cp ../Ca.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Ca.log.wfj.xml
ibrun -n 1024 qmcpack Ca.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

