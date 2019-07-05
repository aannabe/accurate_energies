#!/bin/bash
#SBATCH -J V_QZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 64                   # total number of mpi tasks requested
#SBATCH -n 512                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#SBATCH -t 11:59:00             # run time (hh:mm:ss) - 1.5 hours
#!SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours

module load python
module load gaussian
source /work/04843/aannabe/stampede2/codes/quantum_package/quantum_package.rc
#export OMP_NUM_THREADS=64

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#rungms V.inp > V.out

##cp ../mini/success.chk V.chk
#g16 < V.gjf > V.log

### ~~~~~~~~  Convert to QP format ~~~~~~~~~~~~~~
#qp_convert_output_to_ezfio.py V.out -o V.ezfio
#echo 'Write' > V.ezfio/integrals_bielec/disk_access_ao_integrals
#echo 'Write' > V.ezfio/integrals_bielec/disk_access_mo_integrals
#qp_run print_energy V.ezfio > print_energy.out

#####ibrun -np 15 qp_run -slave qp_ao_ints V.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF V.ezfio &> V.scf
######ibrun -np 20 qp_run -slave qp_ao_ints V.ezfio &> V.scf-slave

#### ~~~~~~~~ Start iterative ZMQ runs ~~~~~~~~~~~~~~~~~

#echo '70000' > V.ezfio/determinants/n_det_max
##echo '1e-12' > V.ezfio/davidson/threshold_davidson
#echo 'T' > V.ezfio/davidson/distributed_davidson
##echo 'T' > V.ezfio/determinants/store_full_h_mat
#
#ibrun -n 1 qp_run fci_zmq V.ezfio &> V.zmq_0 &
#sleep 10
#echo "Attempting to start slave processes..."
#ibrun -n 31 qp_run -slave selection_davidson_slave V.ezfio &> V.zmq-slave
#wait
#
#qp_run save_natorb V.ezfio
#echo '             1800000' > V.ezfio/determinants/n_det_max
#ibrun -n 1 qp_run fci_zmq V.ezfio &> V.zmq_1 &
#sleep 20
#echo "Attempting to start slave processes..."
#ibrun -n 31 qp_run -slave selection_davidson_slave V.ezfio &> V.zmq-slave
#wait


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

#echo '1e-08' > V.ezfio/qmc/ci_threshold
#qp_run truncate_wf_spin V.ezfio &> V.trunc
#qp_run save_for_qmcpack V.ezfio &> V.dump
##convert4qmc -QP V.dump -add3BodyJ -hdf5
##convert4qmc -QP V.dump -threshold 1e-20 -production
#convert4qmc -QP V.dump -threshold 1e-20

### Check QP energy

cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/V/ccECP/V.ccECP.xml V.qmcpp.xml
ibrun -n 512 qmcpack V.dump.qmc.in-wfnoj.xml > qmc.qp
##ibrun -n 48 qmcpack V.dump.qmc.in-wfj.xml > qmc.jast


#qmcpack --dryrun V.dump.qmc.in-wfj.xml > qmc.out
#ibrun -n 48 qmcpack V.dump.qmc.in-wfj.xml > qmc.out
#qmcpack V.dump.qmc.in-wfj.xml > qmc.out



