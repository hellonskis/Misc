load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

;*******************************************
begin
;*******************************************  

  f = "./LPJCtest_rcp45npatch60/out/anpp.out"
  g = "./LPJCtest_rcp45npatch60/out/cmass.out"
  h = "./LPJCtest_rcp85npatch60/out/anpp.out"
  i = "./LPJCtest_rcp85npatch60/out/cmass.out" 

  ncol = numAsciiCol(f)
  nrow = numAsciiRow(f) - 1   ; Ignore header row

  data_npp_rcp45 = readAsciiTable(f,ncol,"float",1)
  data_cmass_rcp45 = readAsciiTable(g,ncol,"float",1)
  data_npp_rcp85 = readAsciiTable(h,ncol,"float",1)
  data_cmass_rcp85 = readAsciiTable(i,ncol,"float",1)

  lon_count = count_unique_values(data_npp_rcp45(:,0))
  lat_count = count_unique_values(data_npp_rcp45(:,1))
  year_count = count_unique_values(data_npp_rcp45(:,2))
  pft_count = round(10,3)      ; 10 PFTs

  nlon = lon_count
  nlat = lat_count
  nyear = year_count
  npft = pft_count
  lon_array = get_unique_values(data_npp_rcp45(:,0))
  lat_array = get_unique_values(data_npp_rcp45(:,1)) 

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

  npp_rcp45 = new((/nyear,nlat,nlon/),"float",0)
  npp_rcp45!0="time"
  npp_rcp45!1="lat"
  npp_rcp45!2="lon"
  npp_rcp45&lat = lat_new
  npp_rcp45&lon = lon_new

  cmass_rcp45 = new((/nyear,nlat,nlon/),"float",0)
  cmass_rcp45!0="time"
  cmass_rcp45!1="lat"
  cmass_rcp45!2="lon"
  cmass_rcp45&lat = lat_new
  cmass_rcp45&lon = lon_new

  npp_rcp85 = new((/nyear,nlat,nlon/),"float",0)
  npp_rcp85!0="time"
  npp_rcp85!1="lat"
  npp_rcp85!2="lon"
  npp_rcp85&lat = lat_new
  npp_rcp85&lon = lon_new

  cmass_rcp85 = new((/nyear,nlat,nlon/),"float",0)
  cmass_rcp85!0="time"
  cmass_rcp85!1="lat"
  cmass_rcp85!2="lon"
  cmass_rcp85&lat = lat_new
  cmass_rcp85&lon = lon_new

;********************************************************************************

  outname = "cmass_npp_out.nc"
  system("rm -rf "+outname)
  j = addfile(outname,"c")
  j->npp_rcp45 = npp_rcp45
  j->npp_rcp85 = npp_rcp85
  j->cmass_rcp45 = cmass_rcp45
  j->cmass_rcp85 = cmass_rcp85

  print("======Writing .nc output file======")

  lat = j->lat
  lon = j->lon

  npp_rcp45_new = j->npp_rcp45(:,:,:)
  npp_rcp85_new = j->npp_rcp85(:,:,:)
  cmass_rcp45_new = j->cmass_rcp45(:,:,:)
  cmass_rcp85_new = j->cmass_rcp85(:,:,:)

  do lt=0, nlat-1
    do ln=0, nlon-1
      do rr=0, nrow-1
        if (data_npp_rcp45(rr,0) .eq. lon(ln) .and. data_npp_rcp45(rr,1) .eq. lat(lt))
          do tt=0, nyear-1
            if (data_npp_rcp45(rr,2) .eq. (tt+1971))
              npp_rcp45_new(tt,lt,ln) = (/data_npp_rcp45(rr,5)/)
              npp_rcp85_new(tt,lt,ln) = (/data_npp_rcp85(rr,5)/)
              cmass_rcp45_new(tt,lt,ln) = (/data_cmass_rcp45(rr,5)/)    
              cmass_rcp85_new(tt,lt,ln) = (/data_cmass_rcp85(rr,5)/) 
            end if
          end do 
        end if
      end do
    end do
  end do

  j->npp_rcp45 = npp_rcp45_new
  j->npp_rcp85 = npp_rcp85_new
  j->cmass_rcp45 = cmass_rcp45_new
  j->cmass_rcp85 = cmass_rcp85_new

  print("done")
  print("creating plot")

  CMASS_SPRUCE_avg_rcp45 = dim_avg_n(cmass_rcp45_new, (/1,2/))
  CMASS_SPRUCE_avg_rcp85 = dim_avg_n(cmass_rcp85_new, (/1,2/))

;************************************************
; create plots
;************************************************

  data_cmass = new((/2,34/),float)

  data_cmass(0,:) = CMASS_SPRUCE_avg_rcp45
  data_cmass(1,:) = CMASS_SPRUCE_avg_rcp85

  print(data_cmass)

  time                       = ispan(1971,2004,1)

  wks                        = gsn_open_wks("pdf","PicAbi_CMASS_1971-2004")
  plot                       = new(1,graphic)
  axislabelstyle             = "panel"

  res                        = True
; res@gsnPanelCenter         = True
; res@gsnPanelTop            = 1.0
  res@trYMinF                = 8.68
  res@trYMaxF                = 9.98
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


  plot(0)  = gsn_csm_xy(wks,time,data_cmass,res)

  print("plotted")

  resp                                  = True
  resp@txString                         = "~Z150~Spruce - statewide average CMASS ~C~npatch=60"

  resp@gsnPanelFigureStrings            = (/""/)

  resp@gsnPanelFigureStringsFontHeightF = 0.017
  resp@amJust                           = "BottomRight"
;  resp@amOrthogonalPosF                 = 0.5
  resp@gsnMaximize                      = True
  resp@gsnPanelRowSpec                  = True
  resp@gsnPaperOrientation              = "portrait"

  gsn_panel(wks,plot,(/1/),resp)

end


