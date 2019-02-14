#!/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import uncertainties
from uncertainties import ufloat
from uncertainties import unumpy
from uncertainties import ufloat_fromstr
import string

#~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~~~~~~

rows=['1.csv','2.csv','4.csv','3.csv']

styles = {
'0.csv' :{'label':'H-He[soft]',  'color':'#ff0000', 'fmt':'d', 'linestyle':'--','dashes': (1,1)},
'1.csv' :{'label':'1st[He] row', 'color':'#ff9933', 'fmt':'o', 'linestyle':'--','dashes': (3,1)},
'2.csv' :{'label':'2nd[Ne] row', 'color':'#33cc33', 'fmt':'D', 'linestyle':'--','dashes': (5,2)},
'3.csv' :{'label':'3rd[Ne] row', 'color':'#3399ff', 'fmt':'X', 'linestyle':'--','dashes': (2,2)},
'4.csv' :{'label':'2nd[He] row', 'color':'#9900cc', 'fmt':'*', 'linestyle':'--','dashes': (1,1,4,1)},
}

pquant='PR'	# PR or KPR

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#np.set_printoptions(formatter={'float': '{: 0.2f}'.format})
tomha=1000.0

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

#def f2s(x):
#	if type(x) is uncertainties.core.AffineScalarFunc or uncertainties.core.Variable:
#		y = frmtr.format("{0:.1u}", x)
#	else:
#		y = None
#	return y

def f2s(x):
	try:
		y = frmtr.format("{0:.1u}", x)
	except:
		y = None
	return y


def s2f(x):
	if type(x) is str:
		y = ufloat_fromstr(x)
	else:
		y = None
	return y

def init():
	font = {'family' : 'serif', 'size': 16}
	lines = {'linewidth':3}
	axes = {'linewidth': 3}
	tick = {'major.size': 5, 'major.width':2}
	legend = {'frameon':False, 'fontsize':14}

	mpl.rc('font',**font)
	mpl.rc('lines',**lines)
	mpl.rc('axes',**axes)
	mpl.rc('xtick',**tick)
	mpl.rc('ytick',**tick)
	mpl.rc('legend',**legend)

	mpl.rcParams['text.usetex'] = True
	mpl.rcParams.update({'figure.autolayout':True})
	fig = plt.figure()
	ax1 = fig.add_subplot(111)
	return fig,ax1

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fig,ax = init()
ax.set_xlabel('Valence electrons')
ax.set_ylabel('Percentage')

for row in rows:
	df = pd.read_csv("%s" % row, delim_whitespace=True, index_col=False, engine='python') #sep='\s*&\s*',
	udf = pd.DataFrame(columns=df.columns)
	#print(df)
	udf['Valence'] = df['Valence']
	udf['Atom'] = df['Atom']
	#print(list(df['CC']))
	udf['CC'] = list(map(s2f,list(df['CC'])))
	udf['DMC'] = list(map(s2f,list(df['DMC'])))
	udf['Corr'] = list(map(s2f,list(df['Corr'])))
	udf['Kin'] = list(map(s2f,list(df['Kin'])))
	udf['FN'] = udf['DMC']-udf['CC']
	#print(udf['FN'])
	df['FN'] = list(map(f2s, list(udf['FN']*tomha)))
	print(df['FN'])
	udf['PR'] = udf['FN']*(-100.0)/udf['Corr']	# FN as percentage
	#print(udf['PR'])
	udf['KPR'] = udf['Kin']*(-100.0)/udf['CC']	# Kinetic as percentage
	#print(udf['KPR'])

	# ~~~ Plotting FN ~~~~
	x = list(df['Valence'])
	y = unumpy.nominal_values(list(udf[pquant]))
	ax.set_xticks(x)
	yerr = unumpy.std_devs(list(udf[pquant]))
	plt.errorbar(x,y, yerr=yerr, elinewidth=1.0, **styles[row])


plt.legend(loc='best')
plt.savefig('%s.pdf' % pquant)
plt.show()

