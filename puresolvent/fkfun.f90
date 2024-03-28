subroutine fkfun (x, f, ier) !x, f and ier are inputs/outputs to communicate with other subroutines

use mfkfun

implicit none

integer*8 j,i !indices
integer ier
real*8 f, x      ! x(1:ntot)=volumefraction(i)  
real*8 u_HS, u_vdw
real*8 volumefractionwater
real*8 algo 

iter=iter+1

volumefraction = exp(-x) ! water volume fraction is read from kinsol x


! u_HS : hard sphere potential 

u_HS=0.0
u_HS=(8.0*volumefraction-9.0*volumefraction**2.0+3.0*volumefraction**3.0)/(1.0-volumefraction)**3.0

! u_vdw : van der waals potentials

u_vdW=0.0

u_vdW=u_vdw+st*volumefraction/vol


!! calculation of volume fraction of water !!

volumefractionwater = exp(muwater) ! chemical potential
volumefractionwater = volumefractionwater*exp(-Xu*u_vdw) ! van der waals interactions
volumefractionwater = volumefractionwater*exp(-u_HS) ! hard spheres interactions


!! kinsol function !!

f = (volumefraction-volumefractionwater)/volumefraction



ier = 0 !si ier ne 0 el kinsol tira error.

algo=0.0
algo=algo+f**2
!  print*, i, f(i), x(i)

print*,iter,algo,volumefraction,volumefractionwater

end

