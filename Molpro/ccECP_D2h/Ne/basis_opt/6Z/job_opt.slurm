#!/bin/bash -l
#SBATCH -J Ne
#SBATCH -q shared
#SBATCH -n 6
#SBATCH -C haswell
#SBATCH -t 17:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o slurm.out

module load molpro
#module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node

molpro -s -n 6 atom.com

