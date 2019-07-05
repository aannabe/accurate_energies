#!/bin/bash -l
#SBATCH -J Mg_ccsdt-q
#SBATCH -q shared
#SBATCH -n 16
#SBATCH -C haswell
#SBATCH -t 47:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o Mg_ccsdt-q.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=3; i++))
do
	molpro ${i}.com
done


