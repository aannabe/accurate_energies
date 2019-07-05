#!/bin/bash
#SBATCH -J P_TZ			# job name
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
#g16 < P.gjf > P.out
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/P/TZ/P.dat .
cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/P/TZ/P.log .

### ~~~~~~~~~ QMPPAPK ~~~~~~~~~~~~

convert4qmc -gamess P.log -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/P/ccECP/P.ccECP.xml P.qmcpp.xml
sed -i 's/rcut="5"/rcut="9.5"/g' P.log.wfj.xml
sed -i 's/rcut="10"/rcut="9.5"/g' P.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' P.log.wfj.xml

cd J12
sed -i 's/atom/P/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml P.log.qmc.in-wfj.xml
cp ../P.log.wfj.xml .
cp ../P.log.orbs.h5 .
cp ../P.log.structure.xml .
cp ../P.qmcpp.xml .
ibrun -n 1024 qmcpack P.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/P/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml P.log.qmc.in-wfj.xml
cp ../J12/P.log.s020.opt.xml P.log.wfj.xml
cp ../P.log.orbs.h5 .
cp ../P.log.structure.xml .
cp ../P.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' P.log.wfj.xml
ibrun -n 1024 qmcpack P.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

