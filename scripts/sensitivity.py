import numpy as np


WU100 = np.loadtxt("wateruptake_100.dat")
WU85 = np.loadtxt("wateruptake_85.dat")

sensitivity = np.zeros(WU100.shape)
sensitivity[:,1] = WU100[:,1]/WU85[:,1]

sensitivity[:,0] = WU100[:,0]

np.savetxt("sensitivity.dat",sensitivity,fmt='%.2f')
