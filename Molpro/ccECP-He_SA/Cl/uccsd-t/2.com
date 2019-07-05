***,Cl
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Cl 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Cl/ccECP_He_core/Cl.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Cl/ccECP_He_core/cc-pCVDZ.molpro
}

{rhf
 start,atden
 wf,15,3,1
 occ,2,2,2,0,2,0,0,0
 closed,2,2,1,0,2,0,0,0
! open,2.3
 orbital,4202.2
}
{multi
 maxiter,40
 start,4202.2
 occ,2,2,2,0,2,0,0,0
 closed,2,1,1,0,1,0,0
 wf,15,3,1;state,1
 wf,15,5,1;state,1
 wf,15,2,1;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,15,3,1
 occ,2,2,2,0,2,0,0,0
 closed,2,2,1,0,2,0,0,0
! open,2.3
}

scf(i)=energy

_CC_NORM_MAX=2.0
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,2.csv,new


