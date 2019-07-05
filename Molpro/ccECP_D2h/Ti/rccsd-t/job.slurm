#!/bin/bash -l
#SBATCH -J Ti_rccsd-t
#!SBATCH -q shared
#SBATCH -q debug
#SBATCH -n 1
#SBATCH -C haswell
#!SBATCH -t 09:59:00
#SBATCH -t 00:19:00
#!SBATCH -o slurm.o%j
#SBATCH -o Ti_rccsd-t.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node


#for ((i=2; i<=5; i++))
#do
#	molpro -n 1 ${i}.com
#done


molpro -n 1 test.com

