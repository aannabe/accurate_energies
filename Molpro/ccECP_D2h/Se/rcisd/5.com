***,Se
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Se 0.0 0.0 0.0
}

basis={

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.ccECP.molpro

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.cc-pV5Z.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.cc-pCV5Z.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.aug-cc-pV5Z.molpro


}

{hf                        
wf,6,7,2
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,0,0,0,0
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


