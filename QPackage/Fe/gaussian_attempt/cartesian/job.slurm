#!/bin/bash
#SBATCH -J Fe_5Z			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                   # total number of mpi tasks requested
#SBATCH -n 1                  # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#SBATCH -p skx-dev
#!SBATCH -t 47:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours

module load python
module load gaussian

#export OMP_NUM_THREADS=16
###cp ../mini/success.chk Fe.chk
#g16 < Fe.gjf > Fe.log

source /work/04843/aannabe/stampede2/codes/quantum_package/quantum_package.rc
#qp_convert_output_to_ezfio.py Fe.log -o Fe.ezfio
echo 'Write' > Fe.ezfio/integrals_bielec/disk_access_ao_integrals
qp_run print_energy Fe.ezfio > print_energy.out

#####ibrun -np 15 qp_run -slave qp_ao_ints Fe.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF Fe.ezfio &> Fe.scf
######ibrun -np 20 qp_run -slave qp_ao_ints Fe.ezfio &> Fe.scf-slave

#qp_run save_natorb Fe.ezfio

echo '3000' > Fe.ezfio/determinants/n_det_max
#echo '1e-12' > Fe.ezfio/davidson/threshold_davidson
echo 'T' > Fe.ezfio/davidson/distributed_davidson
#echo 'T' > Fe.ezfio/determinants/store_full_h_mat
#
ibrun -n 1 qp_run fci_zmq Fe.ezfio &> Fe.zmq &
sleep 10
echo "Attempting to start slave processes..."
#ibrun -n 15 qp_run -slave selection_davidson_slave Fe.ezfio &> Fe.zmq-slave
wait

#qp_run save_natorb Fe.ezfio

###~~~~~~~~~QMCPACK~~~~~~~~~~~~

echo '1e-08' > Fe.ezfio/qmc/ci_threshold
qp_run truncate_wf_spin Fe.ezfio &> Fe.trunc
qp_run save_for_qmcpack Fe.ezfio &> Fe.dump
#convert4qmc -QP Fe.dump -add3BodyJ -hdf5
#convert4qmc -QP Fe.dump -threshold 1e-20 -production
convert4qmc -QP Fe.dump -threshold 1e-20

## Check QP energy
#ibrun -n 1088 qmcpack Fe.dump.qmc.in-wfnoj.xml > qmc.qp
##ibrun -n 48 qmcpack Fe.dump.qmc.in-wfj.xml > qmc.jast


#qmcpack --dryrun Fe.dump.qmc.in-wfj.xml > qmc.out
#ibrun -n 48 qmcpack Fe.dump.qmc.in-wfj.xml > qmc.out
#qmcpack Fe.dump.qmc.in-wfj.xml > qmc.out



