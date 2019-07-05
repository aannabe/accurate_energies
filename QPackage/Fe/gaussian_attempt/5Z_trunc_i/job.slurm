#!/bin/bash
#SBATCH -J Fe_5Z			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                   # total number of mpi tasks requested
#SBATCH -n 64                   # total number of mpi tasks requested
#SBATCH -p development
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -p skx-normal
#!SBATCH -t 47:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 00:59:00            # run time (hh:mm:ss) - 1.5 hours

module load python
module load gaussian

#export OMP_NUM_THREADS=16
###cp ../mini/success.chk Fe.chk
#g16 < Fe.gjf > Fe.log

source /work/04843/aannabe/stampede2/codes/quantum_package/quantum_package.rc
#qp_convert_output_to_ezfio.py Fe.log -o Fe.ezfio
#echo 'Write' > Fe.ezfio/integrals_bielec/disk_access_ao_integrals

###~~~~ Edit the EZFIO ~~~~~~~~~

#qp_run print_energy Fe.ezfio > print_energy.out

#####ibrun -np 1 qp_run print_energy Fe.ezfio &> print_energy.out &

#####ibrun -np 15 qp_run -slave qp_ao_ints Fe.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF Fe.ezfio &> Fe.scf
#####sleep 10
#####echo "Attempting to start slave processes..."
######ibrun -np 20 qp_run -slave qp_ao_ints Fe.ezfio &> Fe.scf-slave

#qp_run four_idx_transform Fe.ezfio

####ibrun -n 1 -o 0 task_affinity qp_run fci_zmq Fe.ezfio &> Fe.zmq &
####sleep 50
####echo "Attempting to start slave processes..."
####ibrun -n 47 -o 1 task_affinity qp_run -slave selection_davidson_slave Fe.ezfio &> Fe.zmq-slave &
####wait

#qp_run save_natorb Fe.ezfio
#qp_run four_idx_transform Fe.ezfio

#ibrun -n 1 qp_run fci_zmq Fe.ezfio &> Fe.zmq &
#sleep 10
#echo "Attempting to start slave processes..."
#ibrun -n 63 qp_run -slave selection_davidson_slave Fe.ezfio &> Fe.zmq-slave &
#wait


###~~~~~~~~~QMCPACK~~~~~~~~~~~~

#qp_run truncate_wf_spin Fe.ezfio &> Fe.trunc-8
#qp_run save_for_qmcpack Fe.ezfio &> Fe.dump
#convert4qmc -QP Fe.dump -add3BodyJ -hdf5
#convert4qmc -QP Fe.dump -threshold 1e-20

### Check QP energy
#ibrun -n 48 qmcpack Fe.dump.qmc.in-wfnoj.xml > qmc.qp


#qmcpack --dryrun Fe.dump.qmc.in-wfj.xml > qmc.out
#ibrun -n 48 qmcpack Fe.dump.qmc.in-wfj.xml > qmc.out
#qmcpack Fe.dump.qmc.in-wfj.xml > qmc.out



python myatom.py > nexus.log
