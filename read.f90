subroutine readinput

use mfkfun

implicit none

character nada
integer i,j

read(8,*) nada
read(8,*) rhopol_min, rhopol_max, rhopol_step

read(8,*) nada
read(8,*) Npoorsv

allocate(st(2+Npoorsv,2+Npoorsv),n(2+Npoorsv),n_read(2+Npoorsv),volumefraction(2+Npoorsv))

read(8,*) nada
read(8,*) nion
read(8,*) ntail
do i=3,Npoorsv
  read(8,*) n_read(i+2)
enddo

read(8,*) nada
read(8,*) vol
 
read(8,*) nada
read(8,*) lseg

read(8,*) nada
read(8,*) chi

read(8,*) nada
read(8,*) muwater_min, muwater_max, muwater_step

read(8,*) nada
read(8,*) Kas 

read(8,*) nada
read(8,*) perm_pol, perm_water

read(8,*) nada
read(8,*) infile

! read(8,*), nada
! read(8,*), flagkai 

! read(8,*), nada
! read(8,*), Xulimit 

read(8,*) nada
read(8,*) inputwater


read(8,*) nada
read(8,*) bla(1) ! initial guess for water volume fraction
read(8,*) bla(2) ! initial guess for charge fraction

open(file="epsilon.in",unit=10)

do i = 1,2+Npoorsv
read(10,*)(st(i,j), j = 1, i)
 do j = 1, i
    st(j,i) = st(i,j)
 enddo
enddo

end



