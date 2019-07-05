***,Kr
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Kr 0.0 0.0 0.0
}

spar=[0.340371, 5.285385]
ppar=[0.110202, 1.844603]
dpar=[0.284446, 2.457439]
fpar=[0.696563, 2.000000]

proc opt_basis

!Calculate the exponents
N=2	!TZ
do i=1,N
sexp(i)=spar(1)*spar(2)^(i-1)
pexp(i)=ppar(1)*ppar(2)^(i-1)
dexp(i)=dpar(1)*dpar(2)^(i-1)
fexp(i)=fpar(1)*fpar(2)^(i-1)
enddo


basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Kr/ccECP/Kr.ccECP.molpro


,Kr, 59.995647, 27.757709, 12.842438, 5.941709, 2.749003, 1.271859, 0.588441, 0.272249, 0.125959
c,1.9,-0.000203, 0.001794, -0.019252, 0.171194, -0.477847, -0.119686, 0.568434, 0.564028, 0.157608
p,Kr, 24.020781, 11.612963, 5.614344, 2.714282, 1.312233, 0.634405, 0.306706, 0.148279, 0.071686
c,1.9, 0.000106, -0.000892, 0.020380, -0.155160, 0.057643, 0.355559, 0.426667, 0.271151, 0.067680

s,Kr,sexp(1),sexp(2)
p,Kr,pexp(1),pexp(2)
d,Kr,dexp(1),dexp(2)
f,Kr,fexp(1)
}

{hf                        
 wf,8,1,0
 occ,1,1,1,0,1,0,0,0
 closed,1,1,1,0,1,0,0,0
}              

_CC_NORM_MAX=2.0
{rcisd
maxit,50
core
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1) !,fpar(2)
method,bfgs,proc=opt_basis,thresh=3e-5,vstep=5e-4
maxit,100}


