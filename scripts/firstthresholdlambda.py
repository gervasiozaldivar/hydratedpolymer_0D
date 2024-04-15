import numpy as np
import sys
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

# IEC=sys.argv[1]
IEC_list=["100","85","75"]

color_list=['k','b','r','g','c','m']

gray=(0.3, 0.3, 0.3)

for IEC in IEC_list:

    lambdalocation="../lamdba_"+IEC+".dat"

    F_Wion_data = np.loadtxt("F_sumWion-vs-RH_IEC"+IEC+".dat")
    F_Wion = F_Wion_data[:,1]

    F_Wpol_data = np.loadtxt("F_sumWpol-vs-RH_IEC"+IEC+".dat")
    F_Wpol = F_Wpol_data[:,1]

    F_Wattr_data = np.loadtxt("F_sumWattractive-vs-RH_IEC"+IEC+".dat")
    F_Wattr = F_Wattr_data[:,1]

    hydrnumber_data = np.loadtxt(lambdalocation)
    hydrnumber = hydrnumber_data[:,1]

    interp_Wion = interp1d(hydrnumber, F_Wion, kind='cubic')
    interp_Wpol = interp1d(hydrnumber, F_Wpol, kind='cubic')
    interp_Wattr = interp1d(hydrnumber, F_Wattr, kind='cubic')


    F_diff = F_Wattr - F_Wion - F_Wpol

    F_diff = F_diff / F_Wattr

    interp_diff = interp1d(hydrnumber, F_diff, kind='cubic')

    index = 0

    hn = np.linspace(hydrnumber[0],hydrnumber[-1],1000)

    for i in hn:
      
       diff = interp_diff(i)

       if diff > 0.05:

           continue

       index+=1

    print(hn[index])


    plt.plot(hydrnumber,F_diff,'o',linestyle='none',markerfacecolor='none',color=color_list[IEC_list.index(IEC)],label="DF = "+IEC)

    plt.plot(hn,interp_diff(hn),'--',color=color_list[IEC_list.index(IEC)],label="DF = "+IEC+" interp")

    plt.plot(hn[index],interp_diff(hn[index]),'x',color=gray,markersize=10,markeredgewidth=3)

plt.xlabel("Lambda")
plt.ylabel('(F_Wattr - F_WW)/W_Wattr)')

plt.legend()
plt.show()
