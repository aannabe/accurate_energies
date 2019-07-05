***,O
memory,512,m
!gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

O 0.0 0.0 0.0
}

spar=[0.145689, 0.329870, 0.748802, 1.558151, 3.411568]
ppar=[0.108873, 0.286330, 0.699284, 1.748526, 2.814751]
dpar=[0.310385, 0.808076, 1.807546, 3.626549, 9.141088]
fpar=[0.445313, 1.119557, 2.414546, 5.031342]
gpar=[0.926375, 2.286779, 4.867420]
hpar=[1.520328, 3.739079]
ipar=[2.769677]

proc opt_basis

basis={
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406

s,O,54.775216,25.616801,11.980245,6.992317,2.620277,1.225429,0.577797,0.268022,0.125346;
c,1.9,-0.0012444,0.0107330,0.0018889,-0.1742537,0.0017622,0.3161846,0.4512023,0.3121534,0.0511167;
p,O,22.217266,10.747550,5.315785,2.660761,1.331816,0.678626,0.333673,0.167017,0.083598;
c,1.9,0.0104866,0.0366435,0.0803674,0.1627010,0.2377791,0.2811422,0.2643189,0.1466014,0.0458145;

s,O,spar(1),spar(2),spar(3),spar(4),spar(5)
p,O,ppar(1),ppar(2),ppar(3),ppar(4),ppar(5)
d,O,dpar(1),dpar(2),dpar(3),dpar(4),dpar(5)
f,O,fpar(1),fpar(2),fpar(3),fpar(4)
g,O,gpar(1),gpar(2),gpar(3)
h,O,hpar(1),hpar(2)
i,O,ipar(1)
}

{hf                        
wf,6,7,2
occ,1,1,1,0,1,0,0,0
!open,1.3
closed,1,1,0,0,0,0,0,0
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


