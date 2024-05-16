import numpy as np



beads=["W","P4", "N4", "C5", "C4", "C3", "C2", "C1", "X2", "Q5", "Q4", "Q3", "Q2", "Q1"]

sigma_ref=np.array([0.47,0.41,0.34])

volatom=(0.2767/2.)**3 * 4./3. * np.pi

atomeps_array = np.zeros((len(beads),len(beads)))

f = open("epsilon_list.dat", "w")

for i in range(0,len(beads)):
  for j in range(i,len(beads)):
     
     filename = beads[i] + "_" + beads[j] + ".dat"
     
     array = np.loadtxt(filename)
     
     sigma = array[:,0]

     x = (sigma_ref/2.)**3 * 4./3. * np.pi
     
     #  print(x)
     
     eps = array[:,1]
     
     y = []

     for k in range(0,3):
       y.append(eps[k] * sigma_ref[k]**3. * sigma[k]**(-3.))
       
     slope, intercept = np.polyfit(x, y, 1)
     
     atomeps = slope*volatom + intercept

     atomeps = atomeps / 2.477572 * 4.
     
     if atomeps <= 0:
         atomeps = 0.01

     f.write(f"{beads[i]} {beads[j]} {atomeps}\n") 
     
     atomeps_array[i][j] = atomeps
     
     atomeps_array[j][i] = atomeps

header_txt=' '.join(beads)

np.savetxt("epsilon_array.dat", atomeps_array, header=header_txt, fmt='%.3f')


#print(atomeps_array)
'''
calcular y: leer del array, ajustar por volumen

sacar slope y intercept

preguntar si es negativo, en cuyo caso igualar a 0.01

pasar a kT

ver cómo conviene imprimir.

'''




