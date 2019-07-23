#! /usr/bin/env python

import sys,os
from pyscf import scf,gto,lib,mcscf
import pyscf.lib.chkfile
import numpy as np
import pyscf2qwalk as qw


workdir = os.path.dirname(os.path.realpath(__file__))
basfile = os.path.join(workdir,'my_basis')
#ecpfile = os.path.join(workdir,'my_ecp')

#~~~~Build the molecule~~~~
mol = gto.Mole()
mol.atom = '''B 0.0 0.0 0.0 '''
mol.basis = {'B': gto.load(basfile,'B')}
#mol.basis = {'O':'bfd-vtz'}
#mol.basis = {'O': gto.basis.parse('''
#''')}
mol.symmetry = 'D2h'
mol.spin = 1	# 2S
mol.charge = 0
#mol.ecp = {'B': gto.load(ecpfile,'B')}
#mol.ecp={'O':'bfd'}
mol.ecp={'B': gto.basis.parse_ecp('''
B nelec 2
B ul
1 31.49298 3.00000
3 22.56509 94.47895
2 8.64669 -9.74800
B S
2 4.06246 20.74800
''')}
mol.build()

#~~~Run HF on molecule~~~~
hf = scf.ROHF(mol) #.apply(scf.addons.remove_linear_dep_)
hf.irrep_nelec = {
'Ag' : (1,1),   # s    
'B3u': (1,0),   # x    1
'B2u': (0,0),   # y   -1
'B1g': (0,0),   # xy  -2
'B1u': (0,0),   # z    0
'B2g': (0,0),   # xz   1
'B3g': (0,0),   # yz  -1
'Au' : (0,0)    # xyz  
}
hf.verbose=4
hf.max_cycle=150
#dm=hf.init_guess_by_chkfile('../guess/O.chkfile')
#hf.chkfile='B.chkfile'
#en=hf.kernel(dm)
en=hf.kernel()
#hf.mulliken_pop()

###~~~ Run CASSCF ~~~
mc = mcscf.CASSCF(hf, 4, 3)
#mc.kernel()[0]
#mc.verbose = 4
#mc.analyze()

cas_list = [1,2,3,4] # pick orbitals for CAS space, 1-based indices
mo = mcscf.sort_mo(mc, hf.mo_coeff, cas_list)
#mc.chkfile='B.chkfile'
mc.kernel(mo)[0]
mc.verbose = 4
mc.analyze()

#kpts=[]
#title="B"
#from PyscfToQmcpack import savetoqmcpack
#savetoqmcpack(mol,mc,title=title,kpts=kpts)

### ~~~~ Following QWalk converter can't convert basis with H or greater functions!
qw.print_qwalk(mol,mc,method='mcscf',tol=0.00001,basename='qwalk')


