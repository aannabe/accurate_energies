#!/bin/bash
#SBATCH -J Se_DZ			# job name
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
#g16 < Se.gjf > Se.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Se/DZ/Se.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Se/DZ/Se.log .

cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Se/DZ/Se.h5 Se.log.h5

### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

#convert4qmc -gamess Se.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf Se.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.ccECP.xml Se.qmcpp.xml
sed -i 's/rcut="5"/rcut="10.0"/g' Se.log.wfj.xml
sed -i 's/rcut="10"/rcut="10.0"/g' Se.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Se.log.wfj.xml

echo "Entering J12 optimization"
cd J12
sed -i 's/atom/Se/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Se.log.qmc.in-wfj.xml
cp ../Se.log.wfj.xml .
cp ../Se.log.h5 .
cp ../Se.log.structure.xml .
cp ../Se.qmcpp.xml .
ibrun -n 1024 qmcpack Se.log.qmc.in-wfj.xml > qmc.out

echo "Entering J3 optimization"
cd ../J3
sed -i 's/atom/Se/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Se.log.qmc.in-wfj.xml
cp ../J12/Se.log.s020.opt.xml Se.log.wfj.xml
cp ../Se.log.h5 .
cp ../Se.log.structure.xml .
cp ../Se.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Se.log.wfj.xml
ibrun -n 1024 qmcpack Se.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

