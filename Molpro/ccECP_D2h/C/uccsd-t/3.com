***,C
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

C 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals/pps/C.pp
include,/global/homes/a/aannabe/docs/totals/basis/aug-cc-pVnZ/C_tz.basis
}

{hf                        
wf,4,6,2
occ,1,1,0,0,1,0,0,0
!open,1.2,1.5
closed,1,0,0,0,0,0,0,0
!sym,
}
scf(i)=energy

_CC_NORM_MAX=2.0
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,3.csv


