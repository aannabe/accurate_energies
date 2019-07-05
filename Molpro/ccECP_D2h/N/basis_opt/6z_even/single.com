***,N
memory,256,m
!gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

N 0.0 0.0 0.0
}

spar=[0.100757,2.332865]
ppar=[0.110611,2.223375]
dpar=[0.302635,2.179890]
fpar=[0.506293,2.127040]
gpar=[1.008834,2.244834]
hpar=[2.006359,2.331965]
ipar=[2.514943,2.300000]

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
ecp,N,2,1,0
6
1,  12.91881,    3.25000 
1,  9.22825 ,    1.75000
3,  12.96581,    41.98612 
3,  8.05477 ,    16.14945
2,  12.54876,   -26.09522 
2,  7.53360 ,   -10.32626 
2
2,  9.41609,     34.77692 
2,  8.16694,     15.20330 

s,N,42.693822,19.963207,9.3345971,4.9278187,2.040920,0.967080,0.476131,0.211443,0.098869
c,1.9,-0.0009357,0.0063295,0.0105038,-0.1653735,-0.0005352,0.2452063,0.4582128,0.3641224,0.0620406
p,N,18.925871,9.225603,4.581431,2.300164,1.154825,0.582039,0.290535,0.145867,0.073234
c,1.9,0.0073505,0.0292844,0.0652168,0.1405153,0.2328188,0.2989556,0.2802507,0.1527995,0.0355475

s,N,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,N,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,N,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,N,fexp(1),fexp(2),fexp(3),fexp(4)
g,N,gexp(1),gexp(2),gexp(3)
h,N,hexp(1),hexp(2)
i,N,iexp(1)
}

{hf                        
wf,5,8,3       
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,0,0,0,0,0,0,0
!sym,
}              

!_CC_NORM_MAX=2.0
{rccsd(t)
maxit,100
core
}
eval=energy


