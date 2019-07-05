***,P
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

P 0.0 0.0 0.0
}

spar=[0.070889, 1.880845]
ppar=[0.060207, 2.089820]
dpar=[0.130484, 2.175214]
fpar=[0.191496, 1.898237]
gpar=[0.333820, 1.923523]
hpar=[0.539695, 2.025340]
ipar=[0.877224, 2.500000]

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
ECP,P,10,2,0;
3;  !Vd
 1,  5.872694,   5.000000 
 3,  9.891298,  29.363469 
 2,  4.692469, -17.011136 
2;  !Vs-Vd            
 2, 12.091334,  15.259383 
 2,  3.044535,  31.707918 
2;  !Vp-Vd            
 2,  4.310884,   7.747190 
 2,  2.426903,  13.932528 

s,    P,  5.054268,  3.094719,  1.894891,  1.160239,  0.710412,  0.434984,  0.266340,  0.163080,  0.099853,  0.061140
c, 1.10,  0.001781,  0.077653, -0.312344, -0.045804, -0.029427,  0.318560,  0.309169,  0.376899,  0.152113,  0.054943
p,    P,  5.861284,  3.406365,  1.979655,  1.150503,  0.668631,  0.388584,  0.225831,  0.131245,  0.076275,  0.044328
c, 1.10, -0.003160,  0.007462, -0.060893,  0.015297,  0.123431,  0.257276,  0.305131,  0.276016,  0.134133,  0.040073

s,P,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,P,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,P,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,P,fexp(1),fexp(2),fexp(3),fexp(4)
g,P,gexp(1),gexp(2),gexp(3)
h,P,hexp(1),hexp(2)
i,P,iexp(1)
}

{hf                        
wf,5,8,3
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,0,0,0,0,0,0,0
!sym,
}              

_CC_NORM_MAX=2.0
{rccsd(t)
maxit,100
core
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1),gpar(2),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=1e-5,vstep=5e-4
maxit,1000}


