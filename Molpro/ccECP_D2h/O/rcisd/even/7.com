***,O
memory,8,g
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

O 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals/pps/O.pp
include,/global/homes/a/aannabe/docs/totals/basis/aug-cc-pVnZ/O_7z.basis
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
{rcisd
maxit,100
core
}
posthf(i)=energy

table,scf,posthf
save,7.csv


