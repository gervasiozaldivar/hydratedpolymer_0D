import numpy as np



beads=["W", "C5", "C4", "C3", "C2", "C1", "X2", "Q5", "Q4", "Q3", "Q2", "Q1"]

sigma = 0.47

beadeps_array = np.zeros((len(beads),len(beads)))

f = open("epsilon_list_4to1.dat", "w")

for i in range(0,len(beads)):
  for j in range(i,len(beads)):
     
     filename = beads[i] + "_" + beads[j] + ".dat"
     
     array = np.loadtxt(filename)
     
     #  print(x)
     
     beadeps =  array[0,1]
     beadsigma = array[0,0]

     print(beads[i],beads[j],beadeps)

     beadeps = beadeps * sigma**3 * beadsigma ** -3
     
     print(beads[i],beads[j],beadeps)

     beadeps = beadeps / 2.477572 * 4.
     
     print(beads[i],beads[j],beadeps)

     f.write(f"{beads[i]} {beads[j]} {beadeps}\n") 
     
     beadeps_array[i][j] = beadeps
     
     beadeps_array[j][i] = beadeps

header_txt=' '.join(beads)

np.savetxt("epsilon_array_4to1.dat", beadeps_array, header=header_txt, fmt='%.3f')





