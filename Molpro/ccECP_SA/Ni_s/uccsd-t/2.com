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
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/pps/Ni.pp
!include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/basis/aug-cc-pVnZ/Ni_dz.basis
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/basis/cc-pVnZ/Ni_dz.basis
}

{rhf
 start,atden
 print,orbitals=2
 wf,18,6,2
 occ,4,1,1,1,1,1,1,0
 open,4.1,1.6
 sym,1,1,3,2,1
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,0,1,0,0
 wf,18,1,2;state,2
 restrict,1,1,4.1
 wf,18,4,2;state,1
 restrict,1,1,4.1
 wf,18,6,2;state,1
 restrict,1,1,4.1
 wf,18,7,2;state,1
 restrict,1,1,4.1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,18,6,2
 occ,4,1,1,1,1,1,1,0
 open,4.1,1.6
}


scf(i)=energy

_CC_NORM_MAX=2.0
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,2.csv,new


