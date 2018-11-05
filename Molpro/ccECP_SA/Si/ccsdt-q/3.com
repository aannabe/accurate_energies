***,Si
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Si 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/pps/Si.pp
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/basis/aug-cc-pVnZ/Si_tz.basis
}

{rhf
 start,atden
 wf,4,6,2
 occ,1,1,0,0,1,0,0,0
 open,1.2,1.5
 save,4202.2
}
{multi
 start,4202.2
 occ,1,1,1,0,1,0,0
 closed,1,0,0,0,0,0,0,0
 wf,4,4,2;state,1
 wf,4,6,2;state,1
 wf,4,7,2;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,4,6,2
 occ,1,1,0,0,1,0,0,0
 open,1.2,1.5
}

scf(i)=energy

_CC_NORM_MAX=2.0
!NOTE: Perturbative MRCC works only with UHF reference. So, here we will trick MRCC by doing zero UHF iteration right after ROHF.

{uhf
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


