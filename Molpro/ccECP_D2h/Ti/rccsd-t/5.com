***,Ti
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Ti 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/pps/Ti.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Ti_5z.basis
include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Ti_5z.basis
}

{hf                        
wf,12,1,2
occ,4,1,1,0,1,0,0,0
open,3.1,4.1
sym,1,1,1,3,2
}
scf(i)=energy

_CC_NORM_MAX=2.0
{rccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,5.csv,new


