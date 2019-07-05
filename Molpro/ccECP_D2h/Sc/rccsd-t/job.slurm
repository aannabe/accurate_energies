#!/bin/bash -l
#SBATCH -J Sc_rccsd-t
#SBATCH -q shared
#!SBATCH -q debug
#SBATCH -n 1
#SBATCH -C haswell
#!SBATCH -t 47:59:00
#SBATCH -t 00:49:00
#!SBATCH -o slurm.o%j
#SBATCH -o Sc_rccsd-t.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


for ((i=2; i<=5; i++))
do
	molpro -n 1 ${i}.com
done


