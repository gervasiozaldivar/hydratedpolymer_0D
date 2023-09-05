program elctrolyte

use mfkfun
use mkinsol

implicit none

integer i, j, counter,counter_max
! real*8 z, ztrash
real*8, allocatable :: x_init
! character*22, volfractionfilename
! character*13, mupolfilename
character*14, sysfilename

call readinput
call init
neq = 1 


! call allocation
allocate(pp(neq))

! print*,"kai calculation"

! call kai

x_init = 0.1 ! water volume fraction initial guess

if (infile.eq.1) then
!  do i=1,ntot
!   read(8,*), bla
   x_init = -dlog(bla)
!  enddo
  infile = 2
endif


rho_pol = rhopol_min
counter = 0
counter_max = int( (rhopol_max - rhopol_min)/rhopol_step )



open(unit=2000,file='mupol.dat')
open(unit=1000,file='volfraction.dat')
open(unit=3000,file='fractionNplus.dat')
open(unit=4000,file='system.dat')

write(4000,*)"rhopol_min   rhopol_max      rhopol_step"
write(4000,*)rhopol_max,rhopol_max,rhopol_step
write(4000,*)"Interaction parameters"
write(4000,*),st
write(4000,*)"vol = ", vol
write(4000,*)"lseg = ", lseg
write(4000,*)"Number of beads (W,Cl,N,CH2) = ", n
write(4000,*),"Kas = ",Kas


do while (counter.le.counter_max)

  iter=0
  counter=counter+1
  
  print*, "Solving rho_pol = ",rho_pol

  chargefraction = (1+4*n(3)*rho_pol*vol*Kas)**0.5-1
  chargefraction = chargefraction/(2*n(3)*rho_pol*vol*Kas)

  call call_kinsol(x_init)

  write(1000,*)rho_pol, volumefraction(1), volumefraction(2), volumefraction(3), volumefraction(4), volumefraction_total
  write(2000,*)rho_pol, mupol
  write(3000,*)rho_pol, chargefraction

  x_init = -log(volumefraction(1))

  call free_energy

  rho_pol=rho_pol+rhopol_step
  
  print*,"n is ", n(1),n(2),n(3),n(4)
    
enddo


close(1000)
close(2000)
close(3000)
close(4000)

do i=1,9
  close(300+i)
enddo


do i=1,4
do j=1,4
  close(10000*i+j)
enddo
enddo 

end
