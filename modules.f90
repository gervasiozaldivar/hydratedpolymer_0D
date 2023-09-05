module mkinsol

integer*8 neq
real*8, allocatable :: pp(:)

endmodule mkinsol

module mfkfun

real*8 vol,st(4,4),lseg ! molecularproperties
integer*8 Xulimit ! vdw integration
integer*8 n(4)
real*8 Xu
real*8 rhopol_min, rhopol_max, rhopol_step, rho_pol  ! screening of number density of polymer 
real*8 volumefraction(4), volumefraction_total, freeClvolumefraction, bla ! volume fraction of beads
real*8 chargefraction, Kas ! Association equilibrium parameters
real*8 mupol, muwater ! chemical potential of water and polymer
real*8, parameter :: NA=6.02d23, Eps=0.114, Beta=1 ! Constants. Eps in units of  e^2/kT.nm
integer*8 iter, infile

endmodule mfkfun
