#!/bin/bash -l
#SBATCH -J Mg_He
#SBATCH -q shared
#SBATCH -n 4
#SBATCH -C haswell
#SBATCH -t 15:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o slurm.out

module load molpro
#module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node

#molpro -s -n 4 dimer.com
molpro -s -n 4 atom.com

