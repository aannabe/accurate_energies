#!/usr/bin/env python3

import sys, os
import numpy as np
import pandas as pd


df = pd.read_csv("%s" % str(sys.argv[1]), sep='\s*&\s*', index_col=False, engine='python')
#print(df)

df=df.transpose()
print(df.to_latex(escape=False))
