***,Ni
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Ni 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/pps/Ni.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/aug-cc-pVnZ/Ni_tz.basis
include,/global/homes/a/aannabe/docs/accurate/ccECP_D2h/basis/cc-pVnZ/Ni_tz.basis
}

{hf                        
start,atden
wf,18,4,2
occ,4,1,1,1,1,1,1,0
open,4.1,1.4
sym,1,1,3,2,1
orbital,4202.2

}
scf(i)=energy

_CC_NORM_MAX=2.0
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,3.csv,new


