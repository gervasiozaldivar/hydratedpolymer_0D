subroutine readinput

use mfkfun

character nada

read(8,*), nada
read(8,*), rhopol_min, rhopol_max, rhopol_step

read(8,*), nada
read(8,*), n(3),n(4)

read(8,*), nada
read(8,*), vol
 
read(8,*), nada
read(8,*), lseg

read(8,*), nada
read(8,*), muwater

read(8,*), nada
read(8,*), Kas 

read(8,*), nada
read(8,*), infile

! read(8,*), nada
! read(8,*), flagkai 

! read(8,*), nada
! read(8,*), Xulimit 

read(8,*), nada
read(8,*), bla ! initial guess for water volume fraction


open(file="epsilon.in",unit=10)

do i = 1,4
read(10,*)(st(i,j), j = 1, i)
 do j = 1, i
    st(j,i) = st(i,j)
 enddo
enddo

end



