***,B
memory,512,m
!gthresh,twoint=1.e-12

print,basis,orbitals

angstrom
geometry={                 
1	! Number of atoms

B 0.0 0.0 0.0
}

basis={
ecp,B,2,1,0
3;
1, 31.49298,  3.00000 ; 
3, 22.56509,  94.47895;
2, 8.64669 , -9.74800 ;                
1;
2, 4.06246 ,  20.74800;

include,basis.dat
}

{hf                        
wf,3,3,1       
occ,1,0,1,0,0,0,0,0
open,2.3
!sym,
}              
scf(i)=energy

!_CC_NORM_MAX=2.0
{rcisd
maxit,100
core
}
eval(i)=energy
kinetic(i)=ekin

table,scf,eval,ekin
save, atom.csv, new
type,csv

