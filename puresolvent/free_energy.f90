subroutine free_energy

use mfkfun

implicit none

integer i,j
real*8 F_1, F_2
real*8 F_mix
real*8 F_HS
real*8 Fvdw_tot


print*,"Starting Free Energy calculation:"

open(unit=301,file='F_mix.dat')
open(unit=302,file='F_vdw.dat')
open(unit=303,file='F_HS.dat')
open(unit=304,file='F_tot.dat')
open(unit=305,file='F_tot2.dat')
open(unit=306,file='p_vs_V.dat')
    
!! Free energy 1 !!

F_1=0.0
F_2=0.0
F_mix = 0.0
Fvdw_tot = 0.0
F_HS = 0.0

!! F_mix !!

F_mix = volumefraction/vol*(log(volumefraction)-1.0)

!! F_vdw !!

Fvdw_tot = Xu/2.0*st*volumefraction*volumefraction/vol/vol

!! F_HS !!

F_HS = volumefraction**2.0*(4.0-3.0*volumefraction)/(1.0-volumefraction)**2.0
F_HS = F_HS / vol


F_1 = F_mix + F_HS + Fvdw_tot - muwater*volumefraction/vol


   !!!!!!!!!!!!!!!!!!!
!!!!! Free energy 2 !!!!!
   !!!!!!!!!!!!!!!!!!!

!! HS term !!

F_2 = -2.*volumefraction**2*(2.-volumefraction)
F_2 = F_2/(1.-volumefraction)**3
F_2 = F_2/vol

!! interactions !!

F_2 = F_2 - Fvdw_tot

!! number densities !!

F_2 = F_2 - volumefraction/vol

print*,"Free Energy 1: ",F_1 
print*,"Free Energy 2: ",F_2 

!! write to files !!

write(301,*)volumefraction/vol,F_mix/volumefraction*vol
write(302,*)volumefraction/vol,FvdW_tot/volumefraction*vol
write(303,*)volumefraction/vol,F_HS/volumefraction*vol
write(304,*)volumefraction/vol,F_1/volumefraction*vol
write(305,*)volumefraction/vol,F_2/volumefraction*vol
write(306,*)vol/volumefraction,-F_1


end
