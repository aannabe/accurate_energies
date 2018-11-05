***,Cl
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

Cl 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/pps/Cl.pp
include,/global/homes/a/aannabe/docs/accurate/ccECP_Kh/basis/aug-cc-pVnZ/Cl_5z.basis
}

{rhf
 start,atden
 wf,7,3,1
 occ,1,1,1,0,1,0,0,0
 open,1.3
 orbital,4202.2
}
{multi
 maxiter,40
 start,4202.2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,0,0,0
 wf,7,3,1;state,1
 wf,7,5,1;state,1
 wf,7,2,1;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,7,3,1
 occ,1,1,1,0,1,0,0,0
 open,1.3
}

scf(i)=energy

_CC_NORM_MAX=2.0
{uccsd(t)
maxit,100
core
}
posthf(i)=energy

table,scf,posthf,ekin,pot
save,5.csv,new


