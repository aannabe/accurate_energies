***,Cl
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Cl 0.0 0.0 0.0
}

spar=[0.137508, 2.190803]
ppar=[0.085592, 2.074316]
dpar=[0.208789, 2.292551]
fpar=[0.282574, 1.989940]
gpar=[0.446166, 1.996015]
hpar=[0.746502, 2.113928]
ipar=[1.263442, 2.500000]

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
ecp,Cl,10,2,0
3
1, 7.944352 ,   7.000000    
3, 12.801261,   55.610463  
2, 6.296744 ,   -22.86078  
2
2, 17.908432,   15.839234  
2, 4.159880 ,   44.469504  
2
2, 7.931763 ,   8.321946   
2, 3.610412 ,   24.044745  

s,  Cl,  15.583847,  8.858485,  5.035519,  2.862391,  1.627098,  0.924908,  0.525755,  0.298860,  0.169884,  0.096569
c, 1.10,  0.002501, -0.010046,  0.085810, -0.290136, -0.140314,  0.146839,  0.392484,  0.425061,  0.227195,  0.059828
p,  Cl,   7.682894,  4.507558,  2.644587,  1.551581,  0.910313,  0.534081,  0.313346,  0.183840,  0.107859,  0.063281
c, 1.10, -0.004609, -0.001798, -0.068614,  0.062352,  0.166337,  0.282292,  0.275967,  0.241328,  0.110223,  0.040289

s,Cl,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Cl,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Cl,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Cl,fexp(1),fexp(2),fexp(3),fexp(4)
g,Cl,gexp(1),gexp(2),gexp(3)
h,Cl,hexp(1),hexp(2)
i,Cl,iexp(1)
}

{hf                        
wf,7,3,1
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,1,0,0,0
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


