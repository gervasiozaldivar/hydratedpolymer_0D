subroutine init

use mfkfun

print*,"Program: Hydratedpolymer_0D"
print*,"GIT Version: ",_VERSION

n(1) = 1

Xu = -2.961921959*lseg**3. ! vdw potential integral
u_born = 136.771069 ! in kT units for monovalent ions
perm_water = 78.4

print*,"lseg is set to ",lseg
print*,"Xu is set to ",Xu

end
