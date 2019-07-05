***,F
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

F 0.0 0.0 0.0
}

basis={
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/pps/F.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/F_6Z.basis
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/F_6Z.basis

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/F/ccECP/F.ccECP.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/F/ccECP/F.cc-pCV6Z.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/F/ccECP/F.aug-cc-pV6Z.molpro


}

{hf                        
wf,7,3,1
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,1,0,0,0
!sym,
}
scf(i)=energy

_CC_NORM_MAX=2.0
!NOTE: Perturbative MRCC works only with UHF reference. So, here we will trick MRCC by doing zero UHF iteration right after ROHF.

{uhf
wf,7,3,1
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,1,0,0,0
!sym,
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
save,6.csv,new


