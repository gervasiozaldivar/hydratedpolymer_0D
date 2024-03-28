import numpy as np
import os



# for i in 
IEC_list=[100,85,75]
RH_list=["01","05","15","25","35","45","55","65","75","85","95","99"]
MW_list=[96.9,14,79.9]

for IEC in IEC_list:

  #open files#
  
  filerhopol = open(f"rhopol_{IEC}.dat",'w')
  filephiwater = open(f"volfraction_water_{IEC}.dat",'w')
  filephiion = open(f"volfraction_ion_{IEC}.dat",'w')
  filephiC = open(f"volfraction_C_{IEC}.dat",'w')
  filephitotal = open(f"volfraction_total_{IEC}.dat",'w')
  filephipolymer = open(f"volfraction_polymer_{IEC}.dat",'w')
  filerhowater = open(f"rhowater_{IEC}.dat",'w')  
  filerhoion = open(f"rhoion_{IEC}.dat",'w')
  filelambda = open(f"lamdba_{IEC}.dat",'w') 
  filepolconc = open(f"polymerconc_{IEC}.dat",'w')
  filewaterconc = open(f"waterconc_{IEC}.dat",'w')
  fileionconc = open(f"ionconc_{IEC}.dat",'w')
  filedensity = open(f"density_{IEC}.dat",'w')
  filevolratio = open(f"volexpansionratio_{IEC}.dat",'w')
  filewateruptake = open(f"wateruptake_{IEC}.dat",'w')


  for RH in RH_list:

#    work_path=f"/home/gervasio-lab/projects/hydratedpolymer/runs_ATOM/mtrx2_C3/rescaled/IEC{IEC}/RH{RH}"
#    os.chdir(work_path)
  
#   print(f"Work path is {work_path}")
    file_path=f"IEC{IEC}/RH{RH}/fort.8"
    try:
    
      with open(file_path,'r') as fort:
        lines=fort.readlines()
    except FileNotFoundError:
        print(f"File path not found: {file_path}")
        continue

    MWpolymer=0
    n=[]

    for i in lines:
        if "Npoorsv" in i:
            index=lines.index(i)
            Npoorsv=int(lines[index+1])
            print(f"Npoorsv is {Npoorsv}")
        if "n(N)" in i:
            index=lines.index(i)
            for j in range(1,Npoorsv+1):
                n.append(int(lines[index+j]))
                n_bead=n[j-1]
                print(f"n of bead {j} is: {n_bead}")
                MWpolymer += n_bead*MW_list[j-1]
            print(f"Polymer molecular Weight is: {MWpolymer}")
        if "bead volume" in i:
            index=lines.index(i)
            volume=float(lines[index+1])
            print(f"Bead volume is: {volume}")

    data = np.loadtxt(f"IEC{IEC}/RH{RH}/volfraction.min.dat")
    
    rhopol = data[0]
    phi_water = data[1]
    phi_ion = data[2]
    phi_C = data[4]
    phi_total = data[5]
    phi_polymer = rhopol*(sum(n)+n[0])*volume
   
    n_water = phi_water/volume
    n_ion = phi_ion/volume
    lambdaratio = n_water/n_ion
    polymerconc = rhopol*1e24/6.02e23 # units of moil/L

    if RH_list.index(RH)==0:
      polymerconc_0=polymerconc
    waterconc = n_water*1e24/6.02e23 # units of mol/L
    density = polymerconc*MWpolymer+waterconc*18.0
    density = density/1000 # units of g/mL
    volexpansionratio = polymerconc_0/polymerconc-1.
    WaterUptake = n_water*18./rhopol/MWpolymer
    ion_conc = polymerconc * n[0]

    # write to files#

    filerhopol.write(f"{RH}\t{rhopol}\n")
    filephiwater.write(f"{RH}\t{phi_water}\n")
    filephiion.write(f"{RH}\t{phi_ion}\n")
    filephiC.write(f"{RH}\t{phi_C}\n")
    filephitotal.write(f"{RH}\t{phi_total}\n")
    filephipolymer.write(f"{RH}\t{phi_polymer}\n")
    filerhowater.write(f"{RH}\t{n_water}\n")
    filerhoion.write(f"{RH}\t{n_ion}\n")
    filelambda.write(f"{RH}\t{lambdaratio}\n")
    filepolconc.write(f"{RH}\t{polymerconc}\n")
    filewaterconc.write(f"{RH}\t{waterconc}\n")
    fileionconc.write(f"{RH}\t{ion_conc}\n")
    filedensity.write(f"{RH}\t{density}\n")
    filevolratio.write(f"{RH}\t{volexpansionratio}\n")
    filewateruptake.write(f"{RH}\t{WaterUptake}\n")

