import numpy as np
import sys

'''
This script rescales epsilon.in based on the value of WW parameter
WW parameter has to be set when running the script as follows:
python path/to/the/script/rescale_eps.py WW
(Replace WW with the WW parameter value)
'''

WW=float(sys.argv[1])


# WW=14.39

data=np.loadtxt("epsilon.in-original")

epsilon_new=data/data[0,0]*WW

np.savetxt("epsilon.in",epsilon_new,fmt='%.3f')



