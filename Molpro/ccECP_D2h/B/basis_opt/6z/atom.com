***,B
memory,512,m
!gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

B 0.0 0.0 0.0
}

spar=[0.0689990, 0.1662683, 0.4006600, 0.9654784, 2.3265325]
ppar=[0.0513270, 0.1142870, 0.2544766, 0.5666290, 1.2616817]
dpar=[0.1129170, 0.2572265, 0.5859656, 1.3348378, 3.0407792]
fpar=[0.1998180, 0.4046153, 0.8193131, 1.6590427]
gpar=[0.3787240, 0.7698327, 1.5648396]
hpar=[0.5599000, 1.2630219]
ipar=[0.9813140]

proc opt_basis

basis={
ecp,B,2,1,0
3;
1, 31.49298,  3.00000 ; 
3, 22.56509,  94.47895;
2, 8.64669 , -9.74800 ;                
1;
2, 4.06246 ,  20.74800;

s,B,11.76050,5.150520,2.578276,1.290648,0.646080,0.323418,0.161898,0.081044,0.040569;
c,1.9,-0.0036757, 0.0250517,-0.1249228,-0.0662874,0.1007341,0.3375492,0.4308431,0.2486558,0.0317295;
p,B,7.470701,3.735743,1.868068,0.934132,0.467115,0.233582,0.116803,0.058408,0.029207;
c,1.9,0.0047397,0.0376009,0.0510600,0.1456587,0.2237933,0.3199467,0.2850185,0.1448808,0.0176962;

s,B,spar(1),spar(2),spar(3),spar(4),spar(5)
p,B,ppar(1),ppar(2),ppar(3),ppar(4),ppar(5)
d,B,dpar(1),dpar(2),dpar(3),dpar(4),dpar(5)
f,B,fpar(1),fpar(2),fpar(3),fpar(4)
g,B,gpar(1),gpar(2),gpar(3)
h,B,hpar(1),hpar(2)
i,B,ipar(1)

}

{hf                        
wf,3,3,1       
occ,1,0,1,0,0,0,0,0
!open,1.3
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


