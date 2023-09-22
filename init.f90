subroutine init

use mfkfun

print*,"Program: Hydratedpolymer_0D"
print*,"GIT Version: ",_VERSION

n(1) = 1
n(2) = n(3) ! number of Cl- equal to N+

Xu = -2.961921959*lseg**3. ! vdw potential integral
print*,"lseg is set to ",lseg
print*,"Xu is set to ",Xu

end
