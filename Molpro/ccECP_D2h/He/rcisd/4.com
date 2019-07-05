***,He
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

He 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/He/ccECP/He.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/He/ccECP/He.aug-cc-pVQZ.molpro
}

{hf                        
wf,2,1,0
!occ,1,0,0,0,0,0,0,0
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


