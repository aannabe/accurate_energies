#!/bin/bash
#SBATCH -J Fe_5Z			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                    # total number of mpi tasks requested
#SBATCH -n 24                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#SBATCH -p skx-dev
#!SBATCH -t 47:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 00:59:00            # run time (hh:mm:ss) - 1.5 hours

module load intel/18.0.2
module load gamess

rungms Fe.inp > Fe.out

#source /work/04843/aannabe/stampede2/codes/quantum_package/quantum_package.rc
#qp_convert_output_to_ezfio.py Fe.out -o Fe.ezfio
#qp_run print_energy Fe.ezfio

#qp_edit Fe.ezfio 	# Edit disk_access_ao_integrals Write
#ibrun -np 1 qp_run SCF Fe.ezfio > Fe.scf


#qp_run fci_zmq Fe.ezfio > Fe.zmq
