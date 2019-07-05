***,Al
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Al 0.0 0.0 0.0
}

spar=[4.00, 2.000000]
ppar=[2.50, 2.000000]
dpar=[3.00, 2.000000]
fpar=[2.50, 2.000000]
gpar=[4.50, 2.000000]
hpar=[4.00, 2.000000]
ipar=[8.00, 2.000000]

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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Al/ccECP_He_core/Al.ccECP.molpro

s,   AL,  78.990577,    39.484884,    19.737241,     9.866021,     4.931711,     2.465206,     1.232278,     0.615977,     0.307907,     0.153913,     0.076936,     0.038458
c, 1.12,  -0.000481,  0.013095, -0.146153, -0.045206,  0.190708,  0.453207,  0.398824,  0.103648,  0.002247,  0.000790,  -0.000140,  0.000064
c, 1.12,   0.000024, -0.002627,  0.036948,  0.010705, -0.053342, -0.144188, -0.213969, -0.125585,  0.193970,  0.484674,   0.419414,  0.110430
p,   AL,  33.993368,    17.617051,     9.130030,     4.731635,     2.452168,     1.270835,     0.658610,     0.341324,     0.176891,     0.091674,     0.047510,     0.024622
c, 1.12,   0.011908,  0.097485,  0.180474,  0.265522,  0.307977,  0.235061,  0.089631,  0.011083,  0.001577,  0.000007,   0.000215, -0.000022
c, 1.12,  -0.002183, -0.017362, -0.032292, -0.049810, -0.059926, -0.052553,  0.001989,  0.130052,  0.280089,  0.374339,   0.272857,  0.085145

s,Al,0.0486720, 0.1004105, 0.2071473, 0.4273458, 0.8816160;
p,Al,0.0995290, 0.2057446, 0.4253114, 0.8791962, 1.8174585;
d,Al,0.0764220, 0.1834840, 0.4405327, 1.0576890, 2.5394393;
f,Al,0.1210290, 0.2489962, 0.5122667, 1.0539000;
g,Al,0.2245670, 0.4342993, 0.8399093;
h,Al,0.4104180, 0.7998985;
i,Al,0.5058340;


s,Al,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Al,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Al,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Al,fexp(1),fexp(2),fexp(3),fexp(4)
g,Al,gexp(1),gexp(2),gexp(3)
h,Al,hexp(1),hexp(2)
i,Al,iexp(1)
}

{hf                        
 wf,11,2,1
 occ,2,2,1,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
 !open,2.2
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


