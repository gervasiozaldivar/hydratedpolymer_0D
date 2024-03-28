import sys
import numpy as np

file_path = 'DEFINITIONS.txt'

data = {}
with open(file_path, 'r') as file:
    for line in file:
        key, value = line.strip().split('=')
        data[key] = float(value)

print(data)

npoorsv=int(data['npoorsv'])

# n is the number of each type of bead per polymer chain in this order: Cl, N+, the rest

n=[]
n.append(data['n0'])
for i in range(0,npoorsv):
   name=f"n{i}"
   n.append(data[name])

vol=data['vol']
lseg=data['lseg']
Kas=data['Kas']
perm=data['permittivity']
rhomin=data['rhomin']
rhomax=data['rhomax']
rhostep=data['rhostep']

eps = np.loadtxt('epsilon.in')

gtot = -2.0**1.5/3.0*np.pi*lseg**3

perm_w = 78.4
u_born = 136.771069

Kas_corr = Kas * np.exp( 2. * u_born * (1./perm - 1./perm_w) )

rho = rhomin

counter_max = int((rhomax-rhomin)/rhostep)
print(counter_max)
volfraction = np.empty((npoorsv+1))

Fvdw = np.empty((npoorsv+1,npoorsv+1))

filename_Ftot = "F_tot.dat"
filename_Fvdw_tot = "F_vdw.dat"
filename_FmixCl = "F_mixCl.dat"
filename_Fmixp = "F_mixp.dat"
filename_FHS = "F_HS.dat"
filename_Fchem = "F_chem.dat"
filename_Fborn = "F_born.dat"
fileobject_Fvdw = []

for i in range(0,npoorsv+1):
  for j in range(0,npoorsv+1):
      fileobject_Fvdw.append(open(f"F_vdw.{i+1:03d}.{j+1:03d}.dat",'w'))
      
file_Ftot= open(filename_Ftot,'w')
file_Fvdw_tot = open(filename_Fvdw_tot,'w')
file_FmixCl = open(filename_FmixCl,'w')
file_Fmixp = open(filename_Fmixp,'w')
file_FHS = open(filename_FHS,'w')
file_Fchem = open(filename_Fchem,'w')
file_Fborn = open(filename_Fborn,'w')

for i in range(0,counter_max+1):

    FmixCl = n[0] * rho * (np.log(n[0]*rho*vol) - 1.) 
    Fmixp = rho * (np.log(rho*vol) - 1.) 

    rho_total = 0.
    Fvdw_tot = 0.

    vdwcount = 0
    
    for ii in range(0,npoorsv+1):
    
       rho_total += n[ii]*rho
       volfraction[ii] = n[ii]*rho*vol
       
       for jj in range(0,npoorsv+1):
          Fvdw [ii,jj] = eps[ii+2,jj+2] * volfraction[ii]*volfraction[jj]/vol**2 * gtot/2.
     
          fileobject_Fvdw[vdwcount].write(f"{rho}  {Fvdw[ii,jj]}\n")
          
          vdwcount+=1

          Fvdw_tot += Fvdw [ii,jj]
     
    FHS = vol * rho_total**2 * (4. - 3. * vol*rho_total) / (1 - vol*rho_total)**2  

    chargefraction = (1 + 4*volfraction[0] * Kas_corr)**0.5 - 1.
    chargefraction = chargefraction / (2 * volfraction[0] * Kas_corr)

    Fchem = volfraction[0]/vol * (chargefraction * np.log(chargefraction) + (1.-chargefraction) * np.log(1.-chargefraction))
    Fchem += volfraction[0]/vol * chargefraction * np.log(Kas_corr)
 
    Fborn = 2.*volfraction[0]/vol * chargefraction * u_born * (1/perm - 1/perm_w)
    
    Ftot = FmixCl + Fmixp + Fvdw_tot + Fchem + Fborn + FHS

    file_Ftot.write(f"{rho}  {Ftot}\n")
    
    file_FmixCl.write(f"{rho}  {FmixCl}\n")
    
    file_Fmixp.write(f"{rho}  {Fmixp}\n")
    
    file_Fvdw_tot.write(f"{rho}  {Fvdw}\n")
    
    file_Fchem.write(f"{rho}  {Fchem}\n")
    
    file_Fborn.write(f"{rho}  {Fborn}\n")
    
    file_FHS.write(f"{rho}  {FHS}\n")
    rho += rhomin
    
print("llegué")
