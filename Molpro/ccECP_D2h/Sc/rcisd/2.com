***,Sc
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Sc 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/pps/Sc.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Sc_dz.basis
include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Sc_dz.basis
}

{hf                        
wf,11,1,1
occ,3,1,1,0,1,0,0,0
open,3.1
sym,1,1,1,3,2
}
scf(i)=energy

_CC_NORM_MAX=2.0
{ci
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,2.csv,new


