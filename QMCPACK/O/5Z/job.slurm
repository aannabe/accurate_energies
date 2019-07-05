#!/bin/bash
#SBATCH -J O_5Z			# job name
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
#g16 < O.gjf > O.out
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/O/5Z/O.dat .
#cp /work/04843/aannabe/stampede2/docs/accurate/qwalk/O/5Z/O.log .

cp /work/04843/aannabe/stampede2/repos/scripts/pp_totals/qwalk/pyscf_tm/O/5Z/O.h5 O.log.h5

### ~~~~~~~~~ QMOPAOK ~~~~~~~~~~~~

#convert4qmc -gamess O.log -hdf5 #-production -threshold 1e-20 
convert4qmc -pyscf O.log.h5 -hdf5 #-production -threshold 1e-20 
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/O/ccECP/O.ccECP.xml O.qmcpp.xml
sed -i 's/rcut="5"/rcut="6.5"/g' O.log.wfj.xml
sed -i 's/rcut="10"/rcut="6.5"/g' O.log.wfj.xml
sed -i 's/optimize="yes"/optimize="no"/g' O.log.wfj.xml

cd J12
sed -i 's/atom/O/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml O.log.qmc.in-wfj.xml
cp ../O.log.wfj.xml .
cp ../O.log.h5 .
cp ../O.log.structure.xml .
cp ../O.qmcpp.xml .
ibrun -n 1024 qmcpack O.log.qmc.in-wfj.xml > qmc.out

cd ../J3
sed -i 's/atom/O/g' atom.log.qmc.in-wfj.xml
mv atom.log.qmc.in-wfj.xml O.log.qmc.in-wfj.xml
cp ../J12/O.log.s020.opt.xml O.log.wfj.xml
cp ../O.log.h5 .
cp ../O.log.structure.xml .
cp ../O.qmcpp.xml .
sed -i 's/optimize="no"/optimize="yes"/g' O.log.wfj.xml
ibrun -n 1024 qmcpack O.log.qmc.in-wfj.xml > qmc.out

#qmc-fit ts -e 20 -b 2 -s 22 -t '0.02 0.01 0.005' *scalar*

