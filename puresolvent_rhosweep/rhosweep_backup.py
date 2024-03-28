import sys
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import CubicSpline as CS
from scipy.integrate import quad
import csv

file_path = 'DEFINITIONS.txt'

data = {}
with open(file_path, 'r') as file:
    for line in file:
        key, value = line.strip().split('=')
        data[key] = float(value)

print(data)

vol=data['vol']
lseg=data['lseg']
stmin=data['stmin']
stmax=data['stmax']
ststep=data['ststep']
rhomin=data['rhomin']
rhomax=data['rhomax']
rhostep=data['rhostep']

counter_max=int((rhomax-rhomin)/rhostep)
stcounter_max=int((stmax-stmin)/ststep)

st=stmin


gtot=-2.0**1.5/3.0*np.pi*lseg**3

p_binodal=[]
V_binodal=[]
p_spinodal=[]
V_spinodal=[]

for eps in range(0,stcounter_max+1):
    
  logrho=rhomin 
  volfraction=[]
  muwater=[]
  S_mix=[]
  F_HS=[]
  F_tot=[]
  F_vdw=[]
  pressure=[]
  molarvolume=[]
  molarvolumetoplot=[]
  pressuretoplot=[]
  volfractiontoplot=[]
  muwatertoplot=[]
  rho=[]
  rhotoplot=[]

  print('Solving eps = ')
  print(st)

  for i in range(0, counter_max+1):
    rho.append(10.**logrho)
    volfraction.append(rho[i]*vol)
    logvolfraction=np.log(volfraction[i])
    uvdw=rho[i]*st*gtot
    uHS=(8.0*volfraction[i]-9.0*volfraction[i]**2.0+3.0*volfraction[i]**3.)/(1.-volfraction[i])**3.
    muwater.append(logvolfraction + uvdw + uHS)
    S_mix.append(rho[i]*(logvolfraction-1.0))
    F_vdw.append(uvdw*rho[i]/2.0)
    F_HS.append(rho[i]*volfraction[i]*(4.0-3.0*volfraction[i])/(1-volfraction[i])**2.0)
    F_tot.append(S_mix[i] + F_vdw[i] + F_HS[i] - rho[i]*muwater[i])
    pressure.insert(0,-F_tot[i])
    molarvolume.insert(0,1./rho[i])
    logrho=logrho+rhostep
    if i/10 == i//10:
      molarvolumetoplot.insert(0,1./rho[i])
      pressuretoplot.insert(0,-F_tot[i])
      rhotoplot.append(rho[i])
      muwatertoplot.append(muwater[i])

  
  filename_data=f'datatotal.{st:.2f}.dat'
  with open(filename_data, 'w', newline='') as file:
    writer=csv.writer(file,delimiter=' ')
    writer.writerow(['#','rho','volfrac','mu','F','p','molarvol'])
    for item1,item2,item3,item4,item5,item6 in zip(rho,volfraction,muwater,F_tot,pressure[::-1],molarvolume[::-1]):
      writer.writerow([item1, item2, item3, item4, item5, item6])



  pV_interp=CS(molarvolume,pressure)
  pV_fit=pV_interp(molarvolume)

  mudens_interp=CS(rho,muwater)
  mudens_fit=mudens_interp(rho)
  
#  deriv_pV=pV_interp.derivative()
#  V_limits=deriv_pV.roots()
#  p_limits=pV_interp(V_limits)
#  print(f"P limits are: {p_limits}")
  
  deriv_mudens = mudens_interp.derivative()
  rho_limits=deriv_mudens.roots()
  mu_limits=mudens_interp(rho_limits)

  V_limits_frommu=1./rho_limits
  p_limits_frommu=pV_interp(V_limits_frommu)


  print(f"V limits are: {V_limits_frommu}")
  print(f"P limits are: {p_limits_frommu}")
  print(f"Rho limits are: {rho_limits}")
  print(f"Mu limits are: {mu_limits}")

#  if len(p_limits) == 2:
#     p0_step=(p_limits[1]-p_limits[0])/1000
#     p0=p_limits[0]+p0_step
#     pvap=[]
#     diffsum=[]
#     for i in range(1,1000):
#       pVcorr_interp=CS(molarvolume,pressure-p0)
#       roots=pVcorr_interp.roots()
#       sum1, error = quad(pVcorr_interp, Vroots[0], Vroots[1])
#       sum2, error = quad(pVcorr_interp, Vroots[1], Vroots[2])
#       pvap.append(p0)
#       diffsum.append(sum1+sum2)
#       p0=p0+p0_step
#    
#     pvap_interp=CS(pvap,diffsum)
#     pvap_roots=pvap_interp.roots()
#     pvap_eq = [root for root in pvap_roots if p_limits[0] <= root <= p_limits[1]]
#     print('pvap of equilibrium is: ')
#     print(pvap_eq)
#     pVminuspvap_interp=CS(molarvolume, pressure-pvap_eq[0])
#     Veq=pVminuspvap_interp.roots()
#     print('V at equilibrium is: ')
#     print(Veq)

  if len(mu_limits) == 2:

     p_spinodal.insert(0,p_limits_frommu[1])
     p_spinodal.append(p_limits_frommu[0])
     V_spinodal.insert(0,V_limits_frommu[1])
     V_spinodal.append(V_limits_frommu[0])

     mu0_step=(mu_limits[0]-mu_limits[1])/1000
     mu0=mu_limits[1]+mu0_step
     mu=[]
     diffsum_mu=[]
     
     for i in range(1,1000):
       mudenscorr_interp=CS(rho,muwater-mu0)
       rhoroots=mudenscorr_interp.roots()
       sum3, error = quad(mudenscorr_interp, rhoroots[0], rhoroots[1])
       sum4, error = quad(mudenscorr_interp, rhoroots[1], rhoroots[2])
       mu.append(mu0)
       diffsum_mu.append(sum3+sum4)
       mu0=mu0+mu0_step
     

     mu_interp=CS(mu,diffsum_mu)
     mu_roots=mu_interp.roots()
     mu_eq = [root for root in mu_roots if mu_limits[1] <= root <= mu_limits[0]]
     print(f'Mu of equilibrium is: {mu_eq}')
     mudensminusmueq_interp=CS(rho, muwater-mu_eq[0])
     rho_eq=mudensminusmueq_interp.roots()
    
     V_eq_frommu=1./rho_eq

     print(f'Rho at equilibrium is: {rho_eq}')
     print(f'V at equilibrium is: {V_eq_frommu}')
    
     pvap_eq_frommu=pV_interp(V_eq_frommu)

     print(f'pvap at equilibirum is: {pvap_eq_frommu}')

     p_binodal.insert(0,pvap_eq_frommu[0])
     p_binodal.append(pvap_eq_frommu[2])
     V_binodal.insert(0,V_eq_frommu[2])
     V_binodal.append(V_eq_frommu[0])
  

  def pV_final(x):
    result=None
    if len(mu_limits == 2):
      if (V_eq_frommu[2] <= x <= V_eq_frommu[0]):  
        result=pvap_eq_frommu[0]
      else:
        result=pV_interp(x)
    else:
      result=pV_interp(x)
    return result
  
  pV_final_toplot=[]
  
  for i in range(0,len(molarvolume)):
    pV_final_toplot.append(pV_final(molarvolume[i]))
  
  
  plt.figure(1) 
#  plt.scatter(molarvolumetoplot,pressuretoplot,s=5,label=f'eps = {st:.2f}')
  plt.plot(molarvolume,pV_final_toplot,lw=1,label=f'eps = {st:.2f}') 
#  plt.scatter(V_limits,p_limits,color='black',marker='x')
  plt.scatter(V_limits_frommu,p_limits_frommu,color='black',marker='s',facecolors='none',edgecolors='black',lw=1)
  if len(mu_limits) == 2:
     plt.scatter([V_eq_frommu[0],V_eq_frommu[2]],[pvap_eq_frommu[0],pvap_eq_frommu[0]],s=15,marker='o',facecolors='none',edgecolors='black',lw=1)

  plt.figure(2)
  plt.plot(rho,mudens_fit,lw=1,label=f'eps = {st:.2f}')
#  plt.scatter(volfractiontoplot,muwatertoplot,s=5,label=f'eps = {st:.2f}')
  plt.scatter(rho_limits,mu_limits,color='black',marker='x')
  if len(mu_limits) == 2:
    plt.scatter([rho_eq[0],rho_eq[2]],[mu_eq[0],mu_eq[0]],s=15,marker='o',facecolors='none',edgecolors='black',lw=1)
  
    
  if len(mu_limits) == 2:
    Vol_towrite=np.linspace(V_eq_frommu[0],molarvolume[-1],1000)
    mu_towrite=np.linspace(mu_eq[0],muwater[-1],1000)
    p_towrite=pV_interp(Vol_towrite)

    filename_mup=f'data.{st:.2f}.dat'
    with open(filename_mup, 'w', newline='') as file:
      writer=csv.writer(file,delimiter=' ')
      writer.writerow(['#','V','p','mu','(gas','phase)'])
      for item1,item2,item3 in zip(Vol_towrite,p_towrite,mu_towrite):
        writer.writerow([item1, item2, item3])





  st=st+ststep

# print(V_binodal)
# print(p_binodal)
# print(V_spinodal)
# print(p_spinodal)

binodal=CS(V_binodal,p_binodal)
spinodal=CS(V_spinodal,p_spinodal)
logVbin=np.linspace(np.log(V_eq_frommu[2]),np.log(V_eq_frommu[0]),200)
logVspin=np.linspace(np.log(V_limits_frommu[1]),np.log(V_limits_frommu[0]),200)

Vbin=np.exp(logVbin)
Vspin=np.exp(logVspin)

#index=[]
#for i in range(0,counter_max+1):
#  for j in range(i,counter_max+1):
#    diff=pressure[i]-pressure[j]
#    if pressure[j] == pressure[i]:
#      j1 = j
#      continue
#  for j in range(j,counter_max+1):
#    if pressure[j] == pressure[j1]:
#      index.append([i,j1,j])

#print(index)

plt.figure(1)
plt.plot(Vbin,spinodal(Vbin),linestyle='--',color='blue')
plt.plot(Vbin,binodal(Vbin),linestyle='--',color='red')
plt.xscale('log')
plt.yscale('log')
plt.xlabel('$Volume\ /\ nm^3molecule^{-1}$')
plt.ylabel('$Pressure$')
plt.legend()
plt.figure(2)
plt.xlabel(r'$\rho\ /\ molecules\ nm^{-3}$')
plt.ylabel(r'$\mu_{water}$')
plt.legend()
plt.show()


