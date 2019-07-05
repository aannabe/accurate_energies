***,Se
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Se 0.0 0.0 0.0
}

spar=[0.063301, 2.000000]
ppar=[0.103082, 2.000000]
dpar=[0.364881, 2.000000]

proc opt_basis

!Calculate the exponents
N=1	!dZ
do i=1,N
sexp(i)=spar(1)*spar(2)^(i-1)
pexp(i)=ppar(1)*ppar(2)^(i-1)
dexp(i)=dpar(1)*dpar(2)^(i-1)
enddo

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.ccECP.molpro

s,Se, 53.235856, 24.069480, 10.882513, 4.920301, 2.224611, 1.005811, 0.454757, 0.205609, 0.092962
c,1.9,-0.000173, 0.001518, -0.015384, 0.136816, -0.394610, -0.139559, 0.507331, 0.586875, 0.177170
p,Se, 25.056177, 11.673683, 5.438773, 2.533927, 1.180557, 0.550022, 0.256256, 0.119390, 0.055624
c,1.9,-0.000153, 0.000332, 0.014175, -0.103893, -0.008134, 0.284904, 0.427437, 0.334066, 0.112340

s,Se,sexp(1)
p,Se,pexp(1)
d,Se,dexp(1)
}

{hf                        
 wf,6,4,2
 occ,1,1,1,0,1,0,0,0
 closed,1,0,0,0,1,0,0,0
}              

_CC_NORM_MAX=2.0
{rcisd
maxit,50
core
}
eval=energy

endproc

{minimize,eval,spar(1),ppar(1),dpar(1)
method,bfgs,proc=opt_basis,thresh=3e-5,vstep=5e-4
maxit,100}


