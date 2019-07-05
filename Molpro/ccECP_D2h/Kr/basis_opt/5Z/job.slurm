#!/bin/bash -l
#SBATCH -J Br
#SBATCH -q shared
#SBATCH -n 4
#SBATCH -C haswell
#SBATCH -t 04:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o slurm.out

module load molpro
#module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node

molpro -s -n 4 atom.com

