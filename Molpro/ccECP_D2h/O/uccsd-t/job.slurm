#!/bin/bash -l
#SBATCH -J O
#SBATCH -q shared
#SBATCH -n 1
#SBATCH -C haswell
#SBATCH -t 01:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o O_uccsdt.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


molpro 6.com
