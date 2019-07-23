#! /usr/bin/env python

import sys,os
from pyscf import scf,gto,lib,mcscf,fci
import pyscf.lib.chkfile
import numpy as np
import pyscf2qwalk as qw

workdir = os.path.dirname(os.path.realpath(__file__))
basfile = os.path.join(workdir,'my_basis')
#ecpfile = os.path.join(workdir,'my_ecp')

#~~~~Build the molecule~~~~
mol = gto.Mole()
mol.atom = '''Ni 0.0 0.0 0.0 '''
mol.basis = {'Ni': gto.load(basfile,'Ni')}
#mol.basis = {'O':'bfd-vtz'}
#mol.basis = {'O': gto.basis.parse('''
#''')}
mol.symmetry = 'D2h'
#mol.symmetry = True
mol.spin = 2	# 2S
mol.charge = 0
#mol.ecp = {'Ni': gto.load(ecpfile,'Ni')}
#mol.ecp={'O':'bfd'}
mol.ecp={'Ni': gto.basis.parse_ecp('''
Ni nelec 10
Ni ul
1 2.82630001015327e+01 18.000
3 2.69360254587070e+01 508.7340018275886
2 2.70860075292970e+01 -2.20099999296390e+02
2 1.22130001295874e+01 -2.13493270999809e+00
Ni S
2 2.64320193944270e+01 3.21240002430625e+02
2 1.17489696842121e+01 6.03470084610628e+01
Ni P
2 2.94929998193907e+01 2.36539998999428e+02
2 1.15569831458722e+01 4.43969887908906e+01
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
'B3g': (1,1),   # yz  -1
'B2g': (1,1),   # xz   1
'Au' : (0,0)    # xyz  
}
hf.verbose=4
hf.max_cycle=100
#hf.chkfile='Ni.chkfile'
dm=hf.init_guess_by_chkfile('/home/gani/repos/scripts/pp_totals/qwalk/pyscf_tm/Ni_4s/DZ/Ni.chkfile')
en=hf.kernel(dm)
#en=hf.kernel()
hf.mulliken_pop()
hf.analyze()

#####~~~ Run CASSCF ~~~

weights = np.ones(5)/5
print(weights)

solver1 = fci.direct_spin1_symm.FCI(mol)
solver1.wfnsym= 'Ag'
solver1.spin = 2
solver1.nroots = 2

solver2 = fci.direct_spin1_symm.FCI(mol)
solver2.wfnsym= 'B1g'
solver2.spin = 2
solver2.nroots = 1

solver3 = fci.direct_spin1_symm.FCI(mol)
solver3.wfnsym= 'B2g'
solver3.spin = 2
solver3.nroots = 1

solver4 = fci.direct_spin1_symm.FCI(mol)
solver4.wfnsym= 'B3g'
solver4.spin = 2
solver4.nroots = 1

mc = mcscf.CASSCF(hf, 6, (6,4))
cas_list = [5,6,7,8,9,10] # pick orbitals for CAS space, 1-based indices
mo = mcscf.sort_mo(mc, hf.mo_coeff, cas_list)
mc = mcscf.state_average_mix_(mc, [solver1, solver2, solver3, solver4], weights)
mc.ncore=4

##mc.chkfile='Ni.chkfile'
mc.fcisolver.max_stepsize = 0.01 # Default 0.03
mc.fcisolver.spin = 2
mc.fix_spin_(ss=2)

mc.kernel(mo)[0]
mc.verbose = 4
#print(mc.ncore)
#mc.analyze()
#print(mc.e_tot)

##Extra CASCI for ground state energy because the state_averaged CASSCF
##computes the state-averaged total energy instead of the ground state energy.

mo = mc.mo_coeff
mc = mcscf.CASCI(hf, 6, (6,4))
emc = mc.casci(mo)[0]

mc.verbose = 5
mc.analyze()
print('CI coefficients: \n',mc.ci)   # CI coefficients
#print('MO coefficients: \n', mc.mo_coeff)

####~~~ Conversion ~~~~
#
##kpts=[]
##title="Ni"
##from PyscfToQmcpack import savetoqmcpack
##savetoqmcpack(mol,hf,title=title,kpts=kpts)
#
#### ~~~~ Following QWalk converter can't convert basis with H or greater functions!
qw.print_qwalk(mol,mc,method='mcscf',tol=0.00001,basename='qwalk')


