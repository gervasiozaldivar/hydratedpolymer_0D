program elctrolyte

use mfkfun
use mkinsol

implicit none
integer i, j, counter,counter_max,mucounter,mucounter_max
! real*8 z, ztrash
real*8, allocatable :: x_init(:)
! character*22, volfractionfilename
! character*13, mupolfilename
character*13, mupolfilename
character*19, volfractionfilename
character*21, fractionNplusfilename
character*14, systemfilename

call readinput
call init
neq = 2


! call allocation
allocate(pp(neq))
allocate(x_init(neq))

! print*,"kai calculation"

! call kai

! x_init = 0.1 ! water volume fraction initial guess

! if (infile.eq.1) then
!  do i=1,ntot
!   read(8,*), bla
!   x_init = -dlog(bla)
!  enddo
!  infile = 2
!endif

muwater = muwater_min

mucounter_max = int((muwater_max - muwater_min)/muwater_step)
mucounter = 0

do while (mucounter.le.mucounter_max)

  mucounter=mucounter+1

  !! Water reservoir calculation !!

  flagreservoir=0
  iter=0
!  chargefraction=0.

  open(unit=986,file="rhosol_reservoir.dat")

  print*,"Solving water reservoir for muwater = ", muwater,". Initial guess is ",inputwater

  rho_pol = 0.
  n(2:2+Npoorsv)=0.
  
  x_init(1)=-log(inputwater) ! water volume fraction initial guess 
  x_init(2)=1e-5 ! charge fraction

  call call_kinsol(x_init)
  call free_energy

  print*,"Water reservoir solved"
  write(986,*)volumefraction(1)/vol
  close(986)
  flagreservoir=1

  x_init(1) = 0.1 ! default water volume fraction initial guess
  x_init(2) = 1e-5 ! default charge fraction initial guess

  if (infile.eq.1) then
  !  do i=1,ntot
  !   read(8,*), bla
     x_init(1) = -dlog(bla(1)) ! water volume fraction initial guess read from file
     x_init(2) = bla(2)
  !  enddo
    infile = 2
  endif


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
  n(2)=nion
  n(3)=nion
  n(4)=ntail

  do i=5,Npoorsv+2 
    n(i)=n_read(i)
  enddo
  
  counter = 0

  counter_max = int( (rhopol_max - rhopol_min)/rhopol_step )

  write(4000+mucounter,*)"GIT Version is ", _VERSION
  write(4000+mucounter,*)"muwater = ",muwater
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

    ! chargefraction = (1+4*n(3)*rho_pol*vol*Kas)**0.5-1 ! charge fraction initial guess
    ! chargefraction = chargefraction/(2*n(3)*rho_pol*vol*Kas) ! charge fraction initial guess

    call call_kinsol(x_init)

    write(1000+mucounter,*)rho_pol, volumefraction(1), volumefraction(2), volumefraction(3), volumefraction(4), volumefraction_total
    write(2000+mucounter,*)rho_pol, mupol
    write(3000+mucounter,*)rho_pol, chargefraction

    x_init(1) = -log(volumefraction(1))
    x_init(2) = chargefraction

    call free_energy

    rho_pol = rho_pol + rhopol_step
   
  enddo ! rhopol sweep

  close(1000+mucounter)
  close(2000+mucounter)
  close(3000+mucounter)
  close(4000+mucounter)


  muwater = muwater - muwater_step

enddo ! muwater sweep

do i=1,12
  close(300+i)
enddo

do i=1,2+Npoorsv
do j=1,2+Npoorsv
  close(10000*i+j)
enddo
enddo 

end
