***,Mg
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
2	! Number of atoms

Mg 0.0 0.0 0.0
Mg 0.0 0.0 3.8905
}
spar=[0.028489, 2.165046]
ppar=[0.071689, 2.188812]
dpar=[0.073331, 2.017709]
fpar=[0.111666, 1.641726]
gpar=[0.183384, 1.752561]
hpar=[0.257914, 1.816447]
ipar=[0.373982, 2.000000]


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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Mg/ccECP_He_core/Mg.ccECP.molpro

s, Mg,    63.931893,    31.602596,    15.621687,     7.722059,     3.817142,     1.886877,     0.932714,     0.461056,     0.227908,     0.112659,     0.055689,     0.027528
c, 1.12, -0.000794,  0.007479, -0.136246, -0.032033,  0.216823,  0.451364,  0.377599,  0.094319,  0.001703,  0.000485, -0.000151,  0.000031
c, 1.12,  0.000106, -0.001086,  0.028676,  0.005781, -0.050653, -0.116877, -0.165121, -0.118016,  0.108365,  0.414755,  0.477633,  0.173476
p, Mg,    28.231094,    14.891993,     7.855575,     4.143841,     2.185889,     1.153064,     0.608245,     0.320851,     0.169250,     0.089280,     0.047095,     0.024843
c, 1.12,  0.011317,  0.087039,  0.162683,  0.241386,  0.290064,  0.252991,  0.133097,  0.028941,  0.003209,  0.000268,  0.000257, -0.000037
c, 1.12, -0.001822, -0.013603, -0.025700, -0.039076, -0.048779, -0.045990, -0.031658,  0.049178,  0.186909,  0.379396,  0.335431,  0.184058


s,Mg,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Mg,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Mg,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Mg,fexp(1),fexp(2),fexp(3),fexp(4)
g,Mg,gexp(1),gexp(2),gexp(3)
h,Mg,hexp(1),hexp(2)
i,Mg,iexp(1)
}

{hf                        
wf,20,1,0       
!occ,2,0,0,0,0,0,0,0
!open,1.3
!closed,2,0,0,0,0,0,0,0
!sym,
}              

_CC_NORM_MAX=2.0
{rcisd
maxit,100
core,4,2,2,0
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1),gpar(2),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=1e-5,vstep=1e-4
maxit,500}


