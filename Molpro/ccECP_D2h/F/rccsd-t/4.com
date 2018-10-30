***,F
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

F 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals/pps/F.pp
include,/global/homes/a/aannabe/docs/totals/basis/aug-cc-pVnZ/F_qz.basis
}

{hf                        
wf,7,3,1
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,1,0,0,0
!sym,
}
scf(i)=energy

_CC_NORM_MAX=2.0
{rccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,4.csv


