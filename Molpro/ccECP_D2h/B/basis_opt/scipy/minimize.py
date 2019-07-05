#! /usr/bin/env python

import sys,os
from scipy.optimize import minimize
import numpy as np
import pandas as pd

#workdir = os.path.realpath(os.path.join(__file__,'/home/gani/Desktop/notes/scripts/genbas/basis'))
#basfile = os.path.join(workdir,'bfd_v5z.dat')

#~~~ Input ~~~~
N=5     # Number of exp in s and p
atom = "B"
# ~~~~~~~~~~~~

param0=np.array([
0.07,   #Lowest s exponent
2.50,   #Ratio for s exponents
0.05,   #Lowest p exponent
2.50,   #Ratio for p exponents
0.12,   #Lowest d exponent
2.50,   #Ratio for d exponents
0.25,   #Lowest f exponent
2.5,    #Ratio for f exponents
0.45,   #Lowest g exponent
2.5,    #Ratio for g exponents
0.5,    #Lowest h exponent
2.5,    #Ratio for h exponents
0.90,   #Lowest i exponent
])

def molpro_bas(param):
	# Calculate the exponents
	sexp=[]
	pexp=[]
	dexp=[]
	fexp=[]
	gexp=[]
	hexp=[]
	iexp=[]
	for i in range(0,N):    # Second number in for loop is the number of params
	        sexp.append(param[0]*param[1]**i)
	        pexp.append(param[2]*param[3]**i)
	        dexp.append(param[4]*param[5]**i)
	for i in range(0,N-1):
	        fexp.append(param[6]*param[7]**i)
	for i in range(0,N-2):
	        gexp.append(param[8]*param[9]**i)
	for i in range(0,N-3):
	        hexp.append(param[10]*param[11]**i)
	iexp.append(param[12])
	
	os.system("cp ../contraction.dat basis.dat")
	mybas = open("basis.dat", "a")
	
	mybas.write("s,%s," % atom)
	mybas.write(str(sexp))
	mybas.write("; \n")
	mybas.write("p,%s," % atom)
	mybas.write(str(pexp))
	mybas.write("; \n")
	mybas.write("d,%s," % atom)
	mybas.write(str(dexp))
	mybas.write("; \n")
	mybas.write("f,%s," % atom)
	mybas.write(str(fexp))
	mybas.write("; \n")
	mybas.write("g,%s," % atom)
	mybas.write(str(gexp))
	mybas.write("; \n")
	mybas.write("h,%s," % atom)
	mybas.write(str(hexp))
	mybas.write("; \n")
	mybas.write("i,%s," % atom)
	mybas.write(str(iexp))
	mybas.write("; \n")
	
	mybas.close()
	os.system("sed -i 's/\[//g' basis.dat")
	os.system("sed -i 's/\]//g' basis.dat")
	
	return None


def energy(param):
	molpro_bas(param)
	os.system("molpro -s -n 2 atom.inp")
	df = pd.read_csv("atom.csv", sep=',', engine='python')
	print "At param :", param , df['CISD'][0]
	return df['CISD'][0]

energy(param0)


#~~~~ Find the next move ~~~~

x0=list(param0)
#print x0

step = [1e-1,1e-2,1e-3,1e-4,1e-5,1e-6]
for  e in step:
	if e == step[-1]:
		maxiter =5
	else:
		maxiter=2
	res = minimize(energy, x0, method='L-BFGS-B',
	                options={
			'disp': True, 
			'maxiter' : maxiter,
			'eps': e,
			})
	x0=list(res.x)


print res


#~~~~~Calculate the exponents~~~~~~~~~~~

molpro_bas(np.array(res.x))




