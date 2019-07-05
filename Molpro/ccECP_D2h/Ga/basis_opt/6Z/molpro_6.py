#! /usr/bin/env python

import sys,os
import numpy as np
import pandas as pd

#workdir = os.path.realpath(os.path.join(__file__,'/home/gani/Desktop/notes/scripts/genbas/basis'))
#basfile = os.path.join(workdir,'bfd_v5z.dat')

#~~~~~~~~~~~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~
N=5     # Number of exp in s and p
atom = "Ga"

param0=np.array([

0.050955,
2.207360,
0.029776,
2.267292,
0.065406,
2.024741,
0.123140,
1.803155,
0.232074,
1.745963,
0.366953,
1.781759,
0.651434,

1.000000,

])


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


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
	for i in range(0,N-4):
	        iexp.append(param[12]*param[13]**i)

	sexp.sort(reverse=True)
	pexp.sort(reverse=True)
	dexp.sort(reverse=True)
	fexp.sort(reverse=True)
	gexp.sort(reverse=True)
	hexp.sort(reverse=True)
	iexp.sort(reverse=True)
	
	sexp = ["{0:.7f}".format(x) for x in sexp]
	pexp = ["{0:.7f}".format(x) for x in pexp]
	dexp = ["{0:.7f}".format(x) for x in dexp]
	fexp = ["{0:.7f}".format(x) for x in fexp]
	gexp = ["{0:.7f}".format(x) for x in gexp]
	hexp = ["{0:.7f}".format(x) for x in hexp]
	iexp = ["{0:.7f}".format(x) for x in iexp]

	#os.system("cp contraction.dat basis.dat")
	mybas = open("basis.dat", "w")
	
	for i in range(0,len(sexp)):
		mybas.write("s,%s, " % atom)
		mybas.write(str(sexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(pexp)):
		mybas.write("p,%s, " % atom)
		mybas.write(str(pexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(dexp)):
		mybas.write("d,%s, " % atom)
		mybas.write(str(dexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")
	
	for i in range(0,len(fexp)):
		mybas.write("f,%s, " % atom)
		mybas.write(str(fexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(gexp)):
		mybas.write("g,%s, " % atom)
		mybas.write(str(gexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(hexp)):
		mybas.write("h,%s, " % atom)
		mybas.write(str(hexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(iexp)):
		mybas.write("i,%s, " % atom)
		mybas.write(str(iexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	mybas.close()

	return None

molpro_bas(param0)
os.system('echo "cc-pVnZ:"')
os.system('cat basis.dat')


def molpro_aug(param):
	# Calculate the exponents
	sexp=[]
	pexp=[]
	dexp=[]
	fexp=[]
	gexp=[]
	hexp=[]
	iexp=[]
	sexp.append(param[0]/2.5)
	pexp.append(param[2]/2.5)
	dexp.append(param[4]/2.5)
	fexp.append(param[6]/2.5)
	gexp.append(param[8]/2.5)
	hexp.append(param[10]/2.5)
	iexp.append(param[12]/2.5)

	sexp.sort(reverse=True)
	pexp.sort(reverse=True)
	dexp.sort(reverse=True)
	fexp.sort(reverse=True)
	gexp.sort(reverse=True)
	hexp.sort(reverse=True)
	iexp.sort(reverse=True)
	
	sexp = ["{0:.7f}".format(x) for x in sexp]
	pexp = ["{0:.7f}".format(x) for x in pexp]
	dexp = ["{0:.7f}".format(x) for x in dexp]
	fexp = ["{0:.7f}".format(x) for x in fexp]
	gexp = ["{0:.7f}".format(x) for x in gexp]
	hexp = ["{0:.7f}".format(x) for x in hexp]
	iexp = ["{0:.7f}".format(x) for x in iexp]

	#os.system("cp contraction.dat basis.dat")
	mybas = open("basis.dat", "w")
	
	for i in range(0,len(sexp)):
		mybas.write("s,%s, " % atom)
		mybas.write(str(sexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(pexp)):
		mybas.write("p,%s, " % atom)
		mybas.write(str(pexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(dexp)):
		mybas.write("d,%s, " % atom)
		mybas.write(str(dexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")
	
	for i in range(0,len(fexp)):
		mybas.write("f,%s, " % atom)
		mybas.write(str(fexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(gexp)):
		mybas.write("g,%s, " % atom)
		mybas.write(str(gexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(hexp)):
		mybas.write("h,%s, " % atom)
		mybas.write(str(hexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	for i in range(0,len(iexp)):
		mybas.write("i,%s, " % atom)
		mybas.write(str(iexp[i]))
		mybas.write(" \n")
	mybas.write(" \n")

	mybas.close()

	return None

molpro_aug(param0)
os.system('echo "aug-cc-pVnZ:"')
os.system('cat basis.dat')


