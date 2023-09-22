subroutine free_energy

use mfkfun
use Reservoir

implicit none

integer i,j
real*8 F_1, F_2
real*8 F_mixs, F_mixpol, F_mixCl, F_mix
real*8 F_HS
real*8 F_chem
real*8 F_vdw(4,4),Fvdw_tot
character*17 Fvdw_filename(4,4)


print*,"Starting Free Energy calculation:"

if (flagreservoir.eq.1) then
  open(unit=301,file='F_mix.dat')
  open(unit=302,file='F_mixs.dat')
  open(unit=303,file='F_mixpol.dat')
  open(unit=304,file='F_mixCl.dat')
  open(unit=305,file='F_vdw.dat')
  open(unit=306,file='F_HS.dat')
  open(unit=307,file='F_chem.dat')
  open(unit=308,file='F_tot.dat')
  open(unit=309,file='F_tot2.dat')
  open(unit=310,file='F_tot_noreservoir.dat') ! total semi-grand canonical potential per molecule
  open(unit=311,file='F_reservoir.dat') ! canonical potential density of water reservoir (-pressure)

  do i=1,4
  do j=1,4
    
    write(Fvdw_filename(i,j),'(A6,BZ,I3.3,A1,I3.3,A4)')'F_vdW.',i,'.',j,'.dat'
    open(unit=10000*i+j,file=Fvdw_filename(i,j))

  enddo
  enddo

endif


!! Free energy 1 !!

F_1=0.0
F_2=0.0
F_mixs = 0.0
F_mixpol = 0.0
F_mixCl = 0.0
F_mix = 0.0
F_vdw(:,:) = 0.0
Fvdw_tot = 0.0
F_HS = 0.0
F_chem = 0.0

if (flagreservoir.eq.0) then
  F_reservoir=0.0
  F_mix_reservoir=0.0
  F_vdw_reservoir=0.0
  F_HS_reservoir=0.0
  Nmuwater_reservoir=0.0
  rhosol_reservoir=volumefraction(1)/vol
endif

!! F_mix !!

if (flagreservoir.eq.1) then 
  F_mixpol = rho_pol*(log(rho_pol*vol)-1.0)
  F_mixCl = freeClvolumefraction/vol*(log(freeClvolumefraction)-1.0)
endif

F_mixs = volumefraction(1)/vol*(log(volumefraction(1))-1.0)

F_mix = F_mixpol + F_mixs + F_mixCl - F_mix_reservoir

if (flagreservoir.eq.0)F_mix_reservoir=F_mixs

! print*,"F_mix is",F_mix/rho_pol

!! F_vdw !!

do i=1,4
do j=1,4
  F_vdw(i,j) = Xu/2.0*st(i,j)*volumefraction(i)*volumefraction(j)/vol/vol
  Fvdw_tot = Fvdw_tot + F_vdw(i,j)
enddo
enddo

Fvdw_tot = Fvdw_tot-F_vdw_reservoir

if (flagreservoir.eq.0)F_vdw_reservoir=Fvdw_tot

! print*,"Fvdw is ", Fvdw_tot/rho_pol

!! F_HS !!

F_HS = volumefraction_total**2.0*(4.0-3.0*volumefraction_total)/(1.0-volumefraction_total)**2.0
F_HS = F_HS / vol
F_HS = F_HS - F_HS_reservoir

if (flagreservoir.eq.0)F_HS_reservoir=F_HS

! print*,"F_HS is ",F_HS/rho_pol

!! F_chem !!

if (flagreservoir.eq.1) then
  F_chem = volumefraction(3)/vol*(chargefraction*log(chargefraction)+(1.-chargefraction)*log(1.-chargefraction))
  F_chem = F_chem + volumefraction(3)/vol*chargefraction*log(Kas)
endif
! print*,"F_chem is ", F_chem/rho_pol

F_1 = F_mix + F_HS + Fvdw_tot + F_chem - muwater*volumefraction(1)/vol

F_1 = F_1 + Nmuwater_reservoir
! print*,"muwater contribution is ",-muwater*volumefraction(1)/vol/rho_pol

if (flagreservoir.eq.0) then
  Nmuwater_reservoir=muwater*volumefraction(1)/vol
endif

   !!!!!!!!!!!!!!!!!!!
!!!!! Free energy 2 !!!!!
   !!!!!!!!!!!!!!!!!!!

!! HS term !!

! print*,"F2 is ",F_2/rho_pol

F_2 = -2.*volumefraction_total**2*(2.-volumefraction_total)
F_2 = F_2/(1.-volumefraction_total)**3
F_2 = F_2/vol

! print*,"After HS, F2 is ",F_2/rho_pol

!! polymer chem potential !!

F_2 = F_2 + rho_pol*mupol

! print*,"After mupol, F2 is ",F_2/rho_pol, mupol

!! interactions !!

F_2 = F_2 - (Fvdw_tot + F_vdw_reservoir)

! print*,"After vdw, F2 is ",F_2/rho_pol

!! number densities !!

F_2 = F_2 - rho_pol - freeClvolumefraction/vol - volumefraction(1)/vol


F_2 = F_2 - F_reservoir

! print*,"After numberdensities, F2 is ",F_2/rho_pol

if (flagreservoir.eq.0) then
  F_reservoir=F_1
  print*,"Free Energy of flag reservoir is: ",F_1,F_2,F_vdw_reservoir+F_HS_reservoir+F_mix_reservoir-NMuwater_reservoir
else

  print*,"Free Energy 1: ",F_1/rho_pol 
  print*,"Free Energy 2: ",F_2/rho_pol 

  !! write to files !!

  write(301,*)rho_pol,muwater,F_mix/rho_pol
  write(302,*)rho_pol,muwater,F_mixs/rho_pol
  write(303,*)rho_pol,muwater,F_mixpol/rho_pol
  write(304,*)rho_pol,muwater,F_mixCl/rho_pol
  write(305,*)rho_pol,muwater,FvdW_tot/rho_pol
  write(306,*)rho_pol,muwater,F_HS/rho_pol
  write(307,*)rho_pol,muwater,F_chem/rho_pol
  write(308,*)rho_pol,muwater,F_1/rho_pol 
  write(309,*)rho_pol,muwater,F_2/rho_pol
  write(310,*)rho_pol,muwater,(F_1+F_reservoir)/rho_pol
  write(311,*)rho_pol,muwater,rhosol_reservoir,F_reservoir

  do i = 1,4
  do j = 1,4
    write(10000*i+j,*)rho_pol,muwater,F_vdw(i,j)/rho_pol
  enddo
  enddo

endif


end
