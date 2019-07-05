***,Al
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Al 0.0 0.0 0.0
}

spar=[0.048609, 2.191724]
ppar=[0.028704, 2.200904]
dpar=[0.069487, 2.248031]
fpar=[0.114291, 1.847470]
gpar=[0.212610, 1.813262]
hpar=[0.338765, 1.891240]
ipar=[0.510945, 2.000000]


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
ECP,Al,10,2,0;
3;  !Vd
1,5.073893,    3.000000
3,8.607001,   15.221680
2,3.027490,  -11.165685
2;  !Vs-Vd
2,7.863954,   14.879513
2,2.061358,   20.746863
2;  !Vp-Vd
2,3.125175,    7.786227
2,1.414930,    7.109015

s,   AL,  8.257944,     4.514245,     2.467734,     1.348998,     0.737436,     0.403123,     0.220369,     0.120466,     0.065853,     0.035999
c, 1.10,  0.003287,    -0.017168,     0.069766,    -0.183475,    -0.147133,     0.046882,     0.308423,     0.451564,     0.302904,     0.079545
p,   AL,  1.570603,     0.977752,     0.608683,     0.378925,     0.235893,     0.146851,     0.091420,     0.056912,     0.035429,     0.022056
c, 1.10, -0.002645,    -0.037850,     0.006636,     0.089291,     0.134421,     0.256105,     0.238970,     0.260677,     0.112350,     0.052665

s,Al,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Al,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Al,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Al,fexp(1),fexp(2),fexp(3),fexp(4)
g,Al,gexp(1),gexp(2),gexp(3)
h,Al,hexp(1),hexp(2)
i,Al,iexp(1)
}

{hf                        
wf,3,2,1       
occ,1,1,0,0,0,0,0,0
!open,1.2
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


