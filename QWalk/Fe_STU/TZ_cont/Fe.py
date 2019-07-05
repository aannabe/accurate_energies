#! /usr/bin/env python3

import sys,os
from pyscf import scf,gto,lib
import numpy as np

#workdir = os.path.realpath(os.path.join(__file__,'/home/gani/Desktop/notes/scripts/genbas/basis'))
#workdir=dirpath = os.getcwd()
#basfile = os.path.join(workdir,'nwchem.bas')

#~~~~Build the molecule~~~~
mol = gto.Mole()
mol.atom = '''Fe 0.0 0.0 0.0 '''
#mol.basis = {'Fe': gto.load(basfile,'Fe')}
#mol.basis = {'Fe':'bfd-vtz'}
mol.basis = {'Fe': gto.basis.parse('''
Fe    S
 4316265.000000              1.000
Fe    S
 646342.4000000              1.000 
Fe    S
 147089.7000000              1.000 
Fe    S
  41661.5200000              1.000 
Fe    S
  13590.7700000              1.000 
Fe    S
   4905.7500000              1.000 
Fe    S
   1912.7460000              1.000 
Fe    S
    792.6043000              1.000 
Fe    S
    344.8065000              1.000 
Fe    S
    155.8999000              1.000 
Fe    S
     72.2309100              1.000 
Fe    S
     32.7250600              1.000 
Fe    S
     15.6676200              1.000 
Fe    S
      7.5034830              1.000 
Fe    S
      3.3122230              1.000 
Fe    S
      1.5584710              1.000 
Fe    S
      0.6839140              1.000 
Fe    S
      0.1467570              1.000 
Fe    S
      0.0705830              1.000 
Fe    S
      0.0314490              1.0000000        
Fe    S
      4.6844000              1.0000000        
Fe    S
      1.2204000              1.0000000        
Fe    S
      0.0140100              1.0000000        
Fe    P
  17745.6900000              1.000
Fe    P
   4200.7210000              1.000
Fe    P
   1364.4290000              1.000
Fe    P
    522.0806000              1.000
Fe    P
    221.4595000              1.000
Fe    P
    100.9096000              1.000
Fe    P
     48.4011500              1.000
Fe    P
     23.9853600              1.000
Fe    P
     12.1825000              1.000
Fe    P
      6.2422980              1.000
Fe    P
      3.1109440              1.000
Fe    P
      1.5099580              1.000
Fe    P
      0.7108450              1.000
Fe    P
      0.2725980              1.000
Fe    P
      0.1039720              1.000
Fe    P
      0.0381660              1.0000000        
Fe    P
      6.8788000              1.0000000        
Fe    P
      1.5748000              1.0000000        
Fe    P
      0.0140100              1.0000000        
Fe    D
    114.8840000              1.000
Fe    D
     33.8878000              1.000
Fe    D
     12.3730000              1.000
Fe    D
      4.9992500              1.000
Fe    D
      2.0704300              1.000
Fe    D
      0.8281830              1.000
Fe    D
      0.3075470              1.000
Fe    D
      0.0994550              1.0000000        
Fe    D
      4.5305000              1.0000000        
Fe    D
      2.1205000              1.0000000        
Fe    D
      0.0321600              1.0000000        
Fe    F
      6.0066000              1.0000000        
Fe    F
      2.2522000              1.0000000        
Fe    F
      0.7758000              1.0000000        
Fe    F
      0.2672300              1.0000000        
Fe    G
      5.5068000              1.0000000        
Fe    G
      2.0515000              1.0000000        
Fe    G
      0.7642600              1.0000000 
''')}


mol.symmetry = 'D2h'
mol.spin = 4	# 2S
mol.charge = 0
#mol.ecp={'Fe':'bfd'}
mol.ecp={'Fe': gto.basis.parse_ecp('''
Fe nelec 10
Fe ul
2 1.000000 0.000000  
Fe s
2 20.930000 253.749588 
2 9.445000  37.922845 
Fe p
2 21.760000 161.036812 
2 9.178000  27.651298 
Fe d
2 25.900000 -24.431276
2 8.835000  -1.434251 

''')}
mol.build()

#~~~Run HF on molecule~~~~
hf = scf.ROHF(mol) #.apply(scf.addons.remove_linear_dep_)
hf.irrep_nelec = {
'Ag' : (4,3),   # s    
'B3u': (1,1),   # x    1
'B1u': (1,1),   # z    0
'B2u': (1,1),   # y   -1
'B1g': (1,0),   # xy  -2
'B3g': (1,0),   # yz  -1
'B2g': (1,0),   # xz   1
'Au' : (0,0)    # xyz  
}
hf.verbose=4
hf.max_cycle=150
hf.level_shift=0.2
#hf.diis_space=8
dm=hf.init_guess_by_chkfile('../guess/Fe.chkfile')
#hf.init_guess='hcore'
hf.chkfile='Fe.chkfile'
#en=hf.kernel()
en=hf.kernel(dm)

###~~~~~~~~ Reorder orbitals ~~~~~~~~~~~~~~

##hf.analyze()
#mo0 = hf.mo_coeff
#occ = hf.mo_occ
#occ[1][5] = 0 
#occ[1][10] = 1
#hf = scf.UHF(mol)
#hf.irrep_nelec = {
#'Ag' : (4,3),   # s    
#'B3u': (1,1),   # x    1
#'B1u': (1,1),   # z    0
#'B2u': (1,1),   # y   -1
#'B1g': (1,0),   # xy  -2
#'B3g': (1,0),   # yz  -1
#'B2g': (1,0),   # xz   1
#'Au' : (0,0)    # xyz  
#}
#dm_u = hf.make_rdm1(mo0, occ)
#hf = scf.addons.mom_occ(hf, mo0, occ)
#hf.scf(dm_u)
##hf.mulliken_pop()
#
#dm1 = hf.make_rdm1()
#mf=scf.ROHF(mol)
#mf.chkfile='Fe.chkfile'
#hf.irrep_nelec = {
#'Ag' : (4,3),   # s    
#'B3u': (1,1),   # x    1
#'B1u': (1,1),   # z    0
#'B2u': (1,1),   # y   -1
#'B1g': (1,0),   # xy  -2
#'B3g': (1,0),   # yz  -1
#'B2g': (1,0),   # xz   1
#'Au' : (0,0)    # xyz  
#}
#mf.kernel(dm1)
#
#mf.mulliken_pop()

hf.mulliken_pop()


kpts=[]
title="Fe"
from PyscfToQmcpack import savetoqmcpack
savetoqmcpack(mol,hf,title=title,kpts=kpts)

