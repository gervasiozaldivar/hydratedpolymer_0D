subroutine fkfun (x, f, ier) !x, f and ier are inputs/outputs to communicate with other subroutines

use mfkfun

implicit none

integer*8 j,i !indices
integer ier
real*8 f(2), x(2)      ! x(1:ntot)=volumefraction(i)  
real*8 u_HS, u_vdw(Npoorsv+2), u_chi
real*8 volumefractionwater
real*8 algo 

iter=iter+1

volumefraction(1) = exp(-x(1)) ! water volume fraction is read from kinsol x

chargefraction = x(2) ! charge fraction is read from kinsol x

do i=2,2+Npoorsv
  volumefraction(i)=n(i)*rho_pol*vol ! Volume fraction of beads 2:cl 3:N 4:C
enddo

volumefraction_total=0.0

do i=1,2+Npoorsv
  volumefraction_total = volumefraction_total + volumefraction(i)  ! total volume fraction of beads
enddo

freeClvolumefraction=volumefraction(2)*chargefraction

perm = perm_water*(volumefraction(1)+volumefraction(2))

do i = 3,2+Npoorsv
  perm = perm + perm_pol*volumefraction(i)
enddo

perm = perm/volumefraction_total

! u_HS : hard sphere potential 

u_HS=0.0
u_HS=(8.0*volumefraction_total-9.0*volumefraction_total**2.0+3.0*volumefraction_total**3.0)/(1.0-volumefraction_total)**3.0

! u_vdw : van der waals potentials

u_vdW(:)=0.0

do i=1,2+Npoorsv

  do j=1,2+Npoorsv
    u_vdW(i)=u_vdw(i)+st(i,j)*volumefraction(j)
  enddo

  u_vdw(i)=u_vdw(i)*n(i)

enddo

u_vdw(:)=u_vdw(:)/vol

! u_chi : third virial term

u_chi = chi * volumefraction(1)**2 
u_chi = u_chi / vol**2

! u_self : born potential

u_self = 2*u_born
u_self = u_self*chargefraction*volumefraction(2)/volumefraction_total/perm

!! calculation of volume fraction of water !!

volumefractionwater = exp(muwater) ! chemical potential
volumefractionwater = volumefractionwater*exp(-Xu*u_vdw(1)) ! van der waals interactions
volumefractionwater = volumefractionwater*exp(-u_HS) ! hard spheres interactions
volumefractionwater = volumefractionwater*exp(-u_self*(perm_water/perm-1.))
volumefractionwater = volumefractionwater*exp(-u_chi)

!! calculation of mupol !!

mupol=0.0

if (flagreservoir.eq.1) then

  mupol=log(rho_pol*vol)

  do i=2,2+Npoorsv
    mupol = mupol + Xu*u_vdw(i) ! van der waals interactions
    mupol = mupol + n(i)*u_HS ! hard sphere interactions
  enddo

  mupol = mupol + n(3)*log(1.0-chargefraction)
  mupol = mupol + n(2)*(perm_water/perm - 1.)*u_self

  do i=3,2+Npoorsv
    mupol = mupol + n(i)*(perm_pol/perm - 1.)*u_self
  enddo

endif

!! calculaction of new charge fraction !!
if (flagreservoir.eq.1) then
  Kas_corr = Kas*exp(2*u_born*(1./perm-1./perm_water))
!  print*,"Kas, Kascor,perm,u_born",Kas,Kas_corr, perm, u_born
  chargefraction_new = (1+4*volumefraction(3)*Kas_corr)**0.5-1 ! charge fraction initial guess
  chargefraction_new = chargefraction_new/(2*volumefraction(3)*Kas_corr) ! charge fraction initial guess
else
  chargefraction_new = chargefraction
endif
!! kinsol function !!

f(1) = (volumefraction(1)-volumefractionwater)/volumefraction(1)
!print*,"charge fraction is ", chargefraction,chargefraction_new
f(2) = (chargefraction - chargefraction_new)/chargefraction_new


ier = 0 !si ier ne 0 el kinsol tira error.

algo=0.0
do i=1,2
  algo=algo+f(i)**2
enddo
  
!  print*, i, f(i), x(i)

print*,iter,algo,volumefraction(1),volumefractionwater,chargefraction,chargefraction_new, flagreservoir

end

