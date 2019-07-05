#!/bin/bash
#SBATCH -J Sc_QZ			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 64                   # total number of mpi tasks requested
#SBATCH -n 512                   # total number of mpi tasks requested
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
#rungms Sc.inp > Sc.out

##cp ../mini/success.chk Sc.chk
#g16 < Sc.gjf > Sc.log

### ~~~~~~~~  Convert to QP format ~~~~~~~~~~~~~~
#qp_convert_output_to_ezfio.py Sc.out -o Sc.ezfio
#echo 'Write' > Sc.ezfio/integrals_bielec/disk_access_ao_integrals
#echo 'Write' > Sc.ezfio/integrals_bielec/disk_access_mo_integrals
#qp_run print_energy Sc.ezfio > print_energy.out

#####ibrun -np 15 qp_run -slave qp_ao_ints Sc.ezfio &> print_energy.out-slave
######ibrun -np 1 qp_run SCF Sc.ezfio &> Sc.scf
######ibrun -np 20 qp_run -slave qp_ao_ints Sc.ezfio &> Sc.scf-slave

#### ~~~~~~~~ Start iterative ZMQ runs ~~~~~~~~~~~~~~~~~

#echo '100000' > Sc.ezfio/determinants/n_det_max
##echo '1e-12' > Sc.ezfio/davidson/threshold_davidson
#echo 'T' > Sc.ezfio/davidson/distributed_davidson
##echo 'T' > Sc.ezfio/determinants/store_full_h_mat
#
#ibrun -n 1 qp_run fci_zmq Sc.ezfio &> Sc.zmq_0 &
#sleep 10
#echo "Attempting to start slave processes..."
#ibrun -n 15 qp_run -slave selection_davidson_slave Sc.ezfio &> Sc.zmq-slave
#wait
#
#
#qp_run save_natorb Sc.ezfio
#echo '2000000' > Sc.ezfio/determinants/n_det_max
#ibrun -n 1 qp_run fci_zmq Sc.ezfio &> Sc.zmq_1 &
#sleep 10
#echo "Attempting to start slave processes..."
#ibrun -n 15 qp_run -slave selection_davidson_slave Sc.ezfio &> Sc.zmq-slave
#wait


### ~~~~~~~~~ QMCPACK ~~~~~~~~~~~~

###echo '1e-08' > Sc.ezfio/qmc/ci_threshold
#qp_run truncate_wf_spin Sc.ezfio &> Sc.trunc
#qp_run save_for_qmcpack Sc.ezfio &> Sc.dump
#convert4qmc -QP Sc.dump -threshold 1e-20 #-hdf5 -production
cp /work/04843/aannabe/stampede2/repos/pseudopotentiallibrary/recipes/Sc/ccECP/Sc.ccECP.xml Sc.qmcpp.xml

ibrun -n 512 qmcpack Sc.dump.qmc.in-wfnoj.xml > qmc.qp

#sed -i 's/type="Array" optimize="yes"/type="Array" optimize="no"/g' Sc.dump.wfj.xml
#ibrun -n 512 qmcpack Sc.dump.qmc.in-wfj.xml > qmc.jast
###sed -i 's/type="Array" optimize="no"/type="Array" optimize="yes"/g' Sc.dump.s003.opt.xml
###ibrun -n 128 qmcpack Sc.dump.qmc.in-wfj3.xml > qmc.jast



