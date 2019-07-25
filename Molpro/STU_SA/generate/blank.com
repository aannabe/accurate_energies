***,ATOM
memory,MEMORY
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

ATOM 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/accurate/STU_natural/pps/ATOM.pp
include,/global/homes/a/aannabe/docs/accurate/STU_natural/basis/ATOM_BASIS.basis
}

WAVEFUNCTION

scf(i)=energy

_CC_NORM_MAX=2.0
MY_METHOD
posthf(i)=energy

table,scf,posthf,ekin,pot
save,CARDINAL.csv,new


