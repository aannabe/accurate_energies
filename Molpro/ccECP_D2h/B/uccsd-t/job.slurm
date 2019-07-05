#!/bin/bash -l
#SBATCH -J B_uccsd-t
#SBATCH -q shared
#SBATCH -n 1
#SBATCH -C haswell
#SBATCH -t 11:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o B_uccsd-t.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro ${i}.com
done


