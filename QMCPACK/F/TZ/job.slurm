#!/bin/bash
#SBATCH -J F_TZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                   # total number of mpi tasks requested
#SBATCH -n 1024                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 00:59:00            # run time (hh:mm:ss) - 1.5 hours

#module load gaussian
#export OMP_NUM_THREADS=64

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#g16 < F.gjf > F.out
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/F/TZ/F.dat .
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/F/TZ/F.log .


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

convert4qmc -gamess F.log -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/F/ccECP/F.ccECP.xml F.qmcpp.xml
#cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/F/ccECP_He_core/F.ccECP.xml F.qmcpp.xml
sed -i 's/rcut="5"/rcut="6.5"/g' F.log.wfj.xml
sed -i 's/rcut="10"/rcut="6.5"/g' F.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' F.log.wfj.xml

cd J12
sed -i 's/atom/F/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml F.log.qmc.in-wfj.xml
cp ../F.log.wfj.xml .
cp ../F.log.orbs.h5 .
cp ../F.log.structure.xml .
cp ../F.qmcpp.xml .
ibrun -n 1024 qmcpack F.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/F/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml F.log.qmc.in-wfj.xml
cp ../J12/F.log.s020.opt.xml F.log.wfj.xml
cp ../F.log.orbs.h5 .
cp ../F.log.structure.xml .
cp ../F.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' F.log.wfj.xml
ibrun -n 1024 qmcpack F.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

