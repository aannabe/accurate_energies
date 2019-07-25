#!/bin/bash

#~~~~~~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~~~~~~~~~

#declare -a methods=("ccsdt-q" "fci" "rccsd-t" "rcisd" "uccsd-t")
#declare -a methods=("ccsdt-q")
declare -a methods=("rccsd-t" "uccsd-t" "rcisd")

#declare -a ptable=("B" "C" "N" "F"
#		"Mg" "Al" "Si" "P" "S" "Cl" "Ar")
#declare -a ptable=("Sc" "Ti" "V" "Cr" "Mn" "Fe" "Co" "Ni" "Cu" "Zn")
#declare -a ptable=("Sc" "Ti" "V" "Cr" "Mn" "Fe" "Co" "Ni" "Cu" "Zn")
declare -a ptable=("Ni" "Fe" "Co")

folder=/global/homes/a/aannabe/docs/totals_stu_symm	#Where to generate

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for i in "${ptable[@]}"
do
	for j in "${methods[@]}"
	do
		cd $folder/$i/$j
		sbatch job.slurm
	done

done
