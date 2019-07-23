import numpy as np
from scipy.optimize import curve_fit
import pandas as pd
import matplotlib.pyplot as plt



###########Here are the constants needed##########


def linear_fit(x,a,b):
	return a*x + b

import subprocess
COMMAND = '''echo 'dmc,   error' > extrap.dat; \
gosling c.dmc.log|grep total_energy|awk 'NR>2{print $2 ", " $4}' >> extrap.dat'''
subprocess.call(COMMAND, shell=True)

#os.system("echo 'dmc,   error' > extrap.dat; \
#gosling c.dmc.log|grep total_energy|awk 'NR>2{print $2, $4}' >> extrap.dat")

df=pd.DataFrame()

x = pd.read_csv('./extrap.dat')
df['DMC'] = x.iloc[:,0]
df['Error'] = x.iloc[:,1]

n=[0.02,0.01,0.0075,0.005]
dmcdata=df['DMC'].values
errorbar=df['Error'].values
#limit=([-100,0],[dmcdata[-1],10])
popt, pcov = curve_fit(linear_fit, n, dmcdata, sigma=errorbar)#, bounds=limit)

print(popt)
print(pcov)

#print(df['DMC'])
#print(df.to_latex(index=False))
#print(df['error'])
