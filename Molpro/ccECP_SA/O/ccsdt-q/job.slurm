#!/bin/bash -l
#SBATCH -J O_ccsdt-q
#SBATCH -q shared
#SBATCH -n 16
#SBATCH -C haswell
#SBATCH -t 47:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o O_ccsdt-q.out

module load molpro

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro -n 1 ${i}.com
done


