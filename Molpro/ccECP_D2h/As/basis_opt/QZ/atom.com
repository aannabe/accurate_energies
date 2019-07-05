***,As
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

As 0.0 0.0 0.0
}

spar=[0.103607, 2.254445]
ppar=[0.081675, 2.585159]
dpar=[0.184432, 2.728733]
fpar=[0.259938, 2.435037]
gpar=[0.559184, 2.000000]









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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/As/ccECP/As.ccECP.molpro

s,As, 50.230536, 22.441775, 10.026436, 4.479567, 2.001361, 0.894159, 0.399488, 0.178482, 0.079741
c,1.9,-0.000538, 0.003660, -0.023992, 0.158076, -0.419346, -0.100519, 0.450020, 0.605104, 0.190009
p,As, 22.695464, 10.529662, 4.885284, 2.266549, 1.051576, 0.487883, 0.226356, 0.105019, 0.048724
c,1.9, 0.000322, -0.003120, 0.029849, -0.127882, -0.004461, 0.248666, 0.457083, 0.351483, 0.091636

s,As,sexp(1),sexp(2),sexp(3)
p,As,pexp(1),pexp(2),pexp(3)
d,As,dexp(1),dexp(2),dexp(3)
f,As,fexp(1),fexp(2)
g,As,gexp(1)
}

{hf                        
 wf,5,8,3
 occ,1,1,1,0,1,0,0,0
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


