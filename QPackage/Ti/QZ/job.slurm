#!/bin/bash
#SBATCH -J Ti_QZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                   # total number of mpi tasks requested
#SBATCH -n 1                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#!SBATCH -t 47:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 05:59:00            # run time (hh:mm:ss) - 1.5 hours

module load python
module load gaussian
source /work/04843/aannabe/stampede2/codes/quantum_package/quantum_package.rc

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#export OMP_NUM_THREADS=16
#rungms Ti.inp > Ti.out

##cp ../mini/success.chk Ti.chk
#g16 < Ti.gjf > Ti.log

### ~~~~~~~~  Convert to QP format ~~~~~~~~~~~~~~
#qp_convert_output_to_ezfio.py Ti.out -o Ti.ezfio
#echo 'Write' > Ti.ezfio/integrals_bielec/disk_access_ao_integrals
#echo 'Write' > Ti.ezfio/integrals_bielec/disk_access_mo_integrals
#qp_run print_energy Ti.ezfio > print_energy.out

#####ibrun -np 15 qp_run -slave qp_ao_ints Ti.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF Ti.ezfio &> Ti.scf
######ibrun -np 20 qp_run -slave qp_ao_ints Ti.ezfio &> Ti.scf-slave

#### ~~~~~~~~ Start iterative ZMQ runs ~~~~~~~~~~~~~~~~~

#echo '100000' > Ti.ezfio/determinants/n_det_max
##echo '1e-12' > Ti.ezfio/davidson/threshold_davidson
#echo 'T' > Ti.ezfio/davidson/distributed_davidson
##echo 'T' > Ti.ezfio/determinants/store_full_h_mat
#
#ibrun -n 1 qp_run fci_zmq Ti.ezfio &> Ti.zmq_0 &
#sleep 10
#echo "Attempting to start slave processes..."
#ibrun -n 15 qp_run -slave selection_davidson_slave Ti.ezfio &> Ti.zmq-slave
#wait
#
#
#qp_run save_natorb Ti.ezfio
#echo '2000000' > Ti.ezfio/determinants/n_det_max
#ibrun -n 1 qp_run fci_zmq Ti.ezfio &> Ti.zmq_1 &
#sleep 10
#echo "Attempting to start slave processes..."
#ibrun -n 15 qp_run -slave selection_davidson_slave Ti.ezfio &> Ti.zmq-slave
#wait


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

##echo '1e-08' > Ti.ezfio/qmc/ci_threshold
qp_run truncate_wf_spin Ti.ezfio &> Ti.trunc
qp_run save_for_qmcpack Ti.ezfio &> Ti.dump
##convert4qmc -QP Ti.dump -add3BodyJ -hdf5
convert4qmc -QP Ti.dump -threshold 1e-20 -production
#convert4qmc -QP Ti.dump -threshold 1e-20

### Check QP energy
#ibrun -n 1088 qmcpack Ti.dump.qmc.in-wfnoj.xml > qmc.qp
##ibrun -n 48 qmcpack Ti.dump.qmc.in-wfj.xml > qmc.jast


#qmcpack --dryrun Ti.dump.qmc.in-wfj.xml > qmc.out
#ibrun -n 48 qmcpack Ti.dump.qmc.in-wfj.xml > qmc.out
#qmcpack Ti.dump.qmc.in-wfj.xml > qmc.out



