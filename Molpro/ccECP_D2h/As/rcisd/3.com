***,As
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

As 0.0 0.0 0.0
}

basis={

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/As/ccECP/As.ccECP.molpro

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/As/ccECP/As.cc-pVTZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/As/ccECP/As.cc-pCVTZ.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/As/ccECP/As.aug-cc-pVTZ.molpro


}

{hf                        
wf,5,8,3
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,0,0,0,0,0,0,0
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


