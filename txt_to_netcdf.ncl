load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

;*******************************************
begin
;*******************************************  

  f = "lai.out"
  
  ncol = numAsciiCol(f)
  nrow = numAsciiRow(f) - 1   ; Ignore header row

  data_lai = readAsciiTable(f,ncol,"float",1)

  lon_count = count_unique_values(data_lai(:,0))
  lat_count = count_unique_values(data_lai(:,1))
  year_count = count_unique_values(data_lai(:,2))
  pft_count = round(10,3)                          ; 10 PFTs

  start_year = 1901

  nlon = lon_count
  nlat = lat_count
  nyears = year_count
  npft = pft_count
  lon_array = get_unique_values(data_lai(:,0))
  lat_array = get_unique_values(data_lai(:,1)) 

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

; PFT column indices:

  C3G_pas = 3 
  Fag_syl = 4 
  Pic_abi = 5 
  Pin_syl = 6 
  Que_rob = 7 
  Pop_tre = 8  
  CC3ann  = 9 
  CC3nfx  = 10 
  CC4ann  = 11 
  BEC4G   = 12 

;********************Define nc file variables*******************

  C3GPas = new((/nyears,nlat,nlon/),"float",0)
  C3GPas!0="time"
  C3GPas!1="lat"
  C3GPas!2="lon"
  C3GPas&lat = lat_new
  C3GPas&lon = lon_new

  outname = "lai.nc"
  system("rm -rf "+outname)
  g = addfile(outname,"c")
  g->C3GPas = C3GPas  

  print("======Writing .nc output file======")

  lat = g->lat
  lon = g->lon

  C3GPas_lai = g->C3GPas(:,:,:)

  do lt=0, nlat-1
    do ln=0, nlon-1
      do rr=0, nrow-1
        if (data_lai(rr,0) .eq. lon(ln) .and. data_lai(rr,1) .eq. lat(lt))
          do tt=0, nyears-1
            if (data_lai(rr,2) .eq. (tt+start_year))
              C3GPas_lai(tt,lt,ln) = (/data_lai(rr,C3G_pas)/)
            end if
          end do        
        end if
      end do
    end do 
  end do

  g->C3GPas = C3GPas_lai

end


