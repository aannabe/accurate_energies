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

include,/global/homes/a/aannabe/docs/totals_bfd/pps/C.pp

s,C,0.051344,0.102619,0.205100,0.409924,0.819297,1.637494,3.272791,6.541187,13.073594;
c,1.9,0.013991,0.169852,0.397529,0.380369,0.180113,-0.033512,-0.121499,0.015176,-0.000705;
p,C,0.029281,0.058547,0.117063,0.234064,0.468003,0.935757,1.871016,3.741035,7.480076;
c,1.9,0.001787,0.050426,0.191634,0.302667,0.289868,0.210979,0.112024,0.054425,0.021931;

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

proc opt_rcisd

basis={

include,/global/homes/a/aannabe/docs/totals_bfd/pps/C.pp

s,C,0.051344,0.102619,0.205100,0.409924,0.819297,1.637494,3.272791,6.541187,13.073594;
c,1.9,0.013991,0.169852,0.397529,0.380369,0.180113,-0.033512,-0.121499,0.015176,-0.000705;
p,C,0.029281,0.058547,0.117063,0.234064,0.468003,0.935757,1.871016,3.741035,7.480076;
c,1.9,0.001787,0.050426,0.191634,0.302667,0.289868,0.210979,0.112024,0.054425,0.021931;

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
{rcisd
maxit,100
core
}
eval=energy

endproc


{minimize,eval,spar(1),spar(2),spar(3),spar(4),spar(5),ppar(1),ppar(2),ppar(3),ppar(4),ppar(5),dpar(1),dpar(2),dpar(3),dpar(4),dpar(5),fpar(1),fpar(2),fpar(3),fpar(4),gpar(1),gpar(2),gpar(3),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_rcisd,thresh=1e-5,vstep=1e-3
maxit,50}

{minimize,eval,spar(1),spar(2),spar(3),spar(4),spar(5),ppar(1),ppar(2),ppar(3),ppar(4),ppar(5),dpar(1),dpar(2),dpar(3),dpar(4),dpar(5),fpar(1),fpar(2),fpar(3),fpar(4),gpar(1),gpar(2),gpar(3),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=5e-6,vstep=1e-4
maxit,1000}


