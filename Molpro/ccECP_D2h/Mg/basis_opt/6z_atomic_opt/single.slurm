#!/bin/bash -l
#SBATCH -J 1st_row
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:05:00
#!SBATCH -o slurm.o%j
#SBATCH -o slurm.out

module load molpro
#module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node

#molpro -s -n 4 single.com
molpro -s -n 4 double.com

