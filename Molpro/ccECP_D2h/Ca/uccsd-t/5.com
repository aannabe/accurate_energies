***,Ca
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Ca 0.0 0.0 0.0
}

basis={
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/pps/Ca.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Ca_5Z.basis
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Ca_5Z.basis

include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ca/ccECP/Ca.ccECP.molpro
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ca/ccECP/Ca.cc-pCV5Z.molpro


}

{hf                        
wf,10,1,0
occ,2,1,1,0,1,0,0,0
closed,2,1,1,0,1,0,0,0
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


