#!/bin/bash
#SBATCH -J Cr_TZ			# job name
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
#g16 < Cr.gjf > Cr.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Cr/TZ/Cr.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Cr/TZ/Cr.log .

cp /work/04843/aannabe/stampede2/repos/scripts/pp_totals/qwalk/pyscf_tm/Cr/QZ/Cr.h5 Cr.log.h5

### ~~~~~~~~~ QMCrPACrK ~~~~~~~~~~~~

#convert4qmc -gamess Cr.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf Cr.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Cr/ccECP/Cr.ccECP.xml Cr.qmcpp.xml
sed -i 's/rcut="5"/rcut="12.1"/g' Cr.log.wfj.xml
sed -i 's/rcut="10"/rcut="12.1"/g' Cr.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Cr.log.wfj.xml

cd J12
sed -i 's/atom/Cr/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Cr.log.qmc.in-wfj.xml
cp ../Cr.log.wfj.xml .
cp ../Cr.log.h5 .
cp ../Cr.log.structure.xml .
cp ../Cr.qmcpp.xml .
ibrun -n 1024 qmcpack Cr.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/Cr/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Cr.log.qmc.in-wfj.xml
cp ../J12/Cr.log.s020.opt.xml Cr.log.wfj.xml
cp ../Cr.log.h5 .
cp ../Cr.log.structure.xml .
cp ../Cr.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Cr.log.wfj.xml
ibrun -n 1024 qmcpack Cr.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

