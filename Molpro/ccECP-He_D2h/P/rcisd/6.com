***,P
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

P 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/P/ccECP_He_core/P.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/P/ccECP_He_core/cc-pCV6Z.molpro
}

{hf                        
 wf,13,8,3
 occ,2,2,2,0,2,0,0,0
 closed,2,1,1,0,1,0,0,0
 !open,2.3,2.5,2.2
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


