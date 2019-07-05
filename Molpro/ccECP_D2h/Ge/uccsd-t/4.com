***,Ge
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Ge 0.0 0.0 0.0
}

basis={

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ge/ccECP/Ge.ccECP.molpro

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ge/ccECP/Ge.cc-pVQZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ge/ccECP/Ge.cc-pCVQZ.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ge/ccECP/Ge.aug-cc-pVQZ.molpro


}

{hf                        
wf,4,6,2
occ,1,1,0,0,1,0,0,0
!open,1.2,1.5
closed,1,0,0,0,0,0,0,0
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
save,4.csv,new


