***,S
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

S 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/S/ccECP_He_core/S.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/S/ccECP_He_core/cc-pCVQZ.molpro
}

{hf                        
 wf,14,7,2
 occ,2,2,2,0,2,0,0,0
 closed,2,2,1,0,1,0,0,0
 !open,2.3,2.5
}
scf(i)=energy

_CC_NORM_MAX=2.0
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,4.csv,new


