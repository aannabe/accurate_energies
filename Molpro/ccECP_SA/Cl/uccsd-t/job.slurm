#!/bin/bash -l
#SBATCH -J Cl_uccsd-t
#SBATCH -q shared
#SBATCH -n 1
#SBATCH -C haswell
#SBATCH -t 07:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o Cl_uccsd-t.out

module load molpro

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro -n 1 ${i}.com
done


