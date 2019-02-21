#!/usr/bin/env python3

import numpy as np

# Sulfur
a=np.array([-0.12139641,-0.16100792,-0.17196728,-0.17540478,-0.17668674,])
b=np.array([-0.12200559,-0.16200899,-0.17299950,-0.17637533,-0.17761235,])
ab=np.divide(b,a)
print(ab.mean())
print(ab.std())

# Chlorine
c=np.array([-0.15102002,-0.20742042,-0.22573339,-0.23142436,])
d=np.array([-0.15158951,-0.20834100,-0.22672192,-0.23236924,])
cd=np.divide(d,c)
print(cd.mean())
print(cd.std())


# Oxygen
e=np.array([-0.13066436,-0.17593833,-0.18887222,-0.19301145,-0.19493374,])
f=np.array([-0.13097924,-0.17636278,-0.18928076,-0.19339178,-0.19529685,])
ef=np.divide(f,e)
print(ef)
print(ef.mean())
print(ef.std())














