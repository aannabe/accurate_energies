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
mol.atom = '''C 0.0 0.0 0.0 '''
mol.basis = {'C': gto.load(basfile,'C')}
#mol.basis = {'O':'bfd-vtz'}
#mol.basis = {'O': gto.basis.parse('''
#''')}
mol.symmetry = 'D2h'
mol.spin = 2	# 2S
mol.charge = 0
#mol.ecp = {'C': gto.load(ecpfile,'C')}
#mol.ecp={'O':'bfd'}
mol.ecp={'C': gto.basis.parse_ecp('''
C nelec 2
C ul
1 14.43502 4.00000
3 8.39889 57.74008
2 7.38188 -25.81955
C S
2 7.76079 52.13345
''')}
mol.build()

#~~~Run HF on molecule~~~~
hf = scf.ROHF(mol) #.apply(scf.addons.remove_linear_dep_)
hf.irrep_nelec = {
'Ag' : (1,1),   # s    
'B3u': (1,0),   # x    1
'B2u': (0,0),   # y   -1
'B1g': (0,0),   # xy  -2
'B1u': (1,0),   # z    0
'B2g': (0,0),   # xz   1
'B3g': (0,0),   # yz  -1
'Au' : (0,0)    # xyz  
}
hf.verbose=4
hf.max_cycle=150
#dm=hf.init_guess_by_chkfile('../guess/O.chkfile')
#hf.chkfile='C.chkfile'
#en=hf.kernel(dm)
en=hf.kernel()
#hf.mulliken_pop()

###~~~ Run CASSCF ~~~
mc = mcscf.CASSCF(hf, 4, 4)
#mc.kernel()[0]
#mc.verbose = 4
#mc.analyze()

cas_list = [1,2,3,4] # pick orbitals for CAS space, 1-based indices
mo = mcscf.sort_mo(mc, hf.mo_coeff, cas_list)
#mc.chkfile='C.chkfile'
mc.kernel(mo)[0]
mc.verbose = 4
mc.analyze()

#kpts=[]
#title="C"
#from PyscfToQmcpack import savetoqmcpack
#savetoqmcpack(mol,mc,title=title,kpts=kpts)

### ~~~~ Following QWalk converter can't convert basis with H or greater functions!
qw.print_qwalk(mol,mc,method='mcscf',tol=0.00001,basename='qwalk')


