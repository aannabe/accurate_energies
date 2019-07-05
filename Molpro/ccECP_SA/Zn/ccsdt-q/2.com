***,Zn
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Zn 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/pps/Zn.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/basis/aug-cc-pVnZ/Zn_dz.basis
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/basis/cc-pVnZ/Zn_dz.basis
}

{rhf
 start,5202.2
 wf,20,1,0
 occ,4,1,1,1,1,1,1,0
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
save,2.csv,new


