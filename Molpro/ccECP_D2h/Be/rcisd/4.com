***,Be
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Be 0.0 0.0 0.0
}

basis={

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Be/ccECP/Be.ccECP.molpro

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Be/ccECP/Be.cc-pVQZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Be/ccECP/Be.cc-pCVQZ.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Be/ccECP/Be.aug-cc-pVQZ.molpro


}

{hf                        
wf,2,1,0
occ,1,0,0,0,0,0,0,0
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
save,4.csv,new


