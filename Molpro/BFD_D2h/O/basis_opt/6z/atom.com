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
include,/global/homes/a/aannabe/docs/totals_bfd/pps/O.pp

s,O,0.125346,0.268022,0.573098,1.225429,2.620277,5.602818,11.980245,25.616801,54.775216;
c,1.9,0.055741,0.304848,0.453752,0.295926,0.019567,-0.128627,0.012024,0.000407,-0.000076;
p,O,0.083598,0.167017,0.333673,0.666627,1.331816,2.660761,5.315785,10.620108,21.217318;
c,1.9,0.044958,0.150175,0.255999,0.281879,0.242835,0.161134,0.082308,0.039899,0.004679;

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

proc opt_rcisd

basis={
include,/global/homes/a/aannabe/docs/totals_bfd/pps/O.pp

s,O,0.125346,0.268022,0.573098,1.225429,2.620277,5.602818,11.980245,25.616801,54.775216;
c,1.9,0.055741,0.304848,0.453752,0.295926,0.019567,-0.128627,0.012024,0.000407,-0.000076;
p,O,0.083598,0.167017,0.333673,0.666627,1.331816,2.660761,5.315785,10.620108,21.217318;
c,1.9,0.044958,0.150175,0.255999,0.281879,0.242835,0.161134,0.082308,0.039899,0.004679;

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
maxit,100}


