#! /usr/bin/env python

import sys,os
import pandas as pd
from scipy.optimize import curve_fit
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt


#~~~~~~~~ Input ~~~~~~~~~~~~
pd.options.display.float_format = '{:,.8f}'.format
folders = ['rccsd-t','rcisd','fci']
basis = np.array([2,3,4,5,6])
#~~~~~~~~~~~~~~~~~~~~~~~~~~~

kin = pd.DataFrame(columns=basis, index=folders)

for i in folders:
	for j in basis:
		mypath = os.path.join(i, str(j) + ".csv")
		try:
			df = pd.read_csv(mypath, sep='\s*,\s*', engine='python')	# \s*,\s* gets rid of empty spaces in column names
			kin[j].loc[i]=df['EKIN'].iloc[0]
		except:
			kin[j].loc[i]=np.nan
	

#x=np.linspace(basis[0],basis[-1],50)
#fig, ax = plt.subplots()
#plt.plot(basis, kin.loc['rccsd-t'], '*--')
#plt.plot(basis, kin.loc['rcisd'], 'o--')
#plt.plot(basis, kin.loc['fci'], 'x--')
#ax.set(title='Kinetic Energies',
#xlabel='Cardinal n',
#ylabel='E(hartree)')
#legend = ax.legend(loc='best', shadow=False)
##plt.savefig('extrap.png', format='png', dpi=100)
#plt.show()

kin=kin.rename(index={"rccsd-t":"HF","rcisd":"CISD","fci":"FCI"}, columns={2:"DZ", 3:"TZ", 4:"QZ", 5:"5Z", 6:"6Z"})

print kin.to_latex(na_rep="")



