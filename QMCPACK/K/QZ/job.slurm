#!/bin/bash
#SBATCH -J K_QZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                   # total number of mpi tasks requested
#SBATCH -n 1024                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours

#module load gaussian
#export OMP_NUM_THREADS=64

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#g16 < K.gjf > K.out
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/K/QZ/K.dat .
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/K/QZ/K.log .


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

convert4qmc -gamess K.log -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/K/ccECP/K.ccECP.xml K.qmcpp.xml
sed -i 's/rcut="5"/rcut="18.0"/g' K.log.wfj.xml
sed -i 's/rcut="10"/rcut="18.0"/g' K.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' K.log.wfj.xml

cd J12
sed -i 's/atom/K/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml K.log.qmc.in-wfj.xml
cp ../K.log.wfj.xml .
cp ../K.log.orbs.h5 .
cp ../K.log.structure.xml .
cp ../K.qmcpp.xml .
ibrun -n 1024 qmcpack K.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/K/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml K.log.qmc.in-wfj.xml
cp ../J12/K.log.s020.opt.xml K.log.wfj.xml
cp ../K.log.orbs.h5 .
cp ../K.log.structure.xml .
cp ../K.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' K.log.wfj.xml
ibrun -n 1024 qmcpack K.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

