***,C
memory,512,m
!gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

C 0.0 0.0 0.0
}

spar=[0.1014540, 0.2512774, 0.6223543, 1.5414236, 3.8177394]
ppar=[0.0759480, 0.1688267, 0.3752891, 0.8342395, 1.8544519]
dpar=[0.1709110, 0.3938953, 0.9078031, 2.0921965, 4.8218456]
fpar=[0.2865560, 0.5935758, 1.2295407, 2.5468865]
gpar=[0.5424600, 1.1542898, 2.4561901]
hpar=[0.8732040, 1.9716387]
ipar=[1.4652690]

proc opt_basis

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

s,C,spar(1),spar(2),spar(3),spar(4),spar(5)
p,C,ppar(1),ppar(2),ppar(3),ppar(4),ppar(5)
d,C,dpar(1),dpar(2),dpar(3),dpar(4),dpar(5)
f,C,fpar(1),fpar(2),fpar(3),fpar(4)
g,C,gpar(1),gpar(2),gpar(3)
h,C,hpar(1),hpar(2)
i,C,ipar(1)

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

{minimize,eval,spar(1),spar(2),spar(3),spar(4),spar(5),ppar(1),ppar(2),ppar(3),ppar(4),ppar(5),dpar(1),dpar(2),dpar(3),dpar(4),dpar(5),fpar(1),fpar(2),fpar(3),fpar(4),gpar(1),gpar(2),gpar(3),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=5e-6,vstep=1e-4
maxit,1000}


