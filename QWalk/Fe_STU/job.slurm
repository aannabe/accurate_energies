#!/bin/bash
#SBATCH -J PP_CONV			# job name
#SBATCH -o myMPI.o%j            # output and error file name (%j expands to jobID)
#SBATCH -N 1                   # total number of mpi tasks requested
#SBATCH -n 1                   # total number of mpi tasks requested
#!SBATCH -p normal               # queue (partition) -- normal, development, etc.
#!SBATCH -p development
#!SBATCH -p skx-normal               # queue (partition) -- normal, development, etc.
#SBATCH -p skx-dev
#!SBATCH -t 23:59:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH -t 00:29:00            # run time (hh:mm:ss) - 1.5 hours

ppconvert --gamess_pot Fe.STU.gamess --s_ref "1s(2)2p(6)2s(2)3d(6)" --p_ref "1s(2)2p(6)2s(2)3d(6)" --d_ref "1s(2)2p(6)2s(2)3d(6)" --xml Fe.STU.xml
#ppconvert --gamess_pot Fe.BFD.gamess --s_ref "1s(2)2p(6)2s(2)3d(6)" --p_ref "1s(2)2p(6)2s(2)3d(6)" --d_ref "1s(2)2p(6)2s(2)3d(6)" --xml Fe.BFD.xml

