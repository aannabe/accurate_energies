***,Ge
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Ge 0.0 0.0 0.0
}

spar=[0.083708, 2.361662]
ppar=[0.050000, 2.350000]
dpar=[0.097537, 2.263998]
fpar=[0.238832, 2.417239]
gpar=[0.464636, 2.000000]


proc opt_basis

!Calculate the exponents
N=3	!QZ
do i=1,N
sexp(i)=spar(1)*spar(2)^(i-1)
pexp(i)=ppar(1)*ppar(2)^(i-1)
dexp(i)=dpar(1)*dpar(2)^(i-1)
fexp(i)=fpar(1)*fpar(2)^(i-1)
gexp(i)=gpar(1)*gpar(2)^(i-1)
enddo


basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ge/ccECP/Ge.ccECP.molpro

s,Ge, 46.470485, 20.357328, 8.917936, 3.906681, 1.711400, 0.749713, 0.328427, 0.143874, 0.063027
c,1.9,-0.000229, 0.001574, -0.011345, 0.098972, -0.331545, -0.094809, 0.438933, 0.596777, 0.186251
p,Ge, 22.641155, 10.174686, 4.572392, 2.054783, 0.923397, 0.414964, 0.186480, 0.083802, 0.037660
c,1.9, 0.000052, -0.000675, 0.011276, -0.074628, -0.012070, 0.216919, 0.438735, 0.385126, 0.108074

s,Ge,sexp(1),sexp(2),sexp(3)
p,Ge,pexp(1),pexp(2),pexp(3)
d,Ge,dexp(1),dexp(2),dexp(3)
f,Ge,fexp(1),fexp(2)
g,Ge,gexp(1)
}

{hf                        
 wf,4,4,2
 occ,1,1,1,0,0,0,0,0
 closed,1,0,0,0,0,0,0,0
}              

_CC_NORM_MAX=2.0
{rcisd
maxit,50
core
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1) !,gpar(2)
method,bfgs,proc=opt_basis,thresh=3e-5,vstep=5e-4
maxit,100}


