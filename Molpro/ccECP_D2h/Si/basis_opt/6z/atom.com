***,Si
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Si 0.0 0.0 0.0
}

spar=[0.067704, 2.196647]
ppar=[0.043090, 2.150602]
dpar=[0.096149, 2.191612]
fpar=[0.146558, 1.877617]
gpar=[0.260849, 1.902280]
hpar=[0.423578, 1.967149]
ipar=[0.683045, 2.500000]

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
ECP,Si,10,2,0;
3;  !Vd
1,5.168316,    4.000000
3,8.861690,   20.673264
2,3.933474,  -14.818174
2;  !Vs-Vd
2,9.447023,   14.832760
2,2.553812,   26.349664
2;  !Vp-Vd
2,3.660001,    7.621400
2,1.903653,   10.331583

s,   Si,  9.998274,  5.517644,  3.044965,  1.680393,  0.927341,  0.511762,  0.282421,  0.155857,  0.086011,  0.047466
c, 1.10,  0.002894, -0.014523,  0.077634, -0.224022, -0.149080,  0.085944,  0.355394,  0.445219,  0.267230,  0.060787
p,   Si,  5.027868,  2.867751,  1.635683,  0.932947,  0.532126,  0.303509,  0.173113,  0.098739,  0.056318,  0.032122
c, 1.10, -0.003242,  0.010649, -0.049761, -0.000017,  0.106060,  0.236202,  0.310665,  0.294696,  0.153898,  0.042337

s,Si,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,Si,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,Si,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,Si,fexp(1),fexp(2),fexp(3),fexp(4)
g,Si,gexp(1),gexp(2),gexp(3)
h,Si,hexp(1),hexp(2)
i,Si,iexp(1)
}

{hf                        
wf,4,6,2
occ,1,1,0,0,1,0,0,0
!open,1.2,1.5
closed,1,0,0,0,0,0,0,0
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


