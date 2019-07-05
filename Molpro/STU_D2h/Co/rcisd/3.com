***,Co
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Co 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals_stu_d2h/pps/Co.pp
include,/global/homes/a/aannabe/docs/totals_stu_d2h/basis/unc-aug-cc-pwCVnZ/Co_tz.basis
}

{hf                        
wf,17,1,3
occ,4,1,1,1,1,1,1,0
open,1.4,1.6,1.7
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
save,3.csv,new


