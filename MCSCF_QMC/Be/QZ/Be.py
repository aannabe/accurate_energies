#! /usr/bin/env python

import sys,os
from pyscf import scf,gto,lib,mcscf,fci,symm,lo
import pyscf.lib.chkfile
import numpy as np
import pyscf2qwalk as qw

workdir = os.path.dirname(os.path.realpath(__file__))
basfile = os.path.join(workdir,'my_basis')
#ecpfile = os.path.join(workdir,'my_ecp')

#~~~~Build the molecule~~~~
mol = gto.Mole()
mol.atom = '''Be 0.0 0.0 0.0 '''
mol.basis = {'Be': gto.load(basfile,'Be')}
#mol.basis = {'O':'bfd-vtz'}
#mol.basis = {'O': gto.basis.parse('''
#''')}
mol.symmetry = 'D2h'
mol.spin = 0	# 2S
mol.charge = 0
#mol.ecp = {'B': gto.load(ecpfile,'B')}
#mol.ecp={'O':'bfd'}
mol.ecp={'Be': gto.basis.parse_ecp('''
Be nelec 2
Be ul
1 17.94900205362972 2
3 24.13200289331664 35.89800410725944
2 20.13800265282147 -12.77499846818315
2 4.333170937885760 -2.96001382478467
Be s
2 2.487403700772570 12.66391859014478
''')}
mol.build()

#~~~Run HF on molecule~~~~
hf = scf.ROHF(mol) #.apply(scf.addons.remove_linear_dep_)
hf.irrep_nelec = {
'Ag' : (1,1),   # s    
'B3u': (0,0),   # x    1
'B2u': (0,0),   # y   -1
'B1g': (0,0),   # xy  -2
'B1u': (0,0),   # z    0
'B2g': (0,0),   # xz   1
'B3g': (0,0),   # yz  -1
'Au' : (0,0)    # xyz  
}
hf.verbose=3
hf.max_cycle=150
#dm=hf.init_guess_by_chkfile('../guess/O.chkfile')
#hf.chkfile='Be.chkfile'
#en=hf.kernel(dm)
en=hf.kernel()
#hf.mulliken_pop()

###~~~ Run CASCI ~~~
#mc = mcscf.CASCI(hf, 4, 2)
#mc.kernel()[0]

###~~~ Run CASSCF ~~~
mc = mcscf.CASSCF(hf, 4, 2)
#mc.kernel()[0]

#mc.verbose = 4
#mc.analyze()

cas_list = [1,3,4,5] # pick orbitals for CAS space, 1-based indices
mo = mcscf.sort_mo(mc, hf.mo_coeff, cas_list)
#mc.chkfile='Be.chkfile'
mc.kernel(mo)[0]

mc.verbose = 4
mc.analyze()

#kpts=[]
#title="Be"
#from PyscfToQmcpack import savetoqmcpack
#savetoqmcpack(mol,hf,title=title,kpts=kpts)

### ~~~~ Following QWalk converter can't convert basis with H or greater functions!
qw.print_qwalk(mol,mc,method='mcscf',tol=0.00001,basename='qwalk')


