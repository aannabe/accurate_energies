***,S
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

S 0.0 0.0 0.0
}

spar=[0.110309, 1.844518]
ppar=[0.068647, 2.114501]
dpar=[0.159223, 2.166535]
fpar=[0.215011, 1.967940]
gpar=[0.377121, 1.989453]
hpar=[0.614236, 2.091298]
ipar=[1.037607, 2.500000]

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
ECP,S,10,2,0;
3;  !Vd
 1,  6.151144,   6.000000
 3, 11.561575,  36.906864
 2,  5.390961, -19.819533
2;  !Vs-Vd
 2, 16.117687,  15.925748
 2,  3.608629,  38.515895
2;  !Vp-Vd
 2,  6.228956,   8.062221
 2,  2.978074,  18.737525

s,    S,  14.052570,  7.864913,  4.401818,  2.463600,  1.378823,  0.771696,  0.431901,  0.241726,  0.135289,  0.075718
c, 1.10,   0.002102, -0.011042,  0.086618, -0.271004, -0.151274,  0.136044,  0.394360,  0.432098,  0.230974,  0.051205
p,    S,   6.808844,  3.941560,  2.281723,  1.320863,  0.764632,  0.442637,  0.256237,  0.148333,  0.085868,  0.049708
c, 1.10,  -0.003573,  0.001903, -0.065016,  0.042305,  0.158772,  0.278172,  0.293821,  0.248015,  0.114905,  0.032934

s,S,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,S,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,S,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,S,fexp(1),fexp(2),fexp(3),fexp(4)
g,S,gexp(1),gexp(2),gexp(3)
h,S,hexp(1),hexp(2)
i,S,iexp(1)
}

{hf                        
wf,6,7,2
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,0,0,0,0
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


