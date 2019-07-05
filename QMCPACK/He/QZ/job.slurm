#!/bin/bash
#SBATCH -J He_TZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                   # total number of mpi tasks requested
#SBATCH -n 1024                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 00:19:00            # run time (hh:mm:ss) - 1.5 hours

#module load gaussian
#export OMP_NUM_THREADS=64

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#g16 < He.gjf > He.out
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/He/QZ/He.dat .
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/He/QZ/He.log .


### ~~~~~~~~~ QMHePAHeK ~~~~~~~~~~~~

convert4qmc -gamess He.log -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/He/ccECP/He.ccECP.xml He.qmcpp.xml
sed -i 's/rcut="5"/rcut="3.5"/g' He.log.wfj.xml
sed -i 's/rcut="10"/rcut="3.5"/g' He.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' He.log.wfj.xml

cd J12
sed -i 's/atom/He/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml He.log.qmc.in-wfj.xml
cp ../He.log.wfj.xml .
cp ../He.log.orbs.h5 .
cp ../He.log.structure.xml .
cp ../He.qmcpp.xml .
ibrun -n 1024 qmcpack He.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/He/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml He.log.qmc.in-wfj.xml
cp ../J12/He.log.s020.opt.xml He.log.wfj.xml
cp ../He.log.orbs.h5 .
cp ../He.log.structure.xml .
cp ../He.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' He.log.wfj.xml
ibrun -n 1024 qmcpack He.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

