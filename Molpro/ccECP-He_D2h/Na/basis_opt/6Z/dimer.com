***,Na
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
2	! Number of atoms

Na 0.0 0.0 0.0
Na 0.0 0.0 3.05
}

spar=[0.06, 2.000000]
ppar=[0.03, 2.000000]
dpar=[0.06, 2.000000]
fpar=[0.08, 2.000000]
gpar=[0.12, 2.000000]
hpar=[0.20, 2.000000]
ipar=[0.30, 2.000000]

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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Na/ccECP_He_core/Na.ccECP.molpro

s, Na,    50.364926,    24.480199,    11.898760,     5.783470,     2.811093,     1.366350,     0.664123,     0.322801,     0.156900,     0.076262,     0.037068,     0.018017
c, 1.12,    -0.001449, -0.000590, -0.118818, -0.010856,  0.250783,  0.447276,  0.347254,  0.080652,  0.001208,  0.000409,  0.000112,  0.000072
c, 1.12,     0.000212,  0.000379,  0.019582,  0.000623, -0.045781, -0.088728, -0.112952, -0.108396,  0.009901,  0.355418,  0.561451,  0.198998
p, Na,    77.769943,    42.060816,    22.748020,    12.302957,     6.653887,     3.598664,     1.946289,     1.052624,     0.569297,     0.307897,     0.166522,     0.090061
c, 1.12,  0.000054, -0.000016,  0.012571,  0.079601,  0.140442,  0.212141,  0.261799,  0.255820,  0.180359,  0.072165,   0.010663,  0.001538
c, 1.12, -0.000656,  0.003137, -0.011004,  0.009376, -0.066479,  0.058959, -0.221050,  0.303491, -0.671705,  1.064360,  -1.530489,  1.843167


s,Na,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Na,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Na,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Na,fexp(1),fexp(2),fexp(3),fexp(4)
g,Na,gexp(1),gexp(2),gexp(3)
h,Na,hexp(1),hexp(2)
i,Na,iexp(1)
}

{rhf,                     
wf,18,1,0
shift,-1.0,-0.5

!wf,9,1,1
!occ,2,1,1,0,1,0,0,0
!open,2.1
}              

_CC_NORM_MAX=2.0
{rcisd
maxit,50
core,4,2,2,0
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1),gpar(2),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=1e-4,vstep=2e-4
maxit,500}


