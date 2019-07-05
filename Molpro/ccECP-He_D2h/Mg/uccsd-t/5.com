***,Mg
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Mg 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Mg/ccECP_He_core/Mg.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Mg/ccECP_He_core/cc-pCV5Z.molpro
}

{hf                        
 wf,10,1,0
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


