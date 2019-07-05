***,Kr
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Kr 0.0 0.0 0.0
}

basis={

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Kr/ccECP/Kr.ccECP.molpro

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Kr/ccECP/Kr.cc-pVTZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Kr/ccECP/Kr.cc-pCVTZ.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Kr/ccECP/Kr.aug-cc-pVTZ.molpro


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
{rccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,3.csv,new


