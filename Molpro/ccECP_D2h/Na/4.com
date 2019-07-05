***,Na
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Na 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Na/ccECP/Na.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Na/ccECP/Na.basis.cc-PVQZ-PP
}

{hf                        
wf,1,1,1
occ,1,0,0,0,0,0,0,0
open,1.1
}
scf(i)=energy

posthf(i)=energy

table,scf,posthf,ekin,pot
save,4.csv,new


