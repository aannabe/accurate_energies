#!/bin/bash
#SBATCH -J Ni_QZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                   # total number of mpi tasks requested
#SBATCH -n 1024                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours

#module load gaussian
#export OMP_NUM_THREADS=64

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#g16 < Ni.gjf > Ni.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ni/TZ/Ni.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Ni/TZ/Ni.log .

cp /work/04843/aannabe/stampede2/repos/scripts/pp_totals/qwalk/pyscf_tm/Ni_4s/QZ/Ni.h5 Ni.log.h5

### ~~~~~~~~~ QMNiPANiK ~~~~~~~~~~~~

#convert4qmc -gamess Ni.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf Ni.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Ni/ccECP/Ni.ccECP.xml Ni.qmcpp.xml
sed -i 's/rcut="5"/rcut="12.1"/g' Ni.log.wfj.xml
sed -i 's/rcut="10"/rcut="12.1"/g' Ni.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Ni.log.wfj.xml

cd J12
sed -i 's/atom/Ni/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ni.log.qmc.in-wfj.xml
cp ../Ni.log.wfj.xml .
cp ../Ni.log.h5 .
cp ../Ni.log.structure.xml .
cp ../Ni.qmcpp.xml .
ibrun -n 1024 qmcpack Ni.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/Ni/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Ni.log.qmc.in-wfj.xml
cp ../J12/Ni.log.s020.opt.xml Ni.log.wfj.xml
cp ../Ni.log.h5 .
cp ../Ni.log.structure.xml .
cp ../Ni.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Ni.log.wfj.xml
ibrun -n 1024 qmcpack Ni.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005 0.0025' *scalar*

