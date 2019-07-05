#!/bin/bash -l
#SBATCH -J O_rcisd
#SBATCH -q shared
#SBATCH -n 1
#SBATCH -C haswell
#SBATCH -t 00:29:00
#!SBATCH -o slurm.o%j
#SBATCH -o O_rcisd.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=8; i++))
do
	molpro ${i}.com
done


