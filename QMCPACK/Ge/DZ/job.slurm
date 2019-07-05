#!/bin/bash
#SBATCH -J Ge_DZ			# job name
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
#g16 < Ge.gjf > Ge.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ge/DZ/Ge.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ge/DZ/Ge.log .

cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ge/DZ/Ge.h5 Ge.log.h5

### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

#convert4qmc -gamess Ge.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf Ge.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Ge/ccECP/Ge.ccECP.xml Ge.qmcpp.xml
sed -i 's/rcut="5"/rcut="10.0"/g' Ge.log.wfj.xml
sed -i 's/rcut="10"/rcut="10.0"/g' Ge.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Ge.log.wfj.xml

echo "Entering J12 optimization"
cd J12
sed -i 's/atom/Ge/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ge.log.qmc.in-wfj.xml
cp ../Ge.log.wfj.xml .
cp ../Ge.log.h5 .
cp ../Ge.log.structure.xml .
cp ../Ge.qmcpp.xml .
ibrun -n 1024 qmcpack Ge.log.qmc.in-wfj.xml > qmc.out

echo "Entering J3 optimization"
cd ../J3
sed -i 's/atom/Ge/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ge.log.qmc.in-wfj.xml
cp ../J12/Ge.log.s020.opt.xml Ge.log.wfj.xml
cp ../Ge.log.h5 .
cp ../Ge.log.structure.xml .
cp ../Ge.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Ge.log.wfj.xml
ibrun -n 1024 qmcpack Ge.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

