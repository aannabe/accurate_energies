#!/bin/bash
#SBATCH -J Mn_QZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 32                   # total number of mpi tasks requested
#SBATCH -n 256                   # total number of mpi tasks requested
#SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p skx-dev
#SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#!SBATCH -t 01:59:00            # run time (hh:mm:ss) - 1.5 hours

module load python
module load gaussian
source /work/04843/aannabe/stampede2/codes/quantum_package/quantum_package.rc
export OMP_NUM_THREADS=8

### ~~~~~~~~~~ Prepare Gaussian/Gamess File ~~~~~~~~~
#rungms Mn.inp > Mn.out

##cp ../mini/success.chk Mn.chk
#g16 < Mn.gjf > Mn.log

### ~~~~~~~~  Convert to QP format ~~~~~~~~~~~~~~
#qp_convert_output_to_ezfio.py Mn.out -o Mn.ezfio
#echo 'Write' > Mn.ezfio/integrals_bielec/disk_access_ao_integrals
#echo 'Write' > Mn.ezfio/integrals_bielec/disk_access_mo_integrals
#qp_run print_energy Mn.ezfio > print_energy.out

#####ibrun -np 15 qp_run -slave qp_ao_ints Mn.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF Mn.ezfio &> Mn.scf
######ibrun -np 20 qp_run -slave qp_ao_ints Mn.ezfio &> Mn.scf-slave

#### ~~~~~~~~ Start iterative ZMQ runs ~~~~~~~~~~~~~~~~~

#echo '100000' > Mn.ezfio/determinants/n_det_max
##echo '1e-12' > Mn.ezfio/davidson/threshold_davidson
#echo 'T' > Mn.ezfio/davidson/distributed_davidson
##echo 'T' > Mn.ezfio/determinants/store_full_h_mat
#
#ibrun -n 1 qp_run fci_zmq Mn.ezfio &> Mn.zmq_0 &
#sleep 10
#echo "Attempting to start slave processes..."
#ibrun -n 15 qp_run -slave selection_davidson_slave Mn.ezfio &> Mn.zmq-slave
#wait
#
#
#qp_run save_natorb Mn.ezfio
#echo '2000000' > Mn.ezfio/determinants/n_det_max
#ibrun -n 1 qp_run fci_zmq Mn.ezfio &> Mn.zmq_1 &
#sleep 10
#echo "Attempting to start slave processes..."
#ibrun -n 15 qp_run -slave selection_davidson_slave Mn.ezfio &> Mn.zmq-slave
#wait


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

###echo '1e-08' > Mn.ezfio/qmc/ci_threshold
#qp_run truncate_wf_spin Mn.ezfio &> Mn.trunc
#qp_run save_for_qmcpack Mn.ezfio &> Mn.dump
#convert4qmc -QP Mn.dump -threshold 1e-20 #-hdf5 -production
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Mn/ccECP/Mn.ccECP.xml Mn.qmcpp.xml

ibrun -n 256 qmcpack Mn.dump.qmc.in-wfnoj.xml > qmc.qp

#sed -i 's/type="Array" optimize="yes"/type="Array" optimize="no"/g' Mn.dump.wfj.xml
#ibrun -n 256 qmcpack Mn.dump.qmc.in-wfj.xml > qmc.jast
###sed -i 's/type="Array" optimize="no"/type="Array" optimize="yes"/g' Mn.dump.s003.opt.xml
###ibrun -n 128 qmcpack Mn.dump.qmc.in-wfj3.xml > qmc.jast



