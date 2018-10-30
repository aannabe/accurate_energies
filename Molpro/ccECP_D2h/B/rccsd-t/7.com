***,B
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

B 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals/pps/B.pp
include,/global/homes/a/aannabe/docs/totals/basis/aug-cc-pVnZ/B_7z.basis
}

{hf                        
wf,3,2,1
occ,1,1,0,0,0,0,0,0
open,1.2
!closed,1,0,0,0,0,0,0,0
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
save,7.csv


