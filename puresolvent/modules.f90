module mkinsol
implicit none
integer*8 neq
real*8, allocatable :: pp(:)

endmodule mkinsol

module mfkfun
implicit none
integer flagsweep
real*8 vol,st,lseg ! molecularproperties
integer*8 Xulimit ! vdw integration
real*8 Xu
real*8 volumefraction, bla ! volume fraction of beads
real*8 muwater, muwater_min, muwater_max, muwater_step ! chemical potential of water and polymer
real*8, parameter :: NA=6.02d23, Eps=0.114, Beta=1 ! Constants. Eps in units of  e^2/kT.nm
integer*8 iter, infile
endmodule mfkfun

