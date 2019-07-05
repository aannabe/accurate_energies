***,C
memory,256,m
!gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

C 0.0 0.0 0.0
}

spar=[0.101364,2.472418]
ppar=[0.076077,2.242531]
dpar=[0.164451,2.309090]
fpar=[0.310297,2.030494]
gpar=[0.568049,2.057634]
hpar=[0.887497,2.271119]
ipar=[1.381996,2.300000]

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
ecp,C,2,1,0
3
1, 14.43502,  4.00000
3, 8.39889 ,  57.74008
2, 7.38188 , -25.81955
1
2, 7.76079 ,  52.13345

s,C,13.073594,6.541187,4.573411,1.637494,0.819297,0.409924,0.231300,0.102619,0.051344;
c,1.9,0.0051583,0.0603424,-0.1978471,-0.0810340,0.2321726,0.2914643,0.4336405,0.2131940,0.0049848;
p,C,9.934169,3.886955,1.871016,0.935757,0.468003,0.239473,0.117063,0.058547,0.029281;
c,1.9,0.0209076,0.0572698,0.1122682,0.2130082,0.2835815,0.3011207,0.2016934,0.0453575,0.0029775;

s,C,sexp(1),sexp(2),sexp(3),sexp(4),sexp(5)
p,C,pexp(1),pexp(2),pexp(3),pexp(4),pexp(5)
d,C,dexp(1),dexp(2),dexp(3),dexp(4),dexp(5)
f,C,fexp(1),fexp(2),fexp(3),fexp(4)
g,C,gexp(1),gexp(2),gexp(3)
h,C,hexp(1),hexp(2)
i,C,iexp(1)
}

{hf                        
wf,4,6,2
occ,1,1,0,0,1,0,0,0
!open,1.2,1.5
closed,1,0,0,0,0,0,0,0
!sym,
}              

!_CC_NORM_MAX=2.0
{rccsd(t)
maxit,100
core
}
eval=energy

endproc

{minimize,eval,spar(1),spar(2),ppar(1),ppar(2),dpar(1),dpar(2),fpar(1),fpar(2),gpar(1),gpar(2),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=5e-6,vstep=5e-5
maxit,1000}


