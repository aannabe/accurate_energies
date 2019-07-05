#!/bin/bash -l
#SBATCH -J Ca_rcisd
#SBATCH -q shared
#!SBATCH -q debug
#SBATCH -n 8
#SBATCH -C haswell
#!SBATCH -t 00:59:00
#SBATCH -t 00:29:00
#!SBATCH -o slurm.o%j
#SBATCH -o Ca_rcisd.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro -s -n 4 ${i}.com
done


