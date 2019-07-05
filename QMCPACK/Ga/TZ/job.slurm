#!/bin/bash
#SBATCH -J Ga_TZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                   # total number of mpi tasks requested
#SBATCH -n 1024                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours

#export OMP_NUM_THREADS=64

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#g16 < Ga.gjf > Ga.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ga/TZ/Ga.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ga/TZ/Ga.log .

cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ga/TZ/Ga.h5 Ga.log.h5

### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

#convert4qmc -gamess Ga.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf Ga.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Ga/ccECP/Ga.ccECP.xml Ga.qmcpp.xml
sed -i 's/rcut="5"/rcut="10.0"/g' Ga.log.wfj.xml
sed -i 's/rcut="10"/rcut="10.0"/g' Ga.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Ga.log.wfj.xml

echo "Entering J12 optimization"
cd J12
sed -i 's/atom/Ga/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ga.log.qmc.in-wfj.xml
cp ../Ga.log.wfj.xml .
cp ../Ga.log.h5 .
cp ../Ga.log.structure.xml .
cp ../Ga.qmcpp.xml .
ibrun -n 1024 qmcpack Ga.log.qmc.in-wfj.xml > qmc.out

echo "Entering J3 optimization"
cd ../J3
sed -i 's/atom/Ga/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ga.log.qmc.in-wfj.xml
cp ../J12/Ga.log.s020.opt.xml Ga.log.wfj.xml
cp ../Ga.log.h5 .
cp ../Ga.log.structure.xml .
cp ../Ga.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Ga.log.wfj.xml
ibrun -n 1024 qmcpack Ga.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

