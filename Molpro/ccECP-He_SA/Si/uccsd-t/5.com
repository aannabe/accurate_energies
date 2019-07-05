***,Si
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Si 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Si/ccECP_He_core/Si.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Si/ccECP_He_core/cc-pCV5Z.molpro
}

{rhf
 start,atden
 wf,12,4,2
 occ,2,2,2,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
! open,2.2,2.3
 save,4202.2
}
{multi
 start,4202.2
 occ,2,2,2,0,2,0,0
 closed,2,1,1,0,1,0,0,0
 wf,12,4,2;state,1
 wf,12,6,2;state,1
 wf,12,7,2;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,12,4,2
 occ,2,2,2,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
! open,2.2,2.3
}

scf(i)=energy

_CC_NORM_MAX=2.0
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,5.csv,new


