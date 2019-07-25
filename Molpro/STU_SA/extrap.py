#! /usr/bin/env python

import sys,os
import pandas as pd
from scipy.optimize import curve_fit
#import glob
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import uncertainties
from uncertainties import ufloat
import string


#~~~~~~~~ Input ~~~~~~~~~~~~
pd.options.display.float_format = '{:,.8f}'.format
folders = ['rcisd', 'rccsd-t', 'uccsd-t']
basis = np.array([3,4,5])
card1=3		# First cardinal to use in extrapolation
card2=6		# Second cardinal to use in extrapolation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~

def scf_cbs(n, e_cbs, c, d):	#SCF
        y=e_cbs+c*np.exp(-d*n)
        return y

def corr_cbs(n, e_cbs, c, d):	#Correlation
        y=e_cbs+c/(n+3.0/8.0)**3.0+d/(n+3.0/8.0)**5.0
        return y

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





scf = pd.DataFrame(columns=basis, index=folders)
corr = pd.DataFrame(columns=basis, index=folders)
extr = pd.DataFrame(columns=["CBS"], index=folders)

for i in folders:
	for j in basis:
		mypath = os.path.join(i, str(j) + ".csv")
		try:
			df = pd.read_csv(mypath, sep='\s*,\s*', engine='python')	# \s*,\s* gets rid of empty spaces in column names
			scf[j].loc[i]=df['SCF'].iloc[0]
			corr[j].loc[i]=df['POSTHF'].iloc[0] - df['SCF'].iloc[0]
		except:
			scf[j].loc[i]=np.nan
			corr[j].loc[i]=np.nan
	
	corr_x = corr.loc[:, card1:card2]
	try:
		print "Method:",i
		ydata = list(corr_x.loc[i].values)
		ydata = np.array(ydata,dtype='float64')
		xdata = list(corr_x.columns)
		print xdata,ydata
		
		initial=[ydata[-1], 1.0, 1.0]
		limit=( [ydata[-1]*3, -np.inf, -np.inf], [ydata[-1], np.inf, np.inf] )
		popt_corr, pcov_corr = curve_fit(corr_cbs, xdata, ydata, p0=initial) #, bounds=limit)
		print "Fit params:", popt_corr, np.sqrt(np.diag(pcov_corr)), "\n"
		my_cbs=ufloat(popt_corr[0], np.sqrt(np.diag(pcov_corr))[0] )
		extr['CBS'].loc[i]=frmtr.format("{0:.2u}", my_cbs)

		x=np.linspace(xdata[0],xdata[-1],50)
		fig, ax = plt.subplots()
		plt.plot(xdata, ydata, 'o')
		plt.plot(x, corr_cbs(x, *popt_corr), '--', lw=1, label="Fitted Function")
		plt.axhline(y=popt_corr[0], ls='dashed', lw=1, color='red', label='CBS limit')
		ax.set(title=' %s Extrapolation Fit' % i,
		xlabel='Cardinal n',
		ylabel='E(hartree)')
		legend = ax.legend(loc='best', shadow=False)
		#plt.savefig('extrap.png', format='png', dpi=100)
		plt.show()

	except:
		print "Unexpected error at %s:" % i, sys.exc_info()[0]
		#raise

#~~~~~~~~~~~SCF~~~~~~~~~~~~~~~~~~~~~~~~~
scf_x = scf.loc[:, card1:card2]
ydata = list(scf_x.iloc[0].values)
ydata = np.array(ydata,dtype='float64')
xdata = list(scf_x.columns)

initial=[min(ydata), 0.2, 1.0]
limit=( [min(ydata)*1.1, -np.inf, 0.0], [min(ydata), np.inf, np.inf] )
popt_scf, pcov_scf = curve_fit(scf_cbs, xdata, ydata, p0=initial, bounds=limit)
print "SCF", popt_scf, np.sqrt(np.diag(pcov_scf))
my_scf=ufloat(popt_scf[0], np.sqrt(np.diag(pcov_scf))[0] )
scf['CBS']=frmtr.format("{0:.2u}", my_scf)

x=np.linspace(xdata[0],xdata[-1],50)
fig, ax = plt.subplots()
plt.plot(xdata, ydata, 'o')
plt.plot(x, scf_cbs(x, *popt_scf), '--', lw=1, label="Fitted Function")
plt.axhline(y=popt_scf[0], ls='dashed', lw=1, color='red', label='CBS limit')
ax.set(title='SCF Extrapolation Fit',
xlabel='Cardinal n',
ylabel='E(hartree)')
legend = ax.legend(loc='best', shadow=False)
#plt.savefig('extrap_scf.png', format='png', dpi=100)
plt.show()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#print scf.to_latex(na_rep="")
#print corr.to_latex(na_rep="")

scf = scf.iloc[[0]]
scf = scf.rename(index={"rcisd":"SCF"})

corr=pd.concat([corr, extr], axis=1)
corr=pd.concat([corr, scf], axis=0)

scf=scf.rename(index={"rcisd":"CISD","rccsd-t":"RCCSD(T)","uccsd-t":"UCCSD(T)", "ccsdt-q":"CCSDT(Q)", "fci":"FCI"}, columns={2:"DZ", 3:"TZ", 4:"QZ", 5:"5Z", 6:"6Z"})
corr=corr.rename(index={"rcisd":"CISD","rccsd-t":"RCCSD(T)","uccsd-t":"UCCSD(T)", "ccsdt-q":"CCSDT(Q)", "fci":"FCI" }, columns={2:"DZ", 3:"TZ", 4:"QZ", 5:"5Z", 6:"6Z"})

#scf=scf.transpose()
#corr=corr.transpose()

print corr.to_latex(na_rep="")



