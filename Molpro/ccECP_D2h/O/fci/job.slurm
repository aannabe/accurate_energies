#!/bin/bash -l
#SBATCH -J O
#SBATCH -q shared
#SBATCH -n 16
#SBATCH -C haswell
#SBATCH -t 23:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o O_fci.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=3; i++))
do
	molpro ${i}.com
done


