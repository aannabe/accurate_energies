***,Li
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Li 0.0 0.0 0.0
}

basis={
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/pps/Li.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Li_5Z.basis
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Li_5Z.basis

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Li/ccECP/Li.ccECP.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Li/ccECP/Li.cc-pCV5Z.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Li/ccECP/Li.cc-pV5Z.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Li/ccECP/Li.aug-cc-pV5Z.molpro


}

{hf                        
wf,1,1,1
occ,1,0,0,0,0,0,0,0        
!open,1.3      
closed,0,0,0,0,0,0,0,0
!sym,
}
scf(i)=energy

_CC_NORM_MAX=2.0
{ci
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,5.csv,new


