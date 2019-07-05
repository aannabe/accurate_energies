***,Si
memory,512,m
gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

Si 0.0 0.0 0.0
}

spar=[0.0677040, 0.1487218, 0.3266893, 0.7176210, 1.5763600]
ppar=[0.0430900, 0.0926694, 0.1992951, 0.4286044, 0.9217575]
dpar=[0.0961490, 0.2107213, 0.4618193, 1.0121288, 2.2181936]
fpar=[0.1465580, 0.2751798, 0.5166823, 0.9701314]
gpar=[0.2608490, 0.4962078, 0.9439262]
hpar=[0.4235780, 0.8332410]
ipar=[0.6830450]

proc opt_basis

basis={
include,/global/homes/a/aannabe/docs/totals_bfd/pps/Si.pp

s,Si,0.059887,0.130108,0.282668,0.614115,1.334205,2.898645,6.297493,13.681707,29.724387;
c,1.9,0.167492,0.532550,0.464290,-0.002322,-0.268234,0.031921,-0.000106,-0.000145,0.000067;
p,Si,0.036525,0.076137,0.158712,0.330843,0.689658,1.437625,2.996797,6.246966,13.022097;
c,1.9,0.078761,0.308331,0.417773,0.281676,0.069876,-0.056306,0.000744,-0.000259,-0.000022;

s,Si,spar(1),spar(2),spar(3),spar(4),spar(5)
p,Si,ppar(1),ppar(2),ppar(3),ppar(4),ppar(5)
d,Si,dpar(1),dpar(2),dpar(3),dpar(4),dpar(5)
f,Si,fpar(1),fpar(2),fpar(3),fpar(4)
g,Si,gpar(1),gpar(2),gpar(3)
h,Si,hpar(1),hpar(2)
i,Si,ipar(1)
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

{minimize,eval,spar(1),spar(2),spar(3),spar(4),spar(5),ppar(1),ppar(2),ppar(3),ppar(4),ppar(5),dpar(1),dpar(2),dpar(3),dpar(4),dpar(5),fpar(1),fpar(2),fpar(3),fpar(4),gpar(1),gpar(2),gpar(3),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=5e-6,vstep=2e-3
maxit,20}

{minimize,eval,spar(1),spar(2),spar(3),spar(4),spar(5),ppar(1),ppar(2),ppar(3),ppar(4),ppar(5),dpar(1),dpar(2),dpar(3),dpar(4),dpar(5),fpar(1),fpar(2),fpar(3),fpar(4),gpar(1),gpar(2),gpar(3),hpar(1),hpar(2),ipar(1)
method,bfgs,proc=opt_basis,thresh=5e-6,vstep=1e-4
maxit,100}

