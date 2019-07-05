#! /usr/bin/env python

import sys,os
import numpy as np
import pandas as pd

#workdir = os.path.realpath(os.path.join(__file__,'/home/gani/Desktop/notes/scripts/genbas/basis'))
#basfile = os.path.join(workdir,'bfd_v5z.dat')

#~~~~~~~~~~~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~
N=5     # Number of exp in s and p
atom = "Na"
augmentation=True
#augmentation=False

param0=np.array([
3.071135, #Lowest s exponent
2.071306, #Ratio for s exponents
1.041779, #Lowest p exponent
1.750448, #Ratio for p exponents
2.160573, #Lowest d exponent
1.801064, #Ratio for d exponents
1.651437, #Lowest f exponent
2.066075, #Ratio for f exponents
2.255175, #Lowest g exponent
2.292913, #Ratio for g exponents
3.430022, #Lowest h exponent
2.463031, #Ratio for h exponents
6.099474, #Lowest i exponent
         
2.500000,   #Ratio for i exponents
])










# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if augmentation == True:
	ei=-1
else:
	ei=0

def molpro_bas(param):
	# Calculate the exponents
	sexp=[]
	pexp=[]
	dexp=[]
	fexp=[]
	gexp=[]
	hexp=[]
	iexp=[]
	for i in range(ei,N):    # Second number in for loop is the number of params
	        sexp.append(param[0]*param[1]**i)
	        pexp.append(param[2]*param[3]**i)
	        dexp.append(param[4]*param[5]**i)
	for i in range(ei,N-1):
	        fexp.append(param[6]*param[7]**i)
	for i in range(ei,N-2):
	        gexp.append(param[8]*param[9]**i)
	for i in range(ei,N-3):
	        hexp.append(param[10]*param[11]**i)
	for i in range(ei,N-4):
	        iexp.append(param[12]*param[13]**i)
	
	sexp = ["{0:.7f}".format(x) for x in sexp]
	pexp = ["{0:.7f}".format(x) for x in pexp]
	dexp = ["{0:.7f}".format(x) for x in dexp]
	fexp = ["{0:.7f}".format(x) for x in fexp]
	gexp = ["{0:.7f}".format(x) for x in gexp]
	hexp = ["{0:.7f}".format(x) for x in hexp]
	iexp = ["{0:.7f}".format(x) for x in iexp]

	#os.system("cp contraction.dat basis.dat")
	mybas = open("basis.dat", "w")
	
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
	os.system('sed -i "s/\'//g" basis.dat')
	
	return None


molpro_bas(param0)
