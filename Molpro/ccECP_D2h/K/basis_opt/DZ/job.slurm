#!/bin/bash -l
#SBATCH -J K_DZ
#SBATCH -q shared
#!SBATCH -q debug
#SBATCH -n 4
#SBATCH -C haswell
#SBATCH -t 03:29:00
#!SBATCH -o slurm.o%j
#SBATCH -o slurm.out

module load molpro
#module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node

#molpro -s -n 4 mol.com
molpro -s -n 4 atom.com

