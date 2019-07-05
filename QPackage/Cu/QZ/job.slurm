#!/bin/bash
#SBATCH -J Cu_QZ			# job name
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
#rungms Cu.inp > Cu.out

##cp ../mini/success.chk Cu.chk
#g16 < Cu.gjf > Cu.log

### ~~~~~~~~  Convert to QP format ~~~~~~~~~~~~~~
#qp_convert_output_to_ezfio.py Cu.out -o Cu.ezfio
#echo 'Write' > Cu.ezfio/integrals_bielec/disk_access_ao_integrals
#echo 'Write' > Cu.ezfio/integrals_bielec/disk_access_mo_integrals
#qp_run print_energy Cu.ezfio > print_energy.out

#####ibrun -np 15 qp_run -slave qp_ao_ints Cu.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF Cu.ezfio &> Cu.scf
######ibrun -np 20 qp_run -slave qp_ao_ints Cu.ezfio &> Cu.scf-slave

#### ~~~~~~~~ Start iterative ZMQ runs ~~~~~~~~~~~~~~~~~

echo '100000' > Cu.ezfio/determinants/n_det_max
#echo '1e-12' > Cu.ezfio/davidson/threshold_davidson
echo 'T' > Cu.ezfio/davidson/distributed_davidson
#echo 'T' > Cu.ezfio/determinants/store_full_h_mat

ibrun -n 1 qp_run fci_zmq Cu.ezfio &> Cu.zmq_0 &
sleep 10
echo "Attempting to start slave processes..."
ibrun -n 31 qp_run -slave selection_davidson_slave Cu.ezfio &> Cu.zmq-slave
wait


qp_run save_natorb Cu.ezfio
echo '2000000' > Cu.ezfio/determinants/n_det_max
ibrun -n 1 qp_run fci_zmq Cu.ezfio &> Cu.zmq_1 &
sleep 10
echo "Attempting to start slave processes..."
ibrun -n 31 qp_run -slave selection_davidson_slave Cu.ezfio &> Cu.zmq-slave
wait


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

##echo '1e-08' > Cu.ezfio/qmc/ci_threshold
#qp_run truncate_wf_spin Cu.ezfio &> Cu.trunc
#qp_run save_for_qmcpack Cu.ezfio &> Cu.dump
##convert4qmc -QP Cu.dump -add3BodyJ -hdf5
##convert4qmc -QP Cu.dump -threshold 1e-20 -production
#convert4qmc -QP Cu.dump -threshold 1e-20

### Check QP energy
#ibrun -n 1088 qmcpack Cu.dump.qmc.in-wfnoj.xml > qmc.qp
##ibrun -n 48 qmcpack Cu.dump.qmc.in-wfj.xml > qmc.jast


#qmcpack --dryrun Cu.dump.qmc.in-wfj.xml > qmc.out
#ibrun -n 48 qmcpack Cu.dump.qmc.in-wfj.xml > qmc.out
#qmcpack Cu.dump.qmc.in-wfj.xml > qmc.out



