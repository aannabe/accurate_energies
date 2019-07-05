#!/bin/bash
#SBATCH -J Be_TZ_PBE			# job name
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
#g16 < Be.gjf > Be.out
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Be/TZ_PBE/Be.dat .
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Be/TZ_PBE/Be.log .


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

convert4qmc -gamess Be.log -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Be/ccECP/Be.ccECP.xml Be.qmcpp.xml
#cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Be/ccECP_He_core/Be.ccECP.xml Be.qmcpp.xml
sed -i 's/rcut="5"/rcut="10.0"/g' Be.log.wfj.xml
sed -i 's/rcut="10"/rcut="10.0"/g' Be.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Be.log.wfj.xml

cd J12
sed -i 's/atom/Be/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Be.log.qmc.in-wfj.xml
cp ../Be.log.wfj.xml .
cp ../Be.log.orbs.h5 .
cp ../Be.log.structure.xml .
cp ../Be.qmcpp.xml .
ibrun -n 1024 qmcpack Be.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/Be/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Be.log.qmc.in-wfj.xml
cp ../J12/Be.log.s020.opt.xml Be.log.wfj.xml
cp ../Be.log.orbs.h5 .
cp ../Be.log.structure.xml .
cp ../Be.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Be.log.wfj.xml
ibrun -n 1024 qmcpack Be.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

