#! /usr/bin/env python

import sys,os
import pandas as pd
from scipy.optimize import curve_fit
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import uncertainties
from uncertainties import ufloat
import string



#~~~~~~~~ Input ~~~~~~~~~~~~
pd.options.display.float_format = '{:,.8f}'.format
#ptable=['B','C','N','O','F']
#ptable=['H','He','B','C','N''O','F']
ptable=["K"]
#ptable=["Sc", "Ti", "V", "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn"]
folders = ['rccsd-t','rcisd','fci']
basis = np.array([2,3,4,5,6])
extrapolation = False
#~~~~~~~~~~~~~~~~~~~~~~~~~~~


class ShorthandFormatter(string.Formatter):
    def format_field(self, value, format_spec):
        if isinstance(value, uncertainties.UFloat):
            return value.format(format_spec+'S')  # Shorthand option added
        # Special formatting for other types can be added here (floats, etc.)
        else:
            # Usual formatting:
            return super(ShorthandFormatter, self).format_field(
                value, format_spec)
frmtr = ShorthandFormatter()

extr = pd.DataFrame(columns=["CBS"], index=folders)


for k in ptable:
	kin = pd.DataFrame(columns=basis, index=folders)
	for i in folders:
		for j in basis:
			#print(j,type(j))
			mypath = os.path.join(k, i, str(j) + ".csv")
			try:
				df = pd.read_csv(mypath, sep='\s*,\s*', engine='python')	# \s*,\s* gets rid of empty spaces in column names
				kin[j].loc[i]=df['EKIN'].iloc[0]
			except:
				if extrapolation == True:
					eta=kin[j-1].loc['fci']/kin[j-1].loc['rcisd']
					kin[j].loc[i]=eta*(kin[j].loc['rcisd'])
				else:
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
	
	kin=pd.concat([kin, extr], axis=1)
	kin_cbs=2*kin[max(basis)].loc[folders[-1]]-kin[max(basis)-1].loc[folders[-1]]
	kin_err=0.5*(kin[max(basis)].loc[folders[-1]]-kin[max(basis)-1].loc[folders[-1]])
	if extrapolation == True:
		kin['CBS'].loc[folders[-1]]=frmtr.format("{0:.1u}", ufloat(kin_cbs,abs(kin_err)))
	
	print(k)	
	kin=kin.rename(index={"rccsd-t":"ROHF","rcisd":"CISD","fci":"FCI"}, columns={2:"DZ", 3:"TZ", 4:"QZ", 5:"5Z", 6:"6Z"})
	print(kin.to_latex(na_rep=""))







