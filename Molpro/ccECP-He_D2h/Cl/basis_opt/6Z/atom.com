***,Cl
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Cl 0.0 0.0 0.0
}

spar=[  7.999406, 1.818475]
ppar=[  5.108255, 1.798650]
dpar=[  6.339384, 1.579911]
fpar=[  5.819684, 1.999795]
gpar=[  6.835485, 2.260260]
hpar=[ 12.600738, 2.396028]
ipar=[ 15.521805, 2.000000]




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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Cl/ccECP_He_core/Cl.ccECP.molpro

s, Cl,   352.930099,   170.036562,    81.921130,    39.468403,    19.015299,     9.161293,     4.413777,     2.126493,     1.024513,     0.493596,     0.237807,     0.114572
c, 1.12,  0.000043, -0.000705,  0.023209, -0.165085, -0.077480,  0.225544,  0.552801,  0.349034,  0.035803,  0.005039,  -0.000972,  0.000560
c, 1.12,  0.000023, -0.000003, -0.006748,  0.055658,  0.025309, -0.081840, -0.278453, -0.308794,  0.120581,  0.535710,   0.459940,  0.128297
p, Cl,    68.625610,    36.209284,    19.105291,    10.080623,     5.318891,     2.806434,     1.480773,     0.781308,     0.412246,     0.217515,     0.114769,     0.060556
c, 1.12,  0.012029,  0.091549,  0.173813,  0.269317,  0.321612,  0.230908,  0.073834,  0.008057,  0.001346,  0.000475,  0.000280,  0.000042
c, 1.12,  0.003357,  0.024632,  0.047226,  0.078162,  0.098932,  0.069537, -0.071607, -0.254488, -0.345485, -0.308020, -0.158909, -0.036181

s,Cl,0.1397140, 0.2829612, 0.5730783, 1.1606491, 2.3506499; 
p,Cl,0.0880410, 0.1918501, 0.4180603, 0.9109947, 1.9851476; 
d,Cl,0.2252700, 0.5226041, 1.2123898, 2.8126242, 6.5250098; 
f,Cl,0.3113270, 0.6539268, 1.3735405, 2.8850532; 
g,Cl,0.4382380, 0.8106119, 1.4993945; 
h,Cl,0.7690320, 1.5164780; 
i,Cl,1.2581590; 


s,Cl,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Cl,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Cl,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Cl,fexp(1),fexp(2),fexp(3),fexp(4)
g,Cl,gexp(1),gexp(2),gexp(3)
h,Cl,hexp(1),hexp(2)
i,Cl,iexp(1)
}

{hf                        
 wf,15,3,1
 occ,2,2,2,0,2,0,0,0
 closed,2,2,1,0,2,0,0,0
 !open,2.3
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


