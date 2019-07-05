#!/bin/bash -l
#SBATCH -J Ne_rccsd-t
#SBATCH -q shared
#!SBATCH -q debug
#SBATCH -n 4
#SBATCH -C haswell
#SBATCH -t 01:59:00
#!SBATCH -t 47:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o Ne_rccsd-t.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=5; i<=5; i++))
do
	molpro -s -n 4 ${i}.com
done


