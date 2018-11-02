***,Cr
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Cr 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals/pps/Cr.pp
include,/global/homes/a/aannabe/docs/totals/basis/aug-cc-pVnZ/Cr_6z.basis
}

{hf                        
wf,14,1,6
occ,4,1,1,1,1,1,1,0
open,2.1,3.1,4.1,1.4,1.6,1.7
sym,1,1,1,2,3
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


