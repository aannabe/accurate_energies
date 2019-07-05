***,Ar
memory,512,m
gthresh,twoint=1.e-12
GTHRESH,THROVL=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Ar 0.0 0.0 0.0
}

spar=[ 8.687602, 1.874381]
ppar=[ 4.741215, 2.193244]
dpar=[ 8.353374, 1.621729]
fpar=[ 7.069621, 2.201274]
gpar=[ 7.259550, 2.300812]
hpar=[14.781316, 2.208353]
ipar=[15.627660, 2.000000]



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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ar/ccECP_He_core/Ar.ccECP.molpro

s, Ar, 400.805381,   194.251428,    94.144487,    45.627384,    22.113437,    10.717338,     5.194187,     2.517377,     1.220054,     0.591302,     0.286576,     0.138890
c, 1.12,  0.000092, -0.001254,  0.028879, -0.177106, -0.077165,  0.210187,  0.554369,  0.359070,  0.040769,  0.005087, -0.000644,  0.000533
c, 1.12,  0.000019,  0.000114, -0.008693,  0.061175,  0.026792, -0.077780, -0.290747, -0.320036,  0.123933,  0.539163,  0.456260,  0.131892
p, Ar,  71.845693,    38.318786,    20.437263,    10.900182,     5.813595,     3.100671,     1.653738,     0.882019,     0.470423,     0.250899,     0.133817,     0.071371
c, 1.12,   0.014239,  0.103178,  0.185184,  0.276357,  0.318130,  0.211494,  0.061926,  0.005821,  0.000838, -0.000047,  0.000077, -0.000018
c, 1.12,   0.004145,  0.028800,  0.051916,  0.084356,  0.103303,  0.059763, -0.098524, -0.272871, -0.342112, -0.289317, -0.143329, -0.032495

s,Ar,0.1593120, 0.3164341, 0.6285185, 1.2483974, 2.4796343; 
p,Ar,0.1089120, 0.2389328, 0.5241743, 1.1499415, 2.5227589; 
d,Ar,0.2819600, 0.6565303, 1.5286994, 3.5595031, 8.2881320; 
f,Ar,0.4006320, 0.8117257, 1.6446480, 3.3322427; 
g,Ar,0.5104570, 0.9657918, 1.8272916; 
h,Ar,0.8968260, 1.8343616; 
i,Ar,1.5168700; 

s,Ar,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Ar,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Ar,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Ar,fexp(1),fexp(2),fexp(3),fexp(4)
g,Ar,gexp(1),gexp(2),gexp(3)
h,Ar,hexp(1),hexp(2)
i,Ar,iexp(1)
}

{hf                        
 wf,16,1,0
 occ,2,2,2,0,2,0,0,0
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


