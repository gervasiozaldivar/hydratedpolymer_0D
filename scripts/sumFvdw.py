'''

Takes all the contributions to F_vdw and groups them into cohesive and water attractive
Example:

python sumFvdw.py 4 100 

where 4 is the number of type of beads and 100 is the IEC 

'''


import numpy as np
import sys

n = sys.argv[1]
IEC = sys.argv[2]

n = int(n)

data=[]

for i in range(1,n+1):
    for j in range(1,n+1):
        
        filename = f'F_vdW.{i:03d}.{j:03d}_vs_RH-IEC'+IEC+'.dat'
        
        data.append(np.loadtxt(filename))


WW = data[0]

Wion_y = data[1][:,1] + data[2][:,1] + data[4][:,1] + data[8][:,1]
Wion = np.column_stack((WW[:,0],Wion_y))

Wpol_y = data[3][:,1]*2
Wpol = np.column_stack((WW[:,0],Wpol_y))

ionion_y = data[5][:,1] + data[6][:,1] + data[9][:,1] + data[10][:,1]
ionion = np.column_stack((WW[:,0],ionion_y))

polion_y = data[7][:,1] + data[11][:,1] + data[13][:,1] + data[14][:,1]
polion = np.column_stack((WW[:,0],polion_y))

polpol = data[15]

cohesive_y = polpol[:,1] + polion_y + ionion_y
cohesive = np.column_stack((WW[:,0],cohesive_y))

Wattractive_y = WW[:,1] + Wion_y + Wpol_y
Wattractive = np.column_stack((WW[:,0],Wattractive_y)) 

Total_y = Wattractive_y + cohesive_y
Total = np.column_stack((WW[:,0],Total_y))

np.savetxt("F_sumWW-vs-RH_IEC"+IEC+".dat",WW)

np.savetxt("F_sumWion-vs-RH_IEC"+IEC+".dat",Wion)

np.savetxt("F_sumWpol-vs-RH_IEC"+IEC+".dat",Wpol)

np.savetxt("F_sumionion-vs-RH_IEC"+IEC+".dat",ionion)

np.savetxt("F_sumpolion-vs-RH_IEC"+IEC+".dat",polion)

np.savetxt("F_sumpolpol-vs-RH_IEC"+IEC+".dat",polpol)

np.savetxt("F_sumcohesive-vs-RH_IEC"+IEC+".dat",cohesive)

np.savetxt("F_sumWattractive-vs-RH_IEC"+IEC+".dat",Wattractive)

np.savetxt("F_sumTotal-RH_IEC"+IEC+".dat",Total)

