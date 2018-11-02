***,V
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

V 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals/pps/V.pp
include,/global/homes/a/aannabe/docs/totals/basis/aug-cc-pVnZ/V_qz.basis
}

{hf                        
wf,13,6,3
occ,4,1,1,0,1,1,0,0
open,3.1,4.1,1.6
sym,1,1,1
}
scf(i)=energy

_CC_NORM_MAX=2.0
{rccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,4.csv,new


