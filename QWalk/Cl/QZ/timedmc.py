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


def time_linear(t, a, b):
        y = a+b*t
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

df = pd.read_csv('timedmc.csv', sep=' ', engine='python')
#df = pd.read_csv('qmc.csv', sep=',', engine='python')
print(df)

xdata=df['Timestep'].values
print(xdata)
ydata=df['DMC'].values
print(ydata)
yerr=df['STD'].values
print(yerr)


initial=[max(ydata), 0.0]
popt, pcov = curve_fit(time_linear, xdata, ydata, sigma=yerr, p0=initial)
print "Fit params:", popt, np.sqrt(np.diag(pcov))
a=ufloat(popt[0], np.sqrt(np.diag(pcov))[0])
A=frmtr.format("{0:.1u}", a)
print(A)


###~~~~~~~~Plot~~~~~~~~~~~~~~~~~
x=np.linspace(0.0,xdata[0],50)
y=time_linear(x, *popt)
#print(x)
#print(y)
#print(yerr)

fig, ax = plt.subplots()
ax.errorbar(xdata, ydata, yerr=yerr, fmt='o')
plt.plot(x, y, '--', lw=1, label="Fitted Function")
ax.set(title='Timestep Extrapolation',
xlabel='Timestep',
ylabel='DMC (hartree)')
legend = ax.legend(loc='best', shadow=False)
plt.savefig('extrap.png', format='png', dpi=100)
plt.show()



