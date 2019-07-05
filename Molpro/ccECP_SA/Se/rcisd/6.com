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

!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.cc-pV6Z.molpro
!include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.cc-pCV6Z.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.aug-cc-pV6Z.molpro


}

                      
{rhf
 start,atden
 wf,6,7,2
 occ,1,1,1,0,1,0,0,0
 open,1.3,1.5
 orbital,4202.2
}
{multi
 maxiter,40
 start,4202.2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0
 wf,6,4,2;state,1
 wf,6,6,2;state,1
 wf,6,7,2;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,6,7,2
 occ,1,1,1,0,1,0,0,0
 open,1.3,1.5
}

scf(i)=energy

_CC_NORM_MAX=2.0
{ci
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,6.csv,new


