module mkinsol
implicit none
integer*8 neq
real*8, allocatable :: pp(:)

endmodule mkinsol

module mfkfun
implicit none
real*8 vol,lseg !st(2+Npoorsv,2+Npoorsv) ! molecularproperties
real*8,allocatable :: st(:,:)
integer*8 Xulimit ! vdw integration
integer*8 ntail,nion,Npoorsv
integer*8,allocatable :: n(:),n_read(:)
real*8 Xu
real*8 rhopol_min, rhopol_max, rhopol_step, rho_pol  ! screening of number density of polymer 
real*8 volumefraction_total, freeClvolumefraction, bla(2) ,inputwater ! volume fraction of beads
real*8,allocatable :: volumefraction(:)
real*8 chargefraction, chargefraction_new, Kas,Kas_corr ! Association equilibrium parameters
real*8 mupol, muwater, muwater_min, muwater_max, muwater_step ! chemical potential of water and polymer
real*8, parameter :: NA=6.02d23, Eps=0.114, Beta=1 ! Constants. Eps in units of  e^2/kT.nm
integer*8 iter, infile
integer flagreservoir
real*8 u_born, perm_water, perm_pol, perm, u_self ! Born energy variables

endmodule mfkfun

module Reservoir
real*8 F_reservoir, F_mix_reservoir, F_vdw_reservoir, F_HS_reservoir, Nmuwater_reservoir,rhosol_reservoir, Fborn_reservoir
endmodule
