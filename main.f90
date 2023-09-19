program elctrolyte

use mfkfun
use mkinsol

implicit none
integer i, j, counter,counter_max,mucounter,mucounter_max
! real*8 z, ztrash
real*8, allocatable :: x_init
! character*22, volfractionfilename
! character*13, mupolfilename
character*13, mupolfilename
character*19, volfractionfilename
character*21, fractionNplusfilename
character*14, systemfilename

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

muwater = muwater_min

mucounter_max = int((muwater_max - muwater_min)/muwater_step)
mucounter = 0

do while (mucounter.le.mucounter_max)

mucounter=mucounter+1



!! Water reservoir calculation !!

flagreservoir=0
iter=0
chargefraction=0.

print*,"Solving water reservoir (rho_pol=0)"

rho_pol = 0.

call call_kinsol(x_init)
call free_energy

print*,"Water reservoir solved"

flagreservoir=1

!! Rho_pol sweep !!

write(mupolfilename,'(A6,BZ,I3.3,A4)')'mupol.',mucounter,'.dat'
write(volfractionfilename,'(A12,BZ,I3.3,A4)')'volfraction.',mucounter,'.dat'
write(fractionNplusfilename,'(A14,BZ,I3.3,A4)')'fractionNplus.',mucounter,'.dat'
write(systemfilename,'(A7,BZ,I3.3,A4)')'system.',mucounter,'.dat'

open(unit=1000+mucounter,file=volfractionfilename)
open(unit=2000+mucounter,file=mupolfilename)
open(unit=3000+mucounter,file=fractionNplusfilename)
open(unit=4000+mucounter,file=systemfilename)

rho_pol = rhopol_min

counter = 0

counter_max = int( (rhopol_max - rhopol_min)/rhopol_step )

write(4000+mucounter,*)"rhopol_min   rhopol_max      rhopol_step"
write(4000+mucounter,*)rhopol_max,rhopol_max,rhopol_step
write(4000+mucounter,*)"interaction parameters"
write(4000+mucounter,*)st
write(4000+mucounter,*)"vol = ", vol
write(4000+mucounter,*)"lseg = ", lseg
write(4000+mucounter,*)"Number of beads (W,Cl,N,CH2) = ", n
write(4000+mucounter,*)"Kas = ",Kas


do while (counter.le.counter_max)

  iter=0
  counter=counter+1
  
  print*, "Solving rho_pol = ",rho_pol

  chargefraction = (1+4*n(3)*rho_pol*vol*Kas)**0.5-1
  chargefraction = chargefraction/(2*n(3)*rho_pol*vol*Kas)

  call call_kinsol(x_init)

  write(1000+mucounter,*)rho_pol, volumefraction(1), volumefraction(2), volumefraction(3), volumefraction(4), volumefraction_total
  write(2000+mucounter,*)rho_pol, mupol
  write(3000+mucounter,*)rho_pol, chargefraction

  x_init = -log(volumefraction(1))

  call free_energy

  rho_pol = rho_pol + rhopol_step
   
enddo ! rhopol sweep

close(1000+mucounter)
close(2000+mucounter)
close(3000+mucounter)
close(4000+mucounter)


muwater = muwater + muwater_step

enddo ! muwater sweep

do i=1,11
  close(300+i)
enddo

do i=1,4
do j=1,4
  close(10000*i+j)
enddo
enddo 

end
