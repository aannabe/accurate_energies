***,K
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

K 0.0 0.0 0.0
}

basis={

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/K/ccECP/K.ccECP.molpro

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/K/ccECP/K.cc-pV6Z.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/K/ccECP/K.cc-pCV6Z.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/K/ccECP/K.aug-cc-pV6Z.molpro


}

{hf                        
wf,9,1,1
occ,2,1,1,0,1,0,0,0
closed,1,1,1,0,1,0,0,0
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


