***,Ga
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Ga 0.0 0.0 0.0
}

spar=[0.072217, 5.081873]
ppar=[0.035065, 2.458991]
dpar=[0.108370, 2.746781]
fpar=[0.297776, 2.000000]

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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ga/ccECP/Ga.ccECP.molpro

s,Ga, 31.011369, 13.757663, 6.103352, 2.707648, 1.201202, 0.532893, 0.236409, 0.104879, 0.046528
c,1.9, -0.000046, 0.000207, -0.008282, 0.085722, -0.350699, 0.004567, 0.452968, 0.558187, 0.163319
p,Ga, 15.391968, 6.919798, 3.110948, 1.398595, 0.628769, 0.282677, 0.127084, 0.057133, 0.025686
c,1.9,-0.000120, -0.000202, 0.008853, -0.073708, 0.028260, 0.221463, 0.413320, 0.385686, 0.112292

s,Ga,sexp(1),sexp(2)
p,Ga,pexp(1),pexp(2)
d,Ga,dexp(1),dexp(2)
f,Ga,fexp(1)
}

{hf                        
wf,3,2,1
occ,1,1,0,0,0,0,0,0
closed,1,0,0,0,0,0,0,0
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


