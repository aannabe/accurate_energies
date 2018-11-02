***,O
memory,512,m
gthresh,twoint=1.e-12

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

O 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals_bfd/pps/O.pp
include,/global/homes/a/aannabe/docs/totals_bfd/basis/aug-cc-pVnZ/O_6z.basis
}

{hf                        
wf,6,7,2
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,0,0,0,0
!sym,
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


