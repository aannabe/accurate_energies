#!/bin/bash
#SBATCH -J Zn_QZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 32                   # total number of mpi tasks requested
#SBATCH -n 32                   # total number of mpi tasks requested
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
#rungms Zn.inp > Zn.out

##cp ../mini/success.chk Zn.chk
#g16 < Zn.gjf > Zn.log

### ~~~~~~~~  Convert to QP format ~~~~~~~~~~~~~~
#qp_convert_output_to_ezfio.py Zn.out -o Zn.ezfio
#echo 'Write' > Zn.ezfio/integrals_bielec/disk_access_ao_integrals
#echo 'Write' > Zn.ezfio/integrals_bielec/disk_access_mo_integrals
#qp_run print_energy Zn.ezfio > print_energy.out

#####ibrun -np 15 qp_run -slave qp_ao_ints Zn.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF Zn.ezfio &> Zn.scf
######ibrun -np 20 qp_run -slave qp_ao_ints Zn.ezfio &> Zn.scf-slave

#### ~~~~~~~~ Start iterative ZMQ runs ~~~~~~~~~~~~~~~~~

echo '100000' > Zn.ezfio/determinants/n_det_max
#echo '1e-12' > Zn.ezfio/davidson/threshold_davidson
echo 'T' > Zn.ezfio/davidson/distributed_davidson
#echo 'T' > Zn.ezfio/determinants/store_full_h_mat

ibrun -n 1 qp_run fci_zmq Zn.ezfio &> Zn.zmq_0 &
sleep 10
echo "Attempting to start slave processes..."
ibrun -n 31 qp_run -slave selection_davidson_slave Zn.ezfio &> Zn.zmq-slave
wait


qp_run save_natorb Zn.ezfio
echo '2000000' > Zn.ezfio/determinants/n_det_max
ibrun -n 1 qp_run fci_zmq Zn.ezfio &> Zn.zmq_1 &
sleep 10
echo "Attempting to start slave processes..."
ibrun -n 31 qp_run -slave selection_davidson_slave Zn.ezfio &> Zn.zmq-slave
wait


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

##echo '1e-08' > Zn.ezfio/qmc/ci_threshold
#qp_run truncate_wf_spin Zn.ezfio &> Zn.trunc
#qp_run save_for_qmcpack Zn.ezfio &> Zn.dump
##convert4qmc -QP Zn.dump -add3BodyJ -hdf5
##convert4qmc -QP Zn.dump -threshold 1e-20 -production
#convert4qmc -QP Zn.dump -threshold 1e-20

### Check QP energy
#ibrun -n 1088 qmcpack Zn.dump.qmc.in-wfnoj.xml > qmc.qp
##ibrun -n 48 qmcpack Zn.dump.qmc.in-wfj.xml > qmc.jast


#qmcpack --dryrun Zn.dump.qmc.in-wfj.xml > qmc.out
#ibrun -n 48 qmcpack Zn.dump.qmc.in-wfj.xml > qmc.out
#qmcpack Zn.dump.qmc.in-wfj.xml > qmc.out



