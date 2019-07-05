#!/bin/bash -l
#SBATCH -J Ca_uccsd-t
#SBATCH -q shared
#!SBATCH -q debug
#SBATCH -n 4
#SBATCH -C haswell
#!SBATCH -t 00:59:00
#SBATCH -t 00:19:00
#!SBATCH -o slurm.o%j
#SBATCH -o Ca_uccsd-t.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=6; i<=6; i++))
do
	molpro -n 2 ${i}.com
done


