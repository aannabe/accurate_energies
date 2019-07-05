***,Br
memory,512,m
gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Br 0.0 0.0 0.0
}

spar=[0.124090, 2.116692]
ppar=[0.078617, 2.035192]
dpar=[0.168732, 1.950502]
fpar=[0.237778, 1.833176]
gpar=[0.370795, 1.911482]
hpar=[0.604519, 2.024321]
ipar=[1.001427, 2.000000]


proc opt_basis

!Calculate the exponents
N=5	!6Z
do i=1,N
sexp(i)=spar(1)*spar(2)^(i-1)
pexp(i)=ppar(1)*ppar(2)^(i-1)
dexp(i)=dpar(1)*dpar(2)^(i-1)
fexp(i)=fpar(1)*fpar(2)^(i-1)
gexp(i)=gpar(1)*gpar(2)^(i-1)
hexp(i)=hpar(1)*hpar(2)^(i-1)
iexp(i)=ipar(1)*ipar(2)^(i-1)
enddo


basis={
include,/global/homes/a/aannabe/repos/pseudopotentiallibrary/recipes/Br/ccECP/Br.ccECP.molpro

s,Br, 60.457695, 27.422852, 12.438662, 5.642021, 2.559150, 1.160798, 0.526524, 0.238824, 0.108328
c,1.9,-0.000452, 0.003372, -0.025045, 0.170101, -0.430992, -0.154358, 0.525458, 0.592735, 0.169490
p,Br, 27.437987, 12.887440, 6.053145, 2.843122, 1.335395, 0.627226, 0.294604, 0.138374, 0.064993
c,1.9, 0.000087, -0.001797, 0.027150, -0.134143, -0.006234, 0.309551, 0.440285, 0.316750, 0.092533


s,Br,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Br,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Br,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Br,fexp(1),fexp(2),fexp(3),fexp(4)
g,Br,gexp(1),gexp(2),gexp(3)
h,Br,hexp(1),hexp(2)
i,Br,iexp(1)
}

{hf                        
 wf,7,5,1
 occ,1,1,1,0,1,0,0,0
 closed,1,1,1,0,0,0,0,0

}              

_CC_NORM_MAX=2.0
{rcisd
maxit,50
core
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1),gpar(2),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=3e-5,vstep=5e-4
maxit,50}


