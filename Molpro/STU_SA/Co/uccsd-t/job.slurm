#!/bin/bash -l
#SBATCH -J Co_uccsd-t
#SBATCH -q shared
#SBATCH -n 1
#SBATCH -C haswell
#SBATCH -t 01:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o Co_uccsd-t.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=3; i<=5; i++))
do
	molpro -n 1 ${i}.com
done


