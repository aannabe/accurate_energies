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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Si/ccECP_He_core/Si.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Si/ccECP_He_core/cc-pCVDZ.molpro
}

{hf                        
 wf,12,4,2
 occ,2,2,2,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
 !open,2.2,2.3
}
scf(i)=energy

_CC_NORM_MAX=2.0
!NOTE: Perturbative MRCC works only with UHF reference. So, here we will trick MRCC by doing zero UHF iteration right after ROHF.

{uhf
 wf,12,4,2
 occ,2,2,2,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
 !open,2.2,2.3
maxit,0
}
scf(i)=energy

{mrcc,method=CCSDT(Q),dir=Si !,restart=1
orbital,ignore_error=1  !Ignore the fact that UHF WF is not converged
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,2.csv,new


