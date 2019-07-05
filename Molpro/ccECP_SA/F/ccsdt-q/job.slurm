#!/bin/bash -l
#SBATCH -J F_ccsdt-q
#SBATCH -q shared
#SBATCH -n 16
#SBATCH -C haswell
#SBATCH -t 47:49:00
#!SBATCH -o slurm.o%j
#SBATCH -o F_ccsdt-q.out

module load molpro

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=5; i++))
do
	molpro -n 1 ${i}.com
done


