load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

;*******************************************
begin
;*******************************************  

  f       = addfile("Temperature_025.nc","r")
 
  temp = f->temp(:,0)  
  gridcell = f->station
  lati = f->lat
  loni = f->lon
  npixels = (dimsizes(gridcell)) 
  gridindex = new((/dimsizes(gridcell),3/),"float",1e20)

  lat_array = count_unique_values(lati)
  lon_array = count_unique_values(loni)
  nlat = lat_array
  nlon = lon_array

  lat_new = new((/lat_array/),"float",0)
  lat_new@units = "degrees_north"
  lon_new = new((/lon_array/),"float",0)
  lon_new@units = "degrees_east"

  gridindex(0,0) = -10
  gridindex(0,1) = 35.5
  gridindex(0,2) = 0.0

  do pp=1, npixels-1
     gridindex(pp,0) = loni(pp) + 0.0001
     gridindex(pp,1) = lati(pp) + 0.0001
     gridindex(pp,2) = gridcell(pp)
  end do
 
  print(gridindex(0,0))
  print(gridindex(0,1))
  print(gridindex(0,2))
   
;  print(gridindex(pp,0))

  if(any(ismissing(gridindex))) then
    print("Your data contains some missing values. Beware.")
  end if  

  do lt=0, nlat-1
     lat_new(lt) = min(lati) + (((max(lati)-min(lati))/(lat_array-1))*lt)
  end do

  do ln=0, nlon-1
     lon_new(ln) = min(loni) + (((max(loni)-min(loni))/(lon_array-1))*ln)
  end do 

  tas = new((/nlat,nlon/),"float",0)
  tas!0="lat"
  tas!1="lon"
  tas&lat = lat_new
  tas&lon = lon_new

  outname = "tas_out.nc"
  system("rm -rf "+outname)
  h = addfile(outname,"c")
  h->tas = tas

  lat  = h->lat
  lon  = h->lon

  tas_new = h->tas(:,:)

;  if(ismissing(gridindex))

  nmsg = num(ismissing(gridindex))   ; count number of missing

  igood = ind(.not.ismissing(gridindex))
  xgood = x(igood)
  print(xgood)

  do lt=0, nlat-1
    do ln=0, nlon-1
      do pp=1, npixels-1
;        if(.not.ismissing(gridindex(pp,2)))
          if (gridindex(pp,0) .eq. lon(ln) .and. gridindex(pp,1) .eq. lat(lt))
            tas_new(lt,ln) = (/temp(pp)/)
          end if
;        end if
      end do
    end do
  end do

  h->tas = tas_new

;  npp1971_plot = h->npp1971
;  npp1971_plot@_FillValue = 1e20
;  npp2009_plot = h->npp2009
;  npp2009_plot@_FillValue = 1e20
;  cmass1971_plot = h->cmass1971
;  cmass1971_plot@_FillValue = 1e20
;  cmass2009_plot = h->cmass2009
;  cmass2009_plot@_FillValue = 1e20  

end


