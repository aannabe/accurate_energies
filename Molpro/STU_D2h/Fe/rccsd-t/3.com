***,Fe
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Fe 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals_stu_d2h/pps/Fe.pp
include,/global/homes/a/aannabe/docs/totals_stu_d2h/basis/unc-aug-cc-pwCVnZ/Fe_tz.basis
}

{hf                        
wf,16,1,4
occ,4,1,1,1,1,1,1,0
open,4.1,1.4,1.6,1.7
sym,1,1,1,3
}
scf(i)=energy

_CC_NORM_MAX=2.0
{rccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,3.csv,new


