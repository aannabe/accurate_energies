#!/bin/bash
#SBATCH -J Ti_TZ			# job name
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
#g16 < Ti.gjf > Ti.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ti/TZ/Ti.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ti/TZ/Ti.log .

cp /work/04843/aannabe/stampede2/repos/scripts/pp_totals/qwalk/pyscf_tm/Ti/QZ/Ti.h5 Ti.log.h5

### ~~~~~~~~~ QMTiPATiK ~~~~~~~~~~~~

#convert4qmc -gamess Ti.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf Ti.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Ti/ccECP/Ti.ccECP.xml Ti.qmcpp.xml
sed -i 's/rcut="5"/rcut="12.1"/g' Ti.log.wfj.xml
sed -i 's/rcut="10"/rcut="12.1"/g' Ti.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Ti.log.wfj.xml

cd J12
sed -i 's/atom/Ti/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ti.log.qmc.in-wfj.xml
cp ../Ti.log.wfj.xml .
cp ../Ti.log.h5 .
cp ../Ti.log.structure.xml .
cp ../Ti.qmcpp.xml .
ibrun -n 1024 qmcpack Ti.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/Ti/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ti.log.qmc.in-wfj.xml
cp ../J12/Ti.log.s020.opt.xml Ti.log.wfj.xml
cp ../Ti.log.h5 .
cp ../Ti.log.structure.xml .
cp ../Ti.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Ti.log.wfj.xml
ibrun -n 1024 qmcpack Ti.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

