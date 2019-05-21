load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

;*******************************************
begin
;*******************************************  

  f = "./LPJCtest_rcp45npatch30/out/seasonality.out"
  g = "./LPJCtest_rcp85npatch30/out/seasonality.out"

  ncol = numAsciiCol(f)
  nrow = numAsciiRow(f) - 1   ; Ignore header row

  data_prec_rcp45 = readAsciiTable(f,ncol,"float",1)
  data_prec_rcp85 = readAsciiTable(g,ncol,"float",1)

  lon_count = count_unique_values(data_prec_rcp45(:,0))
  lat_count = count_unique_values(data_prec_rcp45(:,1))
  year_count = count_unique_values(data_prec_rcp45(:,2))
  pft_count = round(10,3)      ; 10 PFTs

  nlon = lon_count
  nlat = lat_count
  nyear = year_count
  npft = pft_count
  lon_array = get_unique_values(data_prec_rcp45(:,0))
  lat_array = get_unique_values(data_prec_rcp45(:,1)) 

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

  prec_rcp45 = new((/nyear,nlat,nlon/),"float",0)
  prec_rcp45!0="time"
  prec_rcp45!1="lat"
  prec_rcp45!2="lon"
  prec_rcp45&lat = lat_new
  prec_rcp45&lon = lon_new

  prec_rcp85 = new((/nyear,nlat,nlon/),"float",0)
  prec_rcp85!0="time"
  prec_rcp85!1="lat"
  prec_rcp85!2="lon"
  prec_rcp85&lat = lat_new
  prec_rcp85&lon = lon_new

  temp_rcp45 = new((/nyear,nlat,nlon/),"float",0)
  temp_rcp45!0="time"
  temp_rcp45!1="lat"
  temp_rcp45!2="lon"
  temp_rcp45&lat = lat_new
  temp_rcp45&lon = lon_new
 
  temp_rcp85 = new((/nyear,nlat,nlon/),"float",0)
  temp_rcp85!0="time"
  temp_rcp85!1="lat"
  temp_rcp85!2="lon"
  temp_rcp85&lat = lat_new
  temp_rcp85&lon = lon_new

  outname = "prec_out.nc"
  system("rm -rf "+outname)
  h = addfile(outname,"c")
  h->prec_rcp45 = prec_rcp45
  h->prec_rcp85 = prec_rcp85
  h->temp_rcp45 = temp_rcp45
  h->temp_rcp85 = temp_rcp85

  print("======Writing .nc output file======")

  lat = h->lat
  lon = h->lon

  prec_rcp45_new = h->prec_rcp45(:,:,:)
  prec_rcp85_new = h->prec_rcp85(:,:,:)
  temp_rcp45_new = h->temp_rcp45(:,:,:)
  temp_rcp85_new = h->temp_rcp85(:,:,:)

  do lt=0, nlat-1
    do ln=0, nlon-1
      do rr=0, nrow-1
        if (data_prec_rcp45(rr,0) .eq. lon(ln) .and. data_prec_rcp45(rr,1) .eq. lat(lt))
          do tt=0, nyear-1
            if (data_prec_rcp45(rr,2) .eq. (tt+1971))
              prec_rcp45_new(tt,lt,ln) = (/data_prec_rcp45(rr,10)/)
              prec_rcp85_new(tt,lt,ln) = (/data_prec_rcp85(rr,10)/)
              temp_rcp45_new(tt,lt,ln) = (/data_prec_rcp45(rr,7)/)
              temp_rcp85_new(tt,lt,ln) = (/data_prec_rcp85(rr,7)/)
            end if
          end do
        end if
      end do
    end do
  end do

  h->prec_rcp45 = prec_rcp45_new
  h->prec_rcp85 = prec_rcp85_new
  h->temp_rcp45 = temp_rcp45_new
  h->temp_rcp85 = temp_rcp85_new

  prec_avg_rcp45 = dim_avg_n(prec_rcp45_new, (/1,2/))
  prec_avg_rcp85 = dim_avg_n(prec_rcp85_new, (/1,2/))
  temp_avg_rcp45 = dim_avg_n(temp_rcp45_new, (/1,2/))
  temp_avg_rcp85 = dim_avg_n(temp_rcp85_new, (/1,2/))

  data_prec = new((/2,dimsizes(prec_avg_rcp45)/),float)
  data_temp = new((/2,dimsizes(temp_avg_rcp45)/),float)

  data_prec(0,:) = prec_avg_rcp45
  data_prec(1,:) = prec_avg_rcp85  
  data_temp(0,:) = temp_avg_rcp45
  data_temp(1,:) = temp_avg_rcp85

;***********************************************************************************************8

  time                       = ispan(1971,2004,1)

  wks                        = gsn_open_wks("pdf","temp_1971-2004_npatch30")
  plot                       = new(1,graphic)
  axislabelstyle             = "panel"

  res                        = True
; res@gsnPanelCenter         = True
; res@gsnPanelTop            = 1.0
;  res@trYMinF                = 8.7
;  res@trYMaxF                = 10.0
  res@xyLineColors           = (/"purple","green"/)
  res@xyDashPattern          = 0.0
  res@pmLegendDisplayMode    = "Always"
  res@pmLegendParallelPosF   = 0.82                  ; move units right
  res@pmLegendOrthogonalPosF = -1.09                ; move units down
  res@pmLegendWidthF         = 0.22                ; Change width and
  res@pmLegendHeightF        = 0.08                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .014                 ; label font height
  res@xyExplicitLegendLabels = (/"rcp45","rcp85"/)         ; create explicit labels
  res@lgItemOrder            = (/0,1/)   ; Reorder the legends
  res@gsnDraw                = False
  res@gsnFrame               = False
  res@gsnMaximize            = True

  plot(0)  = gsn_csm_xy(wks,time,data_temp,res)

  resp                                  = True
  resp@txString                         = "~Z125~Mean annual temp - statewide average (mm)"

  resp@gsnPanelFigureStrings            = (/""/)

  resp@gsnPanelFigureStringsFontHeightF = 0.017
  resp@amJust                           = "BottomRight"
;  resp@amOrthogonalPosF                 = 0.5
  resp@gsnMaximize                      = True
  resp@gsnPanelRowSpec                  = True
  resp@gsnPaperOrientation              = "portrait"

  gsn_panel(wks,plot,(/1/),resp)

end


