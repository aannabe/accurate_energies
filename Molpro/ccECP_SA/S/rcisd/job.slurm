#!/bin/bash -l
#SBATCH -J S_rcisd
#SBATCH -q debug
#SBATCH -n 1
#SBATCH -C haswell
#SBATCH -t 00:29:00
#!SBATCH -o slurm.o%j
#SBATCH -o S_rcisd.out

module load molpro

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro -n 1 ${i}.com
done


