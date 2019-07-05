***,N
memory,512,m
!gthresh,twoint=1.e-12

!print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

N 0.0 0.0 0.0
}

spar=[0.0973400, 0.2184005, 0.4900223, 1.0994568, 2.4668369]
ppar=[0.1046280, 0.2358928, 0.5318407, 1.1990805, 2.7034301]
dpar=[0.2418740, 0.5627566, 1.3093388, 3.0463758, 7.0878564]
fpar=[0.3869120, 0.8256215, 1.7617722, 3.7593998]
gpar=[0.7551480, 1.6628351, 3.6615613]
hpar=[1.1950330, 2.7709744]
ipar=[2.0547020]

proc opt_basis

basis={
include,/global/homes/a/aannabe/docs/totals_bfd/pps/N.pp

s,N,0.098869,0.211443,0.452197,0.967080,2.068221,4.423150,9.459462,20.230246,43.264919;
c,1.9,0.067266,0.334290,0.454257,0.267861,0.000248,-0.132606,0.014437,0.000359,-0.000094;
p,N,0.073234,0.145867,0.290535,0.578683,1.152612,2.295756,4.572652,9.107739,18.140657;
c,1.9,0.035758,0.153945,0.277656,0.297676,0.234403,0.140321,0.067219,0.031594,0.003301;

s,N,spar(1),spar(2),spar(3),spar(4),spar(5)
p,N,ppar(1),ppar(2),ppar(3),ppar(4),ppar(5)
d,N,dpar(1),dpar(2),dpar(3),dpar(4),dpar(5)
f,N,fpar(1),fpar(2),fpar(3),fpar(4)
g,N,gpar(1),gpar(2),gpar(3)
h,N,hpar(1),hpar(2)
i,N,ipar(1)
}

{hf                        
wf,5,8,3
occ,1,1,1,0,1,0,0,0
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

proc opt_rcisd

basis={
include,/global/homes/a/aannabe/docs/totals_bfd/pps/N.pp

s,N,0.098869,0.211443,0.452197,0.967080,2.068221,4.423150,9.459462,20.230246,43.264919;
c,1.9,0.067266,0.334290,0.454257,0.267861,0.000248,-0.132606,0.014437,0.000359,-0.000094;
p,N,0.073234,0.145867,0.290535,0.578683,1.152612,2.295756,4.572652,9.107739,18.140657;
c,1.9,0.035758,0.153945,0.277656,0.297676,0.234403,0.140321,0.067219,0.031594,0.003301;

s,N,spar(1),spar(2),spar(3),spar(4),spar(5)
p,N,ppar(1),ppar(2),ppar(3),ppar(4),ppar(5)
d,N,dpar(1),dpar(2),dpar(3),dpar(4),dpar(5)
f,N,fpar(1),fpar(2),fpar(3),fpar(4)
g,N,gpar(1),gpar(2),gpar(3)
h,N,hpar(1),hpar(2)
i,N,ipar(1)
}

{hf                        
wf,5,8,3
occ,1,1,1,0,1,0,0,0
!open,1.3
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
maxit,100}


