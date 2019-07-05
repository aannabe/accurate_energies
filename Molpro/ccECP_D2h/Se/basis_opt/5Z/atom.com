***,Se
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Se 0.0 0.0 0.0
}


spar=[0.099892, 1.870570]
ppar=[0.068409, 2.404603]
dpar=[0.159130, 2.125269]
fpar=[0.223528, 1.998381]
gpar=[0.402485, 2.221213]
hpar=[0.742999, 2.000000]









proc opt_basis

!Calculate the exponents
N=4	!5Z
do i=1,N
sexp(i)=spar(1)*spar(2)^(i-1)
pexp(i)=ppar(1)*ppar(2)^(i-1)
dexp(i)=dpar(1)*dpar(2)^(i-1)
fexp(i)=fpar(1)*fpar(2)^(i-1)
gexp(i)=gpar(1)*gpar(2)^(i-1)
hexp(i)=hpar(1)*hpar(2)^(i-1)
enddo


basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Se/ccECP/Se.ccECP.molpro

s,Se, 53.235856, 24.069480, 10.882513, 4.920301, 2.224611, 1.005811, 0.454757, 0.205609, 0.092962
c,1.9,-0.000173, 0.001518, -0.015384, 0.136816, -0.394610, -0.139559, 0.507331, 0.586875, 0.177170
p,Se, 25.056177, 11.673683, 5.438773, 2.533927, 1.180557, 0.550022, 0.256256, 0.119390, 0.055624
c,1.9,-0.000153, 0.000332, 0.014175, -0.103893, -0.008134, 0.284904, 0.427437, 0.334066, 0.112340


s,Se,sexp(1),sexp(2),sexp(3),sexp(4)
p,Se,pexp(1),pexp(2),pexp(3),pexp(4)
d,Se,dexp(1),dexp(2),dexp(3),dexp(4)
f,Se,fexp(1),fexp(2),fexp(3)
g,Se,gexp(1),gexp(2)
h,Se,hexp(1)
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

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1),gpar(2),hpar(1) !,hpar(2)
method,bfgs,proc=opt_basis,thresh=3e-5,vstep=1e-4
maxit,100}


