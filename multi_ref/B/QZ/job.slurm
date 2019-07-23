#!/bin/bash
#SBATCH -J Be   		# job name
#SBATCH -o myMPI.o%j		# output and error file name (%j expands to jobID)
#SBATCH -N 16			# total number of mpi tasks requested
#SBATCH -n 1088			# total number of mpi tasks requested
#!SBATCH -p normal		# queue (partition) -- normal, development, etc.
#SBATCH -p development
#!SBATCH -t 00:09:00		# run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00		# run time (hh:mm:ss) - 1.5 hours

module load intel

solid='B'
nconfig=1			# Walkers per core
dmc_timestep="0.02,0.01,0.005,0.0025"		# DMC timestep
dmc_blocks=100			# DMC blocks

compile='-stampede'
runner=ibrun       		# mpirun vs ibrun
cores=$SLURM_NTASKS		# Total number of cores

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mkdir qmc
cd qmc

#### Copy necessary files
cp ../qwalk.jast3 .
cp ../qwalk.basis .
cp ../qwalk.sys .
cp ../qwalk.slater .
cp ../qwalk.orb .

generate_qw_atom qwalk $nconfig $dmc_blocks
run_qw_opt_atom qwalk $cores $compile $runner
run_qw_dmc_atom qwalk $cores $compile $runner $dmc_timestep 
analyze_qw_dmc_atom qwalk.dmc.log $compile $dmc_timestep
cd ../



