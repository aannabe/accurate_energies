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

#rows=['0.csv','1.csv','2.csv','4.csv','3.csv']
rows=['1.csv','2.csv','4.csv','5.csv','3.csv']

styles = {
'0.csv' :{'label':'H-He[reg]',   'color':'#6600cc', 'fmt':'d', 'linestyle':'--','dashes': (10,10)},
'1.csv' :{'label':'Be-Ne[He]', 'color':'#0099ff', 'fmt':'o', 'linestyle':'--','dashes': (3,1)},
'2.csv' :{'label':'Na-Ar[Ne]', 'color':'#00cc00', 'fmt':'D', 'linestyle':'--','dashes': (6,2)},
'3.csv' :{'label':'K-Zn[Ne]',    'color':'#ff9933', 'fmt':'X', 'linestyle':'--','dashes': (1,1)},
'4.csv' :{'label':'Na-Ar[He]', 'color':'#ff0000', 'fmt':'*', 'linestyle':'--','dashes': (1,1,8,1)},
'5.csv' :{'label':'Ga-Kr[[Ar]3$d^{10}$]', 'color':'#ff00ff', 'fmt':'.', 'linestyle':'-',}
}

pquant='PR'    # PR or KPR

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
#    if type(x) is uncertainties.core.AffineScalarFunc or uncertainties.core.Variable:
#        y = frmtr.format("{0:.1u}", x)
#    else:
#        y = None
#    return y

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
    font = {'family' : 'serif', 'size': 21}
    lines = {'linewidth':2.70}
    axes = {'linewidth': 3}
    tick = {'major.size': 2, 'major.width':2}
    legend = {'frameon':False, 'fontsize':15.5, 'handlelength':2.00, 'labelspacing':0.20, 'handletextpad':0.2}

    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**tick)
    mpl.rc('ytick',**tick)
    mpl.rc('legend',**legend)

    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    fig = plt.figure()
    fig.set_size_inches(8.00, 6.00)   # Default 6.4, 4.8
    ax1 = fig.add_subplot(111)
    return fig,ax1

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fig,ax = init()
ax.set_xlabel('Number of valence electrons')
ax.set_ylabel('Percentage')
ax.set_ylim([0,13])


for row in rows:
    print(row)
    df = pd.read_csv("%s" % row, delim_whitespace=True, index_col=False, engine='python') #sep='\s*&\s*',
    udf = pd.DataFrame(columns=df.columns)
    #print(df)
    udf['Valence'] = df['Valence']
    udf['Atom'] = df['Atom']
    df=df.set_index('Atom')
    #print(list(df['CC']))
    udf['CC'] = list(map(s2f,list(df['CC'])))
    udf['DMC'] = list(map(s2f,list(df['DMC'])))
    udf['Corr'] = list(map(s2f,list(df['Corr'])))
    udf['Kin'] = list(map(s2f,list(df['Kin'])))

    udf['FN'] = udf['DMC']-udf['CC']
    df['FN'] = list(map(f2s, list(udf['FN']*tomha)))
    print(df['FN'])

    udf['PR'] = udf['FN']*(-100.0)/udf['Corr']    # FN as percentage
    df['PR'] = list(map(f2s, list(udf['PR'])))
    print(df['PR'])

    udf['KPR'] = udf['Kin']*(-100.0)/udf['CC']    # Kinetic as percentage
    df['KPR'] = list(map(f2s, list(udf['KPR'])))
    print(df['KPR'])

    # ~~~ Plotting FN ~~~~
    x = list(df['Valence'])
    y = unumpy.nominal_values(list(udf[pquant]))
    ax.set_xticks(x)
    yerr = unumpy.std_devs(list(udf[pquant]))
    plt.errorbar(x,y, yerr=yerr, elinewidth=1.0, **styles[row])


plt.legend(loc='best')
plt.savefig('%s_b.pdf' % pquant)
plt.show()


