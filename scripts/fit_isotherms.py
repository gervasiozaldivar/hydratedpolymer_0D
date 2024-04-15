import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
import sys


def park(x, AL, bL, kH, ka, n):
   value = x*AL*bL/(1+x*bL) + kH*x + ka*x**n
   return value

def NDMS(x,cp,k,A):
   value = cp*x*k*(A-1)/(1+x*k*(A-1)) + cp*x*k/(1-x*k)
   return value

def park_1(x, AL, bL, kH, ka, n):
    value = x*AL*bL/(1+x*bL)
    return value 

def park_2(x, AL, bL, kH, ka, n):
    value = kH*x
    return value

def park_3(x, AL, bL, kH, ka, n):
    value = ka*x**n
    return value

def NDMS_1(x, cp, k, A):
    value = cp*x*k*(A-1)/(1+x*k*(A-1)) 
    return value

def NDMS_2(x, cp, k, A):
    value = cp*x*k/(1-x*k)
    return value

filename=sys.argv[1]

data=np.loadtxt(filename)

xdata = data[:,0]
ydata = data[:,1]
xdata = xdata/100

initialguessPARK = [10,1,50,400,8]
bounds_PARK = ([0,0,0,0,0] ,[np.inf,np.inf,np.inf,np.inf,np.inf])
initialguessNDMS = [10,1,10.]
bounds_NDMS = ([0,0,0] ,[np.inf, np.inf,np.inf])


params_PARK, covariance_PARK = curve_fit(park, xdata, ydata, p0 = initialguessPARK,bounds=bounds_PARK)
params_NDMS, covariance_NDMS = curve_fit(NDMS, xdata, ydata, p0 = initialguessNDMS,bounds=bounds_NDMS)

x_fit=np.linspace(0,0.95,95)
ypark=park(x_fit,*params_PARK)
yNDMS=NDMS(x_fit,*params_NDMS)

ypark_1 = park_1(x_fit,*params_PARK)
ypark_2 = park_2(x_fit,*params_PARK)
ypark_3 = park_3(x_fit,*params_PARK)

yNDMS_1 = NDMS_1(x_fit,*params_NDMS)
yNDMS_2 = NDMS_2(x_fit,*params_NDMS)


y_predicted_PARK = park(xdata, *params_PARK)
y_predicted_NDMS = NDMS(xdata, *params_NDMS)

rss_PARK = np.sum((ydata - y_predicted_PARK) ** 2)
rss_NDMS = np.sum((ydata - y_predicted_NDMS) ** 2)

tss = np.sum((ydata - np.mean(ydata)) ** 2)

r_squared_PARK = 1 - (rss_PARK / tss)
r_squared_NDMS = 1 - (rss_NDMS / tss)

filetowrite="fitparams.dat"
f= open(filetowrite,'w')
f.write("#PARK:  AL bL kH ka n R^2")
f.write("\n")
for i in params_PARK:
    f.write(f"{i:e} ")
f.write(f"{r_squared_PARK:e}")
f.write("\n")
f.write("#NDMS: cp k A R^2")
f.write("\n")
for i in params_NDMS:
    f.write(f"{i:e} ")
f.write(f"{r_squared_NDMS:e}")

plt.figure(1)
plt.scatter(xdata,ydata,color='black',label='Original data')
plt.plot(x_fit,ypark,label='Park',color='red')
plt.plot(x_fit,ypark_1,'--',color='red')
plt.plot(x_fit,ypark_2,'--',color='red')
plt.plot(x_fit,ypark_3,'--',color='red')

plt.legend()

plt.figure(2)
plt.scatter(xdata,ydata,color='black',label='Original data')
plt.plot(x_fit,yNDMS,label='NDMS',color='blue')
plt.plot(x_fit,yNDMS_1,'--',color='blue')
plt.plot(x_fit,yNDMS_2,'--',color='blue')

plt.legend()

plt.show()
