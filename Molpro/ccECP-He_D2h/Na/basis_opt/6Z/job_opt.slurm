#!/bin/bash -l
#SBATCH -J Na_He
#SBATCH -q shared
#SBATCH -n 2
#SBATCH -C haswell
#SBATCH -t 05:29:00
#!SBATCH -o slurm.o%j
#SBATCH -o slurm.out

module load molpro
#module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node

#molpro -s -n 4 dimer.com
molpro -s -n 2 atom.com

