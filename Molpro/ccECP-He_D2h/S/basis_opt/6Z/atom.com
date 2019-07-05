***,S
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

S 0.0 0.0 0.0
}

spar=[3.00, 2.000000]
ppar=[5.00, 2.000000]
dpar=[6.00, 2.000000]
fpar=[4.00, 2.000000]
gpar=[8.00, 2.000000]
hpar=[7.00, 2.000000]
ipar=[9.00, 2.000000]

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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/S/ccECP_He_core/S.ccECP.molpro

s, S,   306.317903,   146.602801,    70.163647,    33.580104,    16.071334,     7.691691,     3.681219,     1.761820,     0.843202,     0.403554,     0.193140,     0.092436
c, 1.12,  0.000064, -0.000785,  0.022471, -0.169871, -0.061897,  0.240039,  0.551649,  0.334386,  0.031323,  0.004436, -0.001015,  0.000507
c, 1.12,  0.000021, -0.000004, -0.006119,  0.054471,  0.019344, -0.083839, -0.265322, -0.293065,  0.113730,  0.529282,  0.466254,  0.125800
p, S,    55.148271,    29.056588,    15.309371,     8.066220,     4.249940,     2.239213,     1.179799,     0.621614,     0.327517,     0.172562,     0.090920,     0.047904
c, 1.12,  0.013447,  0.101670,  0.185192,  0.275836,  0.317073,  0.217066,  0.065765,  0.006517,  0.001111,  0.000222,  0.000181,  0.000008
c, 1.12,  0.003542,  0.025797,  0.047260,  0.075594,  0.091980,  0.062067, -0.071253, -0.250206, -0.349295, -0.312700, -0.155898, -0.030418

s,S,0.1094050, 0.2248644, 0.4621725, 0.9499212, 1.9524100; 
p,S,0.2197150, 0.4465947, 0.9077524, 1.8451057, 3.7503784; 
d,S,0.1799810, 0.4162311, 0.9625922, 2.2261283, 5.1482312; 
f,S,0.2429070, 0.5049293, 1.0495936, 2.1817838; 
g,S,0.3768990, 0.6748976, 1.2085114; 
h,S,0.6485060, 1.2124643; 
i,S,1.0200260; 


s,S,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,S,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,S,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,S,fexp(1),fexp(2),fexp(3),fexp(4)
g,S,gexp(1),gexp(2),gexp(3)
h,S,hexp(1),hexp(2)
i,S,iexp(1)
}

{hf                        
 wf,14,7,2
 occ,2,2,2,0,2,0,0,0
 closed,2,2,1,0,1,0,0,0
 !open,2.3,2.5
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


