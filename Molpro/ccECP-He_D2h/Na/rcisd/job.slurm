#!/bin/bash -l
#SBATCH -J Na_rcisd
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:29:00
#!SBATCH -o slurm.o%j
#SBATCH -o Na_rcisd.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro ${i}.com
done


