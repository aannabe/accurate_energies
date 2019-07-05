***,Br
memory,8,g
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Br 0.0 0.0 0.0
}

basis={

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Br/ccECP/Br.ccECP.molpro

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Br/ccECP/Br.cc-pVTZ.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Br/ccECP/Br.cc-pCVTZ.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Br/ccECP/Br.aug-cc-pVTZ.molpro


}

{hf                        
wf,7,3,1
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,1,0,0,0
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


