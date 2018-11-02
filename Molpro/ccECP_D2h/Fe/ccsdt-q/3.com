***,Fe
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Fe 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals/pps/Fe.pp
include,/global/homes/a/aannabe/docs/totals/basis/aug-cc-pVnZ/Fe_tz.basis
}

{hf                        
wf,16,1,4
occ,4,1,1,1,1,1,1,0
open,4.1,1.4,1.6,1.7
sym,1,1,1,3
}
scf(i)=energy

_CC_NORM_MAX=2.0
!NOTE: Perturbative MRCC works only with UHF reference. So, here we will trick MRCC by doing zero UHF iteration right after ROHF.

{uhf
wf,16,1,4
occ,4,1,1,1,1,1,1,0
open,4.1,1.4,1.6,1.7
sym,1,1,1,3
maxit,0
}
scf(i)=energy

{mrcc,method=CCSDT(Q)
orbital,ignore_error=1  !Ignore the fact that UHF WF is not converged
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,3.csv,new


