#!/bin/bash
#SBATCH -J Co_TZ			# job name
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
#g16 < Co.gjf > Co.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Co/TZ/Co.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/Co/TZ/Co.log .

cp /work/04843/aannabe/stampede2/repos/scripts/pp_totals/qwalk/pyscf_tm/Co/QZ/Co.h5 Co.log.h5

### ~~~~~~~~~ QMCoPACoK ~~~~~~~~~~~~

#convert4qmc -gamess Co.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf Co.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Co/ccECP/Co.ccECP.xml Co.qmcpp.xml
sed -i 's/rcut="5"/rcut="12.1"/g' Co.log.wfj.xml
sed -i 's/rcut="10"/rcut="12.1"/g' Co.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' Co.log.wfj.xml

cd J12
sed -i 's/atom/Co/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Co.log.qmc.in-wfj.xml
cp ../Co.log.wfj.xml .
cp ../Co.log.h5 .
cp ../Co.log.structure.xml .
cp ../Co.qmcpp.xml .
ibrun -n 1024 qmcpack Co.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/Co/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml Co.log.qmc.in-wfj.xml
cp ../J12/Co.log.s020.opt.xml Co.log.wfj.xml
cp ../Co.log.h5 .
cp ../Co.log.structure.xml .
cp ../Co.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' Co.log.wfj.xml
ibrun -n 1024 qmcpack Co.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

