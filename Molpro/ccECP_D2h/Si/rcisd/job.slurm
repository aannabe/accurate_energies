#!/bin/bash -l
#SBATCH -J Si_rcisd
#SBATCH -q shared
#SBATCH -n 1
#SBATCH -C haswell
#SBATCH -t 05:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o Si_rcisd.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro -n 1 ${i}.com
done


