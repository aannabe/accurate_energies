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

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/As/ccECP/As.cc-pVQZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/As/ccECP/As.cc-pCVQZ.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/As/ccECP/As.aug-cc-pVQZ.molpro


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
{rccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,4.csv,new


