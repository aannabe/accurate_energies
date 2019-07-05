#!/bin/bash -l
#SBATCH -J Fe_rcisd
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:29:00
#!SBATCH -o slurm.o%j
#SBATCH -o Fe_rcisd.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=5; i<=5; i++))
do
	molpro -s -n 1 ${i}.com
done


