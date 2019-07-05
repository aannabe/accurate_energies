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
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Li_TZ.basis
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Li_TZ.basis

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Li/ccECP/Li.ccECP.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Li/ccECP/Li.cc-pCVTZ.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Li/ccECP/Li.cc-pVTZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Li/ccECP/Li.aug-cc-pVTZ.molpro


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
save,3.csv,new


