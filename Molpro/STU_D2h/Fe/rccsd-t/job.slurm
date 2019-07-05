#!/bin/bash -l
#SBATCH -J Fe_rccsd-t
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:29:00
#!SBATCH -o slurm.o%j
#SBATCH -o Fe_rccsd-t.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=5; i<=5; i++))
do
	molpro -n 1 -s ${i}.com
done


