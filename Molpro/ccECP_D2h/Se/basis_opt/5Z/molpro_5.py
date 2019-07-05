#! /usr/bin/env python

import sys,os
import numpy as np
import pandas as pd

#workdir = os.path.realpath(os.path.join(__file__,'/home/gani/Desktop/notes/scripts/genbas/basis'))
#basfile = os.path.join(workdir,'bfd_v5z.dat')

#~~~~~~~~~~~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~
N=4     # Number of exp in s and p
atom = "Se"

param0=np.array([

0.100352,
1.885735,
0.069810,
2.380168,
0.159107,
2.132982,
0.221791,
2.016201,
0.399571,
2.237484,
0.742989,


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

	sexp.sort(reverse=True)
	pexp.sort(reverse=True)
	dexp.sort(reverse=True)
	fexp.sort(reverse=True)
	gexp.sort(reverse=True)
	hexp.sort(reverse=True)
	
	sexp = ["{0:.7f}".format(x) for x in sexp]
	pexp = ["{0:.7f}".format(x) for x in pexp]
	dexp = ["{0:.7f}".format(x) for x in dexp]
	fexp = ["{0:.7f}".format(x) for x in fexp]
	gexp = ["{0:.7f}".format(x) for x in gexp]
	hexp = ["{0:.7f}".format(x) for x in hexp]

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
	sexp.append(param[0]/2.5)
	pexp.append(param[2]/2.5)
	dexp.append(param[4]/2.5)
	fexp.append(param[6]/2.5)
	gexp.append(param[8]/2.5)
	hexp.append(param[10]/2.5)

	sexp.sort(reverse=True)
	pexp.sort(reverse=True)
	dexp.sort(reverse=True)
	fexp.sort(reverse=True)
	gexp.sort(reverse=True)
	hexp.sort(reverse=True)
	
	sexp = ["{0:.7f}".format(x) for x in sexp]
	pexp = ["{0:.7f}".format(x) for x in pexp]
	dexp = ["{0:.7f}".format(x) for x in dexp]
	fexp = ["{0:.7f}".format(x) for x in fexp]
	gexp = ["{0:.7f}".format(x) for x in gexp]
	hexp = ["{0:.7f}".format(x) for x in hexp]

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


	mybas.close()

	return None

molpro_aug(param0)
os.system('echo "aug-cc-pVnZ:"')
os.system('cat basis.dat')


