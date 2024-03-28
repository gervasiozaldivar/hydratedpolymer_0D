import sys
import numpy as np

beads=[]

for i in range(1,len(sys.argv)-1):
   beads.append(sys.argv[i])

filename="epsilon"+sys.argv[-1]+".dat"

# beads=["W","Q4","Q4","C3","X2"]
#filename="epsilonC3Q3.dat"

epsilonmtrx = np.zeros((len(beads),len(beads)))

with open("../epsilon_list.dat","r") as eps_list:
    
    eps_dict={}
    
    for line in eps_list:
        
        columns = line.strip().split()
        
        key=(columns[0],columns[1])
        
        eps=columns[2]

        eps_dict[key] = eps
ii=0

for i in beads:
  jj=0  
  for j in beads:
    
    # print(i+" "+j)
    
    if (i,j) in eps_dict:
      epsilonmtrx[ii][jj] = eps_dict[i,j]
    else:
      epsilonmtrx[ii][jj] = eps_dict[j,i]
    jj+=1
  ii+=1

np.savetxt(filename, epsilonmtrx, fmt='%.3f')

