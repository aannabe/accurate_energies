#!/bin/bash -l
#SBATCH -J Be_rcisd
#SBATCH -q shared
#!SBATCH -q debug
#SBATCH -n 16
#SBATCH -C haswell
#SBATCH -t 00:29:00
#!SBATCH -t 47:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o Be_rcisd.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro -s -n 1 ${i}.com
done


