***,Ga
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Ga 0.0 0.0 0.0
}

basis={

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ga/ccECP/Ga.ccECP.molpro

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ga/ccECP/Ga.cc-pVTZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ga/ccECP/Ga.cc-pCVTZ.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ga/ccECP/Ga.aug-cc-pVTZ.molpro


}

{hf                        
wf,3,2,1
occ,1,1,0,0,0,0,0,0
!open,1.2
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
save,3.csv,new


