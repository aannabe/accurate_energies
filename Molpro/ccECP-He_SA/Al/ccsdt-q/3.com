***,Al
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Al 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Al/ccECP_He_core/Al.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Al/ccECP_He_core/cc-pCVTZ.molpro
}

{rhf
 start,atden
 wf,11,2,1
 occ,2,2,1,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
! open,2.2
 save,4202.2
}
{multi
 start,4202.2
 occ,2,2,2,0,2,0,0
 closed,2,1,1,0,1,0,0,0
 wf,11,2,1;state,1
 wf,11,3,1;state,1
 wf,11,5,1;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,11,2,1
 occ,2,2,1,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
! open,2.2
}

scf(i)=energy

_CC_NORM_MAX=2.0
!NOTE: Perturbative MRCC works only with UHF reference. So, here we will trick MRCC by doing zero UHF iteration right after ROHF.

{uhf
 wf,11,2,1
 occ,2,2,1,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0

maxit,0
}
scf(i)=energy

{mrcc,method=CCSDT(Q),dir=Al !,restart=1
orbital,ignore_error=1  !Ignore the fact that UHF WF is not converged
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,3.csv,new


