***,Ar
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Ar 0.0 0.0 0.0
}

spar=[0.169228, 2.193923]
ppar=[0.107588, 2.116376]
dpar=[0.240005, 2.146510]
fpar=[0.359695, 1.915394]
gpar=[0.545663, 2.008603]
hpar=[0.896275, 2.117248]
ipar=[1.519221, 2.500000]

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
ecp,Ar,10,2,0
3
1, 8.317181 ,   8.000000   
3, 13.124648,   66.537451  
2, 6.503132 ,   -24.100393 
2
2, 27.068139,   18.910152  
2, 4.801263 ,   53.040012  
2
2, 11.135735,   8.015534   
2, 4.126631 ,   28.220208  

s,  Ar,  17.798602,  10.185798,  5.829136,  3.335903,  1.909073,  1.092526,  0.625231,  0.357808,  0.204767,  0.117184 
c, 1.10,  0.000155,   0.002011,  0.072819, -0.297567, -0.143663,  0.157775,  0.391895,  0.424724,  0.223240,  0.063299
p,  Ar,   7.610920,   4.581784,  2.758240,  1.660464,  0.999601,  0.601761,  0.362261,  0.218082,  0.131285,  0.079034
c, 1.10, -0.008071,  -0.012332, -0.061298,  0.101944,  0.172497,  0.288747,  0.247918,  0.231893,  0.095994,  0.046211

s,Ar,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Ar,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Ar,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Ar,fexp(1),fexp(2),fexp(3),fexp(4)
g,Ar,gexp(1),gexp(2),gexp(3)
h,Ar,hexp(1),hexp(2)
i,Ar,iexp(1)
}

{hf                        
wf,8,1,0       
occ,1,1,1,0,1,0,0,0
!open,1.2
closed,1,1,1,0,1,0,0,0
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


