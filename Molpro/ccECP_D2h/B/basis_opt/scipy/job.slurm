#!/bin/bash -l
#SBATCH -J 1st_row
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:30:00
#!SBATCH -o slurm.o%j
#SBATCH -o slurm.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node

#python minimize.py &

molpro atom.com
