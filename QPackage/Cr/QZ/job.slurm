#!/bin/bash
#SBATCH -J Cr_QZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 16                   # total number of mpi tasks requested
#SBATCH -n 16                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#SBATCH -t 47:59:00             # run time (hh:mm:ss) - 1.5 hours
#!SBATCH -t 00:59:00            # run time (hh:mm:ss) - 1.5 hours

module load python
module load gaussian
source /work/04843/aannabe/stampede2/codes/quantum_package/quantum_package.rc

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#export OMP_NUM_THREADS=16
#rungms Cr.inp > Cr.out

##cp ../mini/success.chk Cr.chk
#g16 < Cr.gjf > Cr.log

### ~~~~~~~~  Convert to QP format ~~~~~~~~~~~~~~
#qp_convert_output_to_ezfio.py Cr.out -o Cr.ezfio
#echo 'Write' > Cr.ezfio/integrals_bielec/disk_access_ao_integrals
#echo 'Write' > Cr.ezfio/integrals_bielec/disk_access_mo_integrals
#qp_run print_energy Cr.ezfio > print_energy.out

#####ibrun -np 15 qp_run -slave qp_ao_ints Cr.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF Cr.ezfio &> Cr.scf
######ibrun -np 20 qp_run -slave qp_ao_ints Cr.ezfio &> Cr.scf-slave

#### ~~~~~~~~ Start iterative ZMQ runs ~~~~~~~~~~~~~~~~~

echo '100000' > Cr.ezfio/determinants/n_det_max
#echo '1e-12' > Cr.ezfio/davidson/threshold_davidson
echo 'T' > Cr.ezfio/davidson/distributed_davidson
#echo 'T' > Cr.ezfio/determinants/store_full_h_mat

ibrun -n 1 qp_run fci_zmq Cr.ezfio &> Cr.zmq_0 &
sleep 10
echo "Attempting to start slave processes..."
ibrun -n 15 qp_run -slave selection_davidson_slave Cr.ezfio &> Cr.zmq-slave
wait


qp_run save_natorb Cr.ezfio
echo '2000000' > Cr.ezfio/determinants/n_det_max
ibrun -n 1 qp_run fci_zmq Cr.ezfio &> Cr.zmq_1 &
sleep 10
echo "Attempting to start slave processes..."
ibrun -n 15 qp_run -slave selection_davidson_slave Cr.ezfio &> Cr.zmq-slave
wait


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

##echo '1e-08' > Cr.ezfio/qmc/ci_threshold
#qp_run truncate_wf_spin Cr.ezfio &> Cr.trunc
#qp_run save_for_qmcpack Cr.ezfio &> Cr.dump
##convert4qmc -QP Cr.dump -add3BodyJ -hdf5
##convert4qmc -QP Cr.dump -threshold 1e-20 -production
#convert4qmc -QP Cr.dump -threshold 1e-20

### Check QP energy
#ibrun -n 1088 qmcpack Cr.dump.qmc.in-wfnoj.xml > qmc.qp
##ibrun -n 48 qmcpack Cr.dump.qmc.in-wfj.xml > qmc.jast


#qmcpack --dryrun Cr.dump.qmc.in-wfj.xml > qmc.out
#ibrun -n 48 qmcpack Cr.dump.qmc.in-wfj.xml > qmc.out
#qmcpack Cr.dump.qmc.in-wfj.xml > qmc.out



