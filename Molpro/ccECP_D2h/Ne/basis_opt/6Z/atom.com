***,Ne
memory,512,m
!gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Ne 0.0 0.0 0.0
}

spar=[0.25,2.0]
ppar=[0.20,2.1]
dpar=[0.60,2.2]
fpar=[1.20,2.4]
gpar=[2.00,2.6]
hpar=[2.20,2.8]
ipar=[4.00,1.0]

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
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Ne/ccECP/Ne.ccECP.molpro

s,Ne,   89.999848, 44.745732, 22.246488, 11.060411, 5.4989673, 2.7339526, 1.3592546, 0.6757883, 0.3359855, 0.1670438
c,1.10, 0.0000337, -0.0005586, 0.0185884, -0.1268973, -0.0485302, 0.1789178, 0.3770102, 0.3900693, 0.1855301, 0.0249438
p,Ne,   40.001333, 20.592442, 10.600863, 5.4572600, 2.8093642, 1.4462435, 0.7445173, 0.3832730, 0.1973066, 0.1015722
c,1.10, 0.0036474, 0.0330182, 0.0681433, 0.1351194, 0.2148419, 0.2649520, 0.2584338, 0.1904296, 0.0847494, 0.0154205

s,Ne,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Ne,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Ne,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Ne,fexp(1),fexp(2),fexp(3),fexp(4)
g,Ne,gexp(1),gexp(2),gexp(3)
h,Ne,hexp(1),hexp(2)
i,Ne,iexp(1)
}

{hf                        
 wf,8,1,0
 occ,1,1,1,0,1,0,0,0
}              

!_CC_NORM_MAX=2.0
{rcisd
maxit,100
core
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1),gpar(2),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=5e-5,vstep=5e-4
maxit,100}


