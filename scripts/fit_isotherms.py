import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

def park(x, AL, bL, kH, ka, n):
   value = x*AL*bL/(1+x*bL) + kH*x + ka*x**n
   return value

def NDMS(x,cp,k,A):
   value = cp*x*k*(A-1)/(1+x*k*(A-1)) + cp*x*k/(1-x*k)
   return value


filename="WU_vs_aw.dat"

data=np.loadtxt(filename)

xdata = data[:,0]
ydata = data[:,1]


initialguessPARK = [1,1,1,10,8]

initialguessNDMS = [10,0.8,15]

params_PARK, covariance_PARK = curve_fit(park, xdata, ydata, p0 = initialguessPARK)
params_NDMS, covariance_NDMS = curve_fit(NDMS, xdata, ydata, p0 = initialguessNDMS)

x_fit=np.linspace(0,0.85,86)
ypark=park(x_fit,*params_PARK)
yNDMS=NDMS(x_fit,*params_NDMS)

print(*params_PARK)
print(*params_NDMS)


plt.scatter(xdata,ydata,color='black',label='Original data')
plt.plot(x_fit,ypark,label='Park',color='red')
plt.plot(x_fit,yNDMS,label='NDMS',color='blue')

plt.legend()

plt.show()
