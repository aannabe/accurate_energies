***,Ne
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Ne 0.0 0.0 0.0
}

basis={
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/pps/Ne.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Ne_5Z.basis
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Ne_5Z.basis

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ne/ccECP/Ne.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ne/ccECP/Ne.cc-pV5Z.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ne/ccECP/Ne.aug-cc-pV5Z.molpro


}

{hf                        
wf,8,1,0
occ,1,1,1,0,1,0,0,0
!open,1.2
closed,1,1,1,0,1,0,0,0
!sym,
}
scf(i)=energy

_CC_NORM_MAX=2.0
!NOTE: Perturbative MRCC works only with UHF reference. So, here we will trick MRCC by doing zero UHF iteration right after ROHF.

{uhf
wf,8,1,0
occ,1,1,1,0,1,0,0,0
!open,1.2
closed,1,1,1,0,1,0,0,0
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
save,5.csv,new


