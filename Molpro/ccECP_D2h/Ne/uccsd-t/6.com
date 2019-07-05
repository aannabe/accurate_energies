***,Ne
memory,512,m
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
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Ne_6Z.basis
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Ne_6Z.basis

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ne/ccECP/Ne.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ne/ccECP/Ne.cc-pV6Z.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ne/ccECP/Ne.aug-cc-pV6Z.molpro


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
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,6.csv,new


