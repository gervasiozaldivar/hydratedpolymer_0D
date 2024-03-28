program elctrolyte

use mfkfun
use mkinsol

implicit none
integer i, j, mucounter,mucounter_max
! real*8 z, ztrash
real*8, allocatable :: x_init

call readinput
call init
neq = 1 


! call allocation
allocate(pp(neq))

! print*,"kai calculation"

! call kai

x_init = 0.1 ! water volume fraction initial guess

if (infile.eq.1) then
  x_init = -dlog(bla)
  infile = 2
endif

if(flagsweep.eq.1)muwater = muwater_min
if(flagsweep.eq.2)muwater = muwater_max

mucounter_max = int((muwater_max - muwater_min)/muwater_step)

open(unit=1000,file="volfraction.dat")
open(unit=4000,file="system.dat")


write(4000,*)"interaction parameter = ",st
write(4000,*)"vol = ", vol
write(4000,*)"lseg = ", lseg
write(4000,*)"muwater min max step = ",muwater_min, muwater_max, muwater_step


do while (mucounter.le.mucounter_max)

  mucounter=mucounter+1

  iter=0

  print*,"Solving muwater = ", muwater


  call call_kinsol(x_init)
  
  write(1000,*)muwater, volumefraction

  x_init = -log(volumefraction)


  call free_energy

  if(flagsweep.eq.1)muwater = muwater + muwater_step
  if(flagsweep.eq.2)muwater = muwater - muwater_step
enddo ! muwater sweep

close(1000)
close(4000)


do i=1,11
  close(300+i)
enddo

end
