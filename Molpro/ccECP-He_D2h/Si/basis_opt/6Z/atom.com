***,Si
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Si 0.0 0.0 0.0
}

spar=[  2.039960, 1.997652]
ppar=[  3.077427, 2.074699]
dpar=[  3.897419, 1.730000]
fpar=[  3.507112, 2.002250]
gpar=[  4.626176, 2.176201]
hpar=[  7.427265, 2.385919]
ipar=[ 12.571789, 2.000000]




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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Si/ccECP_He_core/Si.ccECP.molpro

s, Si, 96.651837,    48.652547,    24.490692,    12.328111,     6.205717,     3.123831,     1.572472,     0.791550,     0.398450,     0.200572,     0.100964,     0.050823
c, 1.12, -0.000440,  0.018671, -0.154353, -0.057738,  0.168087,  0.453428,  0.417675,  0.111901,  0.003337,  0.000995, -0.000038,  0.000069
c, 1.12, -0.000004, -0.004421,  0.043362,  0.015853, -0.051706, -0.162895, -0.250218, -0.124216,  0.246325,  0.505899,  0.386314,  0.087701
p, Si, 40.315996,    21.171265,    11.117733,     5.838290,     3.065879,     1.609995,     0.845462,     0.443980,     0.233149,     0.122434,     0.064294,     0.033763
c, 1.12, 0.012938,  0.098129,  0.179324,  0.263886,  0.309272,  0.232748,  0.085900,  0.010260,  0.001560, -0.000003, 0.000232, -0.000023
c, 1.12, 0.002833,  0.020869,  0.038236,  0.059679,  0.072776,  0.061129, -0.016776, -0.172259, -0.321196, -0.362828, -0.220789, -0.055152

s,Si,0.0687840, 0.1409414, 0.2887952, 0.5917541, 1.2125302; 
p,Si,0.1492630, 0.3014517, 0.6088122, 1.2295577, 2.4832159; 
d,Si,0.1120670, 0.2692452, 0.6468719, 1.5541343, 3.7338667; 
f,Si,0.1430000, 0.2908438, 0.5915394, 1.2031161; 
g,Si,0.2925650, 0.5664802, 1.0968495; 
h,Si,0.4804570, 0.9431885; 
i,Si,0.6166890; 


s,Si,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Si,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Si,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Si,fexp(1),fexp(2),fexp(3),fexp(4)
g,Si,gexp(1),gexp(2),gexp(3)
h,Si,hexp(1),hexp(2)
i,Si,iexp(1)
}

{hf                        
 wf,12,4,2
 occ,2,2,2,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
 !open,2.2,2.3
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


