***,P
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

P 0.0 0.0 0.0
}

spar=[ 2.029297, 2.105857]
ppar=[ 4.226645, 2.007303]
dpar=[ 4.983737, 1.830243]
fpar=[ 4.349088, 1.984226]
gpar=[ 5.259572, 2.181903]
hpar=[10.053228, 2.048852]
ipar=[12.599089, 2.000000]



proc opt_basis

!Calculate the exponents
N=5	!6Z
do i=1,N
sexp(i)=spar(1)*spar(2)^(i-1)
pexp(i)=ppar(1)*ppar(2)^(i-1)
dexp(i)=dpar(1)*dpar(2)^(i-1)
enddo
do i=1,N-1
fexp(i)=fpar(1)*fpar(2)^(i-1)
enddo
do i=1,N-2
gexp(i)=gpar(1)*gpar(2)^(i-1)
enddo
do i=1,N-3
hexp(i)=hpar(1)*hpar(2)^(i-1)
enddo
do i=1,N-4
iexp(i)=ipar(1)*ipar(2)^(i-1)
enddo

basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/P/ccECP_He_core/P.ccECP.molpro

s, P,   269.443884,   127.601401,    60.428603,    28.617367,    13.552418,     6.418062,     3.039422,     1.439389,     0.681656,     0.322814,     0.152876,     0.072398
c, 1.12,  0.000055, -0.000624,  0.019400, -0.165509, -0.054265,  0.254440,  0.549661,  0.322285,  0.026632,  0.004203, -0.001233,  0.000497
c, 1.12,  0.000018, -0.000026, -0.004933,  0.050120,  0.015801, -0.084463, -0.246742, -0.276326,  0.100274,  0.517201,  0.479758,  0.124099
p, P,    48.154282,    25.406431,    13.404555,     7.072308,     3.731384,     1.968696,     1.038693,     0.548020,     0.289138,     0.152550,     0.080486,     0.042465
c, 1.12,    0.012884,  0.097095,  0.178215,  0.265964,  0.312933,  0.230686,  0.080489,  0.009085,  0.001248, -0.000066,   0.000129, -0.000029
c, 1.12,   -0.003152, -0.023006, -0.042398, -0.067477, -0.082952, -0.066026,  0.034468,  0.209018,  0.347179,  0.344806,   0.181731,  0.036649

s,P,0.0807550, 0.1675510, 0.3476361, 0.7212777, 1.4965121; 
p,P,0.1998550, 0.4015834, 0.8069313, 1.6214268, 3.2580529; 
d,P,0.1515550, 0.3580063, 0.8456895, 1.9977047, 4.7190180; 
f,P,0.2002450, 0.3947470, 0.7781726, 1.5340272; 
g,P,0.3704610, 0.7160285, 1.3839428; 
h,P,0.6592140, 1.2872716; 
i,P,0.8940330; 


s,P,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,P,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,P,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,P,fexp(1),fexp(2),fexp(3),fexp(4)
g,P,gexp(1),gexp(2),gexp(3)
h,P,hexp(1),hexp(2)
i,P,iexp(1)
}

{hf                        
 wf,13,8,3
 occ,2,2,2,0,2,0,0,0
 closed,2,1,1,0,1,0,0,0
 !open,2.3,2.5,2.2
}              

_CC_NORM_MAX=2.0
{rcisd
maxit,50
!core,1,1,1,0,1,0,0,0
core
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1),gpar(2),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=1e-4,vstep=2e-4
maxit,500}


