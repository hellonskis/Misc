load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/usr/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

;*******************************************
begin
;*******************************************  

  f = addfile("monthly_tas_Bayern_2001-2010.nc","r")     ; monthly bias-corrected surface air temperature

;****************************************************************************************************
;************************ Write regridded tas file **************************************************

  tas  = f->tas(:,:,:)
  lati = f->lat
  loni = f->lon
  time = f->time

  dsizes_x = dimsizes(lati)
  nlat     = dsizes_x(0)
  nlon     = dsizes_x(1)
  ntime    = dimsizes(time)

  lat_new = new((/nlat/),"double",0)
  lat_new@units = "degrees_north"
  lat_new@standard_name = "latitude"
  lat_new@long_name = "latitude"
  lon_new = new((/nlon/),"double",0)
  lon_new@units = "degrees_east"
  lon_new@standard_name = "longitude"
  lon_new@long_name = "longitude"
  time_new = new((/(ntime)/),"double",0)
  time_new@units = "days since 1971-01-01"

  do lt=0, nlat-1
     lat_new(lt) = min(lati) + (((max(lati)-min(lati))/(nlat-1))*lt)
  end do
  do ln=0, nlon-1
     lon_new(ln) = min(loni) + (((max(loni)-min(loni))/(nlon-1))*ln)
  end do

  min_lat = 47.25
  max_lat = 50.5
  min_lon = 9
  max_lon = 13.75
  nnlat = round((((max_lat - min_lat)/.25) + 1),3)
  nnlon = round((((max_lon - min_lon)/.25) + 1),3)

  lat_regrid = new((/nnlat/),"double",0)
  lat_regrid@units = "degrees_north"
  lat_regrid@standard_name = "latitude"
  lat_regrid@long_name = "latitude"
  lon_regrid = new((/nnlon/),"double",0)
  lon_regrid@units = "degrees_east"
  lon_regrid@standard_name = "longitude"
  lon_regrid@long_name = "longitude"

  do lt=0, nnlat-1
     lat_regrid(lt) = min_lat + (.25*lt)
  end do
  do ln=0, nnlon-1
     lon_regrid(ln) = min_lon + (.25*ln)
  end do     
   
  do tt=0, ntime-1
     time_new(tt) = time(tt)
  end do

  tasNew = new((/ntime,nlat,nlon/),"double",0)
  tasNew!0="time"
  tasNew!1="lat"
  tasNew!2="lon"
  tasNew&time = time_new
  tasNew&lat = lat_new
  tasNew&lon = lon_new
  tasNew@standard_name = "air_temperature"
  tasNew@long_name = "near-surface temperature"
  tasNew@units = "degrees celsius"
  tasNew@_FillValue = default_fillvalue("double")
  tasNew@coordinates = "lat lon"

  tasInterp = new((/ntime,nnlat,nnlon/),"double",0)
  tasInterp!0="time"
  tasInterp!1="lat"
  tasInterp!2="lon"
  tasInterp&time = time_new
  tasInterp&lat = lat_regrid
  tasInterp&lon = lon_regrid
  tasInterp@standard_name = "air_temperature"
  tasInterp@long_name = "near-surface temperature"
  tasInterp@units = "degrees celsius"
  tasInterp@_FillValue = default_fillvalue("double")
  tasInterp@coordinates = "lat lon"

  outname = "tas_out.nc"
  system("rm -rf "+outname)
  g = addfile(outname,"c")
  g->tas = tasNew

  outname = "tasBayern01012001_12312010_025_out.nc"
  system("rm -rf "+outname)
  h = addfile(outname,"c")
  h->tas = tasInterp

  print("Writing tas file...")

  tas_new = g->tas(:,:,:)

  do tt=0, ntime-1
    do lt=0, nlat-1
      do ln=0, nlon-1
        if (.not.ismissing(tas(tt,lt,ln)))
          tas_new(tt,lt,ln) = (/tas(tt,lt,ln)/)
        end if
      end do
    end do
  end do

  g->tas = tas_new

  print("tas file written")
  print("regridding...")

  SrcGrid     = addfile("tas_out.nc","r")
  tas_source  = SrcGrid->tas
  DstGrid     = addfile("tasBayern01012001_12312010_025_out.nc","r")
  lat_dst     = DstGrid->lat
  lon_dst     = DstGrid->lon

  Opt                = True
  Opt@SrcFileName    = "src_SCRIP.nc"
  Opt@DstFileName    = "dst_SCRIP.nc"
  Opt@WgtFileName    = "NCEP_2_Rect.nc"
  Opt@DstGridLat     = lat_dst
  Opt@DstGridLon     = lon_dst
  Opt@ForceOverwrite = True
  Opt@SrcGridMask    = where(.not.ismissing(tas_source(0,:,:)),1,0)
  Opt@InterpMethod   = "neareststod"

  tas_regrid = ESMF_regrid(tas_source,Opt)
; tas_regrid@_FillValue = 1e20
  printVarSummary(tas_regrid)

  h->tas = tas_regrid

  print("done")
 
end


