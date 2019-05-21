load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

 f    = addfile("/home/lsai/b7a/data/ClimateData/EURO-CORDEX/test/prAdjust_EUR-11_MOHC-HadGEM2-ES_rcp85_r1i1p1_SMHI-RCA4_v1-IPSL-CDFT22-WFDEI-1979-2005_day_19710101-19801230.nc","r")
 lat  = f->lat(:,:)
 lon  = f->lon(:,:)
 rlat = f->rlat(:)
 rlon = f->rlon(:)
 prec = f->prAdjust(:,:,:)  

 prNew = new(

 nlat = dimsizes(rlat)
 nlon = dimsizes(rlon)

 printVarSummary(prec) 

; if(ch4w&longitude(0).lt. -170.0) then
;    ch4w = lonFlip(ch4w)
; end if

; lati = prec&rlat
; loni = prec&rlon

 printVarSummary(lati)

; g = addfile("/scratch/02668/aresovsk/ch45mod35_1980-2014/run/ch45mod25.clm2.h0.2001-04.nc" , "r")

; lato = g->lat
; lono = g->lon
; ar   = g->area
; frc  = g->landfrac
; msk  = g->landmask

 do i=0,nlat-1
    do j=0,nlon-1
       print(j)
       if(j.ne.i) then
          XX = 
       else
          landmask(i,j) = 0
       end if
    end do
 end do

 ncdf->lat      = (/ lat /)
 ncdf->lon      = (/ lon /)
 ncdf->landmask = (/ landmask /)

 ch4w1 = linint2 ( loni, lati, ch4w,True,lono, lato, 0)

 prec1!0="time"
 prec1!1="lat"
 prec1!2="lon"
 prec1&lat =lato
 prec1&lon =lono

 outname = "newPrec_1971-1980.nc"
 system("rm -rf "+outname)
 f = addfile(outname,"c")
 f->ch4w = ch4w1
 f->landmask = msk
 f->area = ar
 f->landfrac = frc
end

