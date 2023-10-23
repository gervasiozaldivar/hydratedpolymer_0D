subroutine fkfun (x, f, ier) !x, f and ier are inputs/outputs to communicate with other subroutines

use mfkfun

implicit none

integer*8 j,i !indices
integer ier
real*8 f, x      ! x(1:ntot)=volumefraction(i)  
real*8 u_HS, u_vdw(4)
real*8 volumefractionwater
real*8 algo 

iter=iter+1

volumefraction(1) = exp(-x) ! water volume fraction is read from kinsol x

do i=2,2+Npoorsv
  volumefraction(i)=n(i)*rho_pol*vol ! Volume fraction of beads 2:cl 3:N 4:C
enddo

volumefraction_total=0.0

do i=1,2+Npoorsv
  volumefraction_total = volumefraction_total + volumefraction(i)  ! total volume fraction of beads
enddo

freeClvolumefraction=volumefraction(2)*chargefraction


! u_HS : hard sphere potential 

u_HS=0.0
u_HS=(8.0*volumefraction_total-9.0*volumefraction_total**2.0+3.0*volumefraction_total**3.0)/(1.0-volumefraction_total)**3.0

! u_vdw : van der waals potentials

u_vdW(:)=0.0

do i=1,2+Npoorsv

  do j=1,4
    u_vdW(i)=u_vdw(i)+st(i,j)*volumefraction(j)
  enddo

  u_vdw(i)=u_vdw(i)*n(i)

enddo

u_vdw(:)=u_vdw(:)/vol

!! calculation of volume fraction of water !!

volumefractionwater = exp(muwater) ! chemical potential
volumefractionwater = volumefractionwater*exp(-Xu*u_vdw(1)) ! van der waals interactions
volumefractionwater = volumefractionwater*exp(-u_HS) ! hard spheres interactions

!! calculation of mupol !!

mupol=0.0

if (flagreservoir.eq.1) then

  mupol=log(rho_pol*vol)

  do i=2,4
    mupol = mupol + Xu*u_vdw(i) ! van der waals interactions
    mupol = mupol + n(i)*u_HS ! hard sphere interactions
  enddo

  mupol = mupol + n(3)*log(1.0-chargefraction)

endif
!! kinsol function !!

f = (volumefraction(1)-volumefractionwater)/volumefraction(1)



ier = 0 !si ier ne 0 el kinsol tira error.

algo=0.0
algo=algo+f**2
!  print*, i, f(i), x(i)

print*,iter,algo,volumefraction(1),volumefractionwater

end

