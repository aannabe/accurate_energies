***,Ca
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Ca 0.0 0.0 0.0
}

basis={
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/pps/Ca.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Ca_QZ.basis
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Ca_QZ.basis

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ca/ccECP/Ca.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ca/ccECP/Ca.cc-pCVQZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ca/ccECP/Ca.aug-cc-pVQZ.molpro


}

{hf                        
wf,10,1,0
occ,2,1,1,0,1,0,0,0
closed,2,1,1,0,1,0,0,0
}
scf(i)=energy

_CC_NORM_MAX=2.0
!NOTE: Perturbative MRCC works only with UHF reference. So, here we will trick MRCC by doing zero UHF iteration right after ROHF.

{uhf
wf,10,1,0
occ,2,1,1,0,1,0,0,0
closed,2,1,1,0,1,0,0,0
maxit,0
}
scf(i)=energy

{mrcc,method=CCSDT(Q),dir=mrccdir !,restart=1
orbital,ignore_error=1  !Ignore the fact that UHF WF is not converged
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,4.csv,new


