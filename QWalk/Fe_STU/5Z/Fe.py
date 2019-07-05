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
      1.497690E+08           1.000 
Fe    S
      2.672250E+07           1.000 
Fe    S
      5.959000E+06           1.000 
Fe    S
      1.593610E+06           1.000 
Fe    S
      4.934640E+05           1.000 
Fe    S
      1.717900E+05           1.000 
Fe    S
      6.562090E+04           1.000 
Fe    S
      2.696560E+04           1.000 
Fe    S
      1.173530E+04           1.000 
Fe    S
      5.343430E+03           1.000 
Fe    S
      2.522500E+03           1.000 
Fe    S
      1.226430E+03           1.000 
Fe    S
      6.112690E+02           1.000 
Fe    S
      3.113080E+02           1.000 
Fe    S
      1.616240E+02           1.000 
Fe    S
      8.537670E+01           1.000 
Fe    S
      4.579110E+01           1.000 
Fe    S
      2.486770E+01           1.000 
Fe    S
      1.362020E+01           1.000 
Fe    S
      7.481060E+00           1.000 
Fe    S
      4.088170E+00           1.000 
Fe    S
      2.199050E+00           1.000 
Fe    S
      1.148150E+00           1.000 
Fe    S
      5.772650E-01           1.000 
Fe    S
      1.976350E-01           1.000 
Fe    S
      1.089860E-01           1.000 
Fe    S
      5.321600E-02           1.000 
Fe    S
      2.557100E-02           1.0000000        
Fe    S
      6.622400E+00           1.0000000        
Fe    P
      8.694730E+04           1.000 
Fe    P
      2.125400E+04           1.000 
Fe    P
      6.741140E+03           1.000 
Fe    P
      2.557160E+03           1.000 
Fe    P
      1.093510E+03           1.000 
Fe    P
      5.061610E+02           1.000 
Fe    P
      2.471390E+02           1.000 
Fe    P
      1.254150E+02           1.000 
Fe    P
      6.565120E+01           1.000 
Fe    P
      3.530790E+01           1.000 
Fe    P
      1.942600E+01           1.000 
Fe    P
      1.084380E+01           1.000 
Fe    P
      6.043590E+00           1.000 
Fe    P
      3.302450E+00           1.000 
Fe    P
      1.763890E+00           1.000 
Fe    P
      9.213860E-01           1.000 
Fe    P
      4.603730E-01           1.000 
Fe    P
      1.837720E-01           1.000 
Fe    P
      7.583300E-02           1.000 
Fe    P
      3.109900E-02           1.0000000        
Fe    P
      1.001280E+01           1.0000000        
Fe    P
      3.186900E+00           1.0000000        
Fe    D
      5.184160E+02           1.000 
Fe    D
      1.528190E+02           1.000 
Fe    D
      5.858690E+01           1.000 
Fe    D
      2.545640E+01           1.000 
Fe    D
      1.178680E+01           1.000 
Fe    D
      5.718610E+00           1.000 
Fe    D
      2.824170E+00           1.000 
Fe    D
      1.379850E+00           1.000 
Fe    D
      6.561600E-01           1.000 
Fe    D
      2.996090E-01           1.000 
Fe    D
      1.293610E-01           1.000 
Fe    D
      5.115500E-02           1.0000000        
Fe    D
      7.098200E+00           1.0000000        
Fe    D
      4.277200E+00           1.0000000        
Fe    F
      1.104710E+01           1.0000000        
Fe    F
      4.854100E+00           1.0000000        
Fe    F
      2.132900E+00           1.0000000        
Fe    F
      9.372000E-01           1.0000000        
Fe    F
      3.141000E-01           1.0000000        
Fe    G
      7.547500E+00           1.0000000        
Fe    G
      3.673700E+00           1.0000000        
Fe    G
      1.788100E+00           1.0000000        
Fe    G
      6.564000E-01           1.0000000        
''')}

#Fe    H
#      6.926300E+00           1.0000000        
#Fe    H
#      3.252700E+00           1.0000000        
#Fe    H
#      1.296400E+00           1.0000000        
#Fe    I
#      7.056900E+00           1.0000000 



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

