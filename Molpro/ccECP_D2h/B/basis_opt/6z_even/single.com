***,B
memory,256,m
!gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

B 0.0 0.0 0.0
}

spar=[0.069757,2.532865]
ppar=[0.050611,2.223375]
dpar=[0.112635,2.179890]
fpar=[0.236293,2.127040]
gpar=[0.408834,2.244834]
hpar=[0.506359,2.431965]
ipar=[0.914943,2.300000]

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
ecp,B,2,1,0
3;
1, 31.49298,  3.00000 ; 
3, 22.56509,  94.47895;
2, 8.64669 , -9.74800 ;                
1;
2, 4.06246 ,  20.74800;

s,B,11.76050,5.150520,2.578276,1.290648,0.646080,0.323418,0.161898,0.081044,0.040569;
c,1.9,-0.0036757, 0.0250517,-0.1249228,-0.0662874,0.1007341,0.3375492,0.4308431,0.2486558,0.0317295;
p,B,7.470701,3.735743,1.868068,0.934132,0.467115,0.233582,0.116803,0.058408,0.029207;
c,1.9,0.0047397,0.0376009,0.0510600,0.1456587,0.2237933,0.3199467,0.2850185,0.1448808,0.0176962;

s,B,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,B,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,B,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,B,fexp(1),fexp(2),fexp(3),fexp(4)
g,B,gexp(1),gexp(2),gexp(3)
h,B,hexp(1),hexp(2)
i,B,iexp(1)
}

{hf                        
wf,3,2,1       
occ,1,1,0,0,0,0,0,0
open,1.2
!closed,1,0,0,0,0,0,0,0
!sym,
}              

!_CC_NORM_MAX=2.0
{rccsd(t)
maxit,100
core
}
eval=energy

