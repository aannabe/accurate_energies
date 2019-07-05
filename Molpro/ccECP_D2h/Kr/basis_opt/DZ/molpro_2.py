#! /usr/bin/env python

import sys,os
import numpy as np
import pandas as pd

#workdir = os.path.realpath(os.path.join(__file__,'/home/gani/Desktop/notes/scripts/genbas/basis'))
#basfile = os.path.join(workdir,'bfd_v5z.dat')

#~~~~~~~~~~~~~~~~~~~~~~ Input ~~~~~~~~~~~~~~~~~~
N=1     # Number of exp in s and p
atom = "Kr"

param0=np.array([

0.658059,
2.500000,
0.155190,
2.500000,
0.502317,
2.500000,


])


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def molpro_bas(param):
	# Calculate the exponents
	sexp=[]
	pexp=[]
	dexp=[]
	for i in range(0,N):    # Second number in for loop is the number of params
	        sexp.append(param[0]*param[1]**i)
	        pexp.append(param[2]*param[3]**i)
	        dexp.append(param[4]*param[5]**i)

	sexp.sort(reverse=True)
	pexp.sort(reverse=True)
	dexp.sort(reverse=True)
	
	sexp = ["{0:.7f}".format(x) for x in sexp]
	pexp = ["{0:.7f}".format(x) for x in pexp]
	dexp = ["{0:.7f}".format(x) for x in dexp]

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
        sexp.append(param[0]/2.5)
        pexp.append(param[2]/2.5)
        dexp.append(param[4]/2.5)

        sexp.sort(reverse=True)
        pexp.sort(reverse=True)
        dexp.sort(reverse=True)

        sexp = ["{0:.7f}".format(x) for x in sexp]
        pexp = ["{0:.7f}".format(x) for x in pexp]
        dexp = ["{0:.7f}".format(x) for x in dexp]

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

        mybas.close()

        return None

molpro_aug(param0)
os.system('echo "aug-cc-pVnZ:"')
os.system('cat basis.dat')


