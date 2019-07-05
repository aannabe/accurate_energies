#! /usr/bin/env python

import sys,os
import numpy as np
import pandas as pd

#workdir = os.path.realpath(os.path.join(__file__,'/home/gani/Desktop/notes/scripts/genbas/basis'))
#basfile = os.path.join(workdir,'bfd_v5z.dat')

#~~~~~~~~~~~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~
N=5     # Number of exp in s and p
atom = "S"
#augmentation=True
augmentation=False

param0=np.array([
 3.008715, #Lowest s exponent
 1.953592, #Ratio for s exponents
 5.177511, #Lowest p exponent
 1.932260, #Ratio for p exponents
 5.964940, #Lowest d exponent
 1.745602, #Ratio for d exponents
 5.558514, #Lowest f exponent
 1.980099, #Ratio for f exponents
 5.674552, #Lowest g exponent
 2.239052, #Ratio for g exponents
10.866625, #Lowest h exponent
 2.330474, #Ratio for h exponents
18.196038, #Lowest i exponent
         
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
