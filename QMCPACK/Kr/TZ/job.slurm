#!/bin/bash
#SBATCH -J Kr_TZ			# job name
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
#g16 < Kr.gjf > Kr.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Kr/TZ/Kr.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Kr/TZ/Kr.log .

cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Kr/TZ/Kr.h5 Kr.log.h5

### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

#convert4qmc -gamess Kr.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf Kr.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Kr/ccECP/Kr.ccECP.xml Kr.qmcpp.xml
sed -i 's/rcut="5"/rcut="10.0"/g' Kr.log.wfj.xml
sed -i 's/rcut="10"/rcut="10.0"/g' Kr.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Kr.log.wfj.xml

echo "Entering J12 optimization"
cd J12
sed -i 's/atom/Kr/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Kr.log.qmc.in-wfj.xml
cp ../Kr.log.wfj.xml .
cp ../Kr.log.h5 .
cp ../Kr.log.structure.xml .
cp ../Kr.qmcpp.xml .
ibrun -n 1024 qmcpack Kr.log.qmc.in-wfj.xml > qmc.out

echo "Entering J3 optimization"
cd ../J3
sed -i 's/atom/Kr/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Kr.log.qmc.in-wfj.xml
cp ../J12/Kr.log.s020.opt.xml Kr.log.wfj.xml
cp ../Kr.log.h5 .
cp ../Kr.log.structure.xml .
cp ../Kr.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Kr.log.wfj.xml
ibrun -n 1024 qmcpack Kr.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

