#!/bin/bash

#~~~~~~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~~~~~~~~~
#memory='8,g'
memory='512,m'

N=2	#Basis set to start from
declare -a basis=("dz" "tz" "qz" "5z")
declare -a methods=("rccsd-t" "rcisd" "uccsd-t")
#declare -a methods=("ccsdt-q")
declare -a ptable=("Fe" "Co" "Ni")

folder=/global/homes/a/aannabe/docs/accurate/STU_natural	#Where to generate
config=/global/homes/a/aannabe/docs/accurate/STU_natural/wfs
meth=/global/homes/a/aannabe/docs/accurate/STU_natural/methods

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for i in "${ptable[@]}"
do
	for j in "${methods[@]}"
	do
		mkdir -p $folder/$i/$j
		a=$N	#Smallest basis set

		#Prepare the job
		sed "s/ATOM/$i/g" job.slurm > $folder/$i/$j/job.slurm
		sed -i "s/MY_METHOD/$j/g" $folder/$i/$j/job.slurm

		for k in "${basis[@]}"
		do
			wf=`cat $config/$i.wf`
			mm=`cat $meth/$j.meth`
			sed "s/MEMORY/$memory/g" blank.com > $folder/$i/$j/$a.com
			sed -i "s/ATOM/$i/g" $folder/$i/$j/$a.com
			sed -i "s/BASIS/$k/g" $folder/$i/$j/$a.com
			sed -i "s/CARDINAL/$a/g" $folder/$i/$j/$a.com
			sed -i "s/MY_METHOD/${mm//$'\n'/\\n}/g" $folder/$i/$j/$a.com
			sed -i "s/WAVEFUNCTION/${wf//$'\n'/\\n}/g" $folder/$i/$j/$a.com
			
			#echo $folder/$i/$j/$k
			#echo $a
			a=$((a+1))
		done

	done

done
