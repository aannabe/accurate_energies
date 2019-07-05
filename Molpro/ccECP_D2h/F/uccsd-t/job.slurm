#!/bin/bash -l
#SBATCH -J F_uccsd-t
#SBATCH -q shared
#!SBATCH -q debug
#SBATCH -n 4
#SBATCH -C haswell
#!SBATCH -t 00:59:00
#SBATCH -t 01:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o F_uccsd-t.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=6; i++))
do
	molpro -n 4 ${i}.com
done


