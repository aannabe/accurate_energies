#!/bin/bash
#SBATCH -J C_TZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                   # total number of mpi tasks requested
#SBATCH -n 1024                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 00:59:00            # run time (hh:mm:ss) - 1.5 hours

#module load gaussian
#export OMP_NUM_THREADS=64

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#g16 < C.gjf > C.out
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/C/TZ/C.dat .
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/C/TZ/C.log .

### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

convert4qmc -gamess C.log -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/C/ccECP/C.ccECP.xml C.qmcpp.xml
sed -i 's/rcut="5"/rcut="6.5"/g' C.log.wfj.xml
sed -i 's/rcut="10"/rcut="6.5"/g' C.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' C.log.wfj.xml

cd J12
sed -i 's/atom/C/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml C.log.qmc.in-wfj.xml
cp ../C.log.wfj.xml .
cp ../C.log.orbs.h5 .
cp ../C.log.structure.xml .
cp ../C.qmcpp.xml .
ibrun -n 1024 qmcpack C.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/C/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml C.log.qmc.in-wfj.xml
cp ../J12/C.log.s020.opt.xml C.log.wfj.xml
cp ../C.log.orbs.h5 .
cp ../C.log.structure.xml .
cp ../C.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' C.log.wfj.xml
ibrun -n 1024 qmcpack C.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

