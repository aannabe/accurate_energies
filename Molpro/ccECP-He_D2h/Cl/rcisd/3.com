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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Cl/ccECP_He_core/cc-pCVTZ.molpro
}

{hf                        
 wf,15,3,1
 occ,2,2,2,0,2,0,0,0
 closed,2,2,1,0,2,0,0,0
 !open,2.3
}
scf(i)=energy

_CC_NORM_MAX=2.0
{ci
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,3.csv,new


