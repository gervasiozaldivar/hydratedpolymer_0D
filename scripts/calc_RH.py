import numpy as np
from scipy.interpolate import CubicSpline
import matplotlib.pyplot as plt

filename="data.11.43.dat"
data=np.loadtxt(filename)

filetowrite=open("mu_vs_RH.dat","w")

RH=[]
mu=[]
for i in range(0,len(data)):
    RH.append(data[i][1]/data[-1][1]*100)
    mu.append(data[i][2])

RH_interp=CubicSpline(RH,mu)


x_interp=np.linspace(1,99,99)

y_interp=RH_interp(x_interp)


for i in range(0,len(x_interp)):
  filetowrite.write(str(x_interp[i]))
  filetowrite.write('\t')
  filetowrite.write(str(y_interp[i]))
  filetowrite.write('\n')


"""
plt.plot(RH,mu,'o')
plt.plot(x_interp,y_interp,'-')

plt.show()
"""



