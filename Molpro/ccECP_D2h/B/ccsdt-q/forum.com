***,B
memory,100,m

gprint,basis,orbitals
gexpec,ekin,pot

angstrom
geometry={                 
1	! Number of atoms

B 0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/totals/pps/B.pp
include,/global/homes/a/aannabe/docs/totals/basis/aug-cc-pVnZ/B_dz.basis
}


{uhf
wf,3,2,1
occ,1,1,0,0,0,0,0,0
open,1.2
maxit,100
}
scf(i)=energy

{mrcc,method=CCSDT(Q),tol=1.e-3
maxit,100
core
}


