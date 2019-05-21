load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

;*******************************************
begin
;*******************************************  

  f = "./LPJCtest_rcp45_125/out/yield.out"
  g = "./LPJCtest_rcp85_125/out/yield.out"

  ncol = numAsciiCol(f)
  nrow = numAsciiRow(f) - 1   ; Ignore header row

  data_yield_rcp45 = readAsciiTable(f,ncol,"float",1)
  data_yield_rcp85 = readAsciiTable(g,ncol,"float",1)

  lon_count = count_unique_values(data_yield_rcp45(:,0))
  lat_count = count_unique_values(data_yield_rcp45(:,1))
  year_count = count_unique_values(data_yield_rcp45(:,2))

  nlon = lon_count
  nlat = lat_count
  nyear = year_count
  lon_array = get_unique_values(data_yield_rcp45(:,0))
  lat_array = get_unique_values(data_yield_rcp45(:,1)) 

  min_lat = min(lat_array)
  max_lat = max(lat_array)
  min_lon = min(lon_array)
  max_lon = max(lon_array)

  lat_new = new((/lat_count/),"float",0)
  lat_new@units = "degrees_north"
  lon_new = new((/lon_count/),"float",0)
  lon_new@units = "degrees_east"

  do lt=0, nlat-1
    lat_new(lt) = lat_array(lt)
  end do
 
  do ln=0, nlon-1
    lon_new(ln) = lon_array(ln)
  end do 

;********************Define variables to plot*******************

  yield = new((/nyear,nlat,nlon/),"float",0)
  yield!0="time"
  yield!1="lat"
  yield!2="lon"
  yield&lat = lat_new
  yield&lon = lon_new

  outname = "CC3ann_yield_out.nc"
  system("rm -rf "+outname) 
  h = addfile(outname,"c")
  h->yield_rcp45 = yield
  h->yield_rcp85 = yield 

  outname = "CC3nfx_yield_out.nc"
  system("rm -rf "+outname)
  i = addfile(outname,"c")
  i->yield_rcp45 = yield
  i->yield_rcp85 = yield

  outname = "CC4ann_yield_out.nc"
  system("rm -rf "+outname)
  j = addfile(outname,"c")
  j->yield_rcp45 = yield
  j->yield_rcp85 = yield

  outname = "BEC4G_yield_out.nc"
  system("rm -rf "+outname)
  k = addfile(outname,"c")
  k->yield_rcp45 = yield
  k->yield_rcp85 = yield

  print("======Writing .nc output file======")

  yield_CC3ann_rcp45_new = h->yield_rcp45(:,:,:)
  yield_CC3ann_rcp85_new = h->yield_rcp85(:,:,:)
  yield_CC3nfx_rcp45_new = i->yield_rcp45(:,:,:)
  yield_CC3nfx_rcp85_new = i->yield_rcp85(:,:,:)
  yield_CC4ann_rcp45_new = j->yield_rcp45(:,:,:)
  yield_CC4ann_rcp85_new = j->yield_rcp85(:,:,:)
  yield_BEC4G_rcp45_new  = k->yield_rcp45(:,:,:)
  yield_BEC4G_rcp85_new  = k->yield_rcp85(:,:,:)

  lat = h->lat
  lon = h->lon

  do lt=0, nlat-1
    do ln=0, nlon-1
      do rr=0, nrow-1
        if (data_yield_rcp85(rr,0) .eq. lon(ln) .and. data_yield_rcp85(rr,1) .eq. lat(lt))
          do tt=0, nyear-1
            if (data_yield_rcp85(rr,2) .eq. (tt+1971))
              yield_CC3ann_rcp45_new(tt,lt,ln) = (/data_yield_rcp45(rr,3)/)
              yield_CC3ann_rcp85_new(tt,lt,ln) = (/data_yield_rcp85(rr,3)/)
              yield_CC3nfx_rcp45_new(tt,lt,ln) = (/data_yield_rcp45(rr,4)/) 
              yield_CC3nfx_rcp85_new(tt,lt,ln) = (/data_yield_rcp85(rr,4)/)
              yield_CC4ann_rcp45_new(tt,lt,ln) = (/data_yield_rcp45(rr,5)/)
              yield_CC4ann_rcp85_new(tt,lt,ln) = (/data_yield_rcp85(rr,5)/)              
              yield_BEC4G_rcp45_new(tt,lt,ln) = (/data_yield_rcp45(rr,6)/)
              yield_BEC4G_rcp85_new(tt,lt,ln) = (/data_yield_rcp85(rr,6)/)
            end if
          end do
        end if
      end do
    end do
  end do

  h->yield_rcp45 = yield_CC3ann_rcp45_new
  h->yield_rcp85 = yield_CC3ann_rcp85_new
  i->yield_rcp45 = yield_CC3nfx_rcp45_new
  i->yield_rcp85 = yield_CC3nfx_rcp85_new
  j->yield_rcp45 = yield_CC4ann_rcp45_new
  j->yield_rcp85 = yield_CC4ann_rcp85_new
  k->yield_rcp45 = yield_BEC4G_rcp45_new
  k->yield_rcp85 = yield_BEC4G_rcp85_new

end


