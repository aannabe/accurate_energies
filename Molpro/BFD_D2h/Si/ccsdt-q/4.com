***,Si
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Si 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals_bfd/pps/Si.pp
include,/global/homes/a/aannabe/docs/totals_bfd/basis/aug-cc-pVnZ/Si_qz.basis
}

{hf                        
wf,4,6,2
occ,1,1,0,0,1,0,0,0
!open,1.2,1.5
closed,1,0,0,0,0,0,0,0
!sym,
}
scf(i)=energy

_CC_NORM_MAX=2.0
!NOTE: Perturbative MRCC works only with UHF reference. So, here we will trick MRCC by doing zero UHF iteration right after ROHF.

{uhf
wf,4,6,2
occ,1,1,0,0,1,0,0,0
!open,1.2,1.5
closed,1,0,0,0,0,0,0,0
!sym,
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
save,4.csv,new


