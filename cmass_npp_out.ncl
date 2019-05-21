load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

;*******************************************
begin
;*******************************************  

  f = "./LPJCtest_rcp45_125/out/anpp.out"
  g = "./LPJCtest_rcp45_125/out/cmass.out"
  h = "./LPJCtest_rcp85_125/out/anpp.out"
  i = "./LPJCtest_rcp85_125/out/cmass.out"

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
        if (data_cmass_rcp85(rr,0) .eq. lon(ln) .and. data_cmass_rcp85(rr,1) .eq. lat(lt))
          do tt=0, nyear-1
            if (data_cmass_rcp85(rr,2) .eq. (tt+1971))
              npp_rcp45_new(tt,lt,ln) = (/data_npp_rcp45(rr,3)/)
              npp_rcp85_new(tt,lt,ln) = (/data_npp_rcp85(rr,3)/)     
              cmass_rcp45_new(tt,lt,ln) = (/data_cmass_rcp45(rr,3)/)
              cmass_rcp85_new(tt,lt,ln) = (/data_cmass_rcp85(rr,3)/)
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

  print("making plot")

  ; Column 3
  NPP_C3GPAS_avg_rcp45 = dim_avg_n(npp_rcp45_new, (/1,2/))
  NPP_C3GPAS_avg_rcp85 = dim_avg_n(npp_rcp85_new, (/1,2/))
  CMASS_C3GPAS_avg_rcp45 = dim_avg_n(cmass_rcp45_new, (/1,2/))
  CMASS_C3GPAS_avg_rcp85 = dim_avg_n(cmass_rcp85_new, (/1,2/))

  ; Column 4
;  NPP_BEECH_avg_rcp45 = dim_avg_n(npp_rcp45_new, (/1,2/))
;  NPP_BEECH_avg_rcp85 = dim_avg_n(npp_rcp85_new, (/1,2/))
;  CMASS_BEECH_avg_rcp45 = dim_avg_n(cmass_rcp45_new, (/1,2/))
;  CMASS_BEECH_avg_rcp85 = dim_avg_n(cmass_rcp85_new, (/1,2/))

  ; Column 5
;  NPP_SPRUCE_avg_rcp45 = dim_avg_n(npp_rcp45_new, (/1,2/))
;  NPP_SPRUCE_avg_rcp85 = dim_avg_n(npp_rcp85_new, (/1,2/))
;  CMASS_SPRUCE_avg_rcp45 = dim_avg_n(cmass_rcp45_new, (/1,2/))
;  CMASS_SPRUCE_avg_rcp85 = dim_avg_n(cmass_rcp85_new, (/1,2/))

  ; Column 6
;  NPP_PINE_avg_rcp45 = dim_avg_n(npp_rcp45_new, (/1,2/))
;  NPP_PINE_avg_rcp85 = dim_avg_n(npp_rcp85_new, (/1,2/))
;  CMASS_PINE_avg_rcp45 = dim_avg_n(cmass_rcp45_new, (/1,2/))
;  CMASS_PINE_avg_rcp85 = dim_avg_n(cmass_rcp85_new, (/1,2/))

  ; Column 7
;  NPP_OAK_avg_rcp45 = dim_avg_n(npp_rcp45_new, (/1,2/))
;  NPP_OAK_avg_rcp85 = dim_avg_n(npp_rcp85_new, (/1,2/))
;  CMASS_OAK_avg_rcp45 = dim_avg_n(cmass_rcp45_new, (/1,2/))
;  CMASS_OAK_avg_rcp85 = dim_avg_n(cmass_rcp85_new, (/1,2/))

  ; Column 8
;  NPP_POPLAR_avg_rcp45 = dim_avg_n(npp_rcp45_new, (/1,2/))
;  NPP_POPLAR_avg_rcp85 = dim_avg_n(npp_rcp85_new, (/1,2/))
;  CMASS_POPLAR_avg_rcp45 = dim_avg_n(cmass_rcp45_new, (/1,2/))
;  CMASS_POPLAR_avg_rcp85 = dim_avg_n(cmass_rcp85_new, (/1,2/))

  data_npp_c3gpas = new((/2,dimsizes(NPP_C3GPAS_avg_rcp45)/),float)
  data_cmass_c3gpas = new((/2,dimsizes(CMASS_C3GPAS_avg_rcp45)/),float)
;  data_npp_beech = new((/2,dimsizes(NPP_BEECH_avg_rcp45)/),float)
;  data_cmass_beech = new((/2,dimsizes(CMASS_BEECH_avg_rcp45)/),float)
;  data_npp_spruce = new((/2,dimsizes(NPP_SPRUCE_avg_rcp45)/),float)
;  data_cmass_spruce = new((/2,dimsizes(CMASS_SPRUCE_avg_rcp45)/),float)
;  data_npp_pine = new((/2,dimsizes(NPP_PINE_avg_rcp45)/),float)
;  data_cmass_pine = new((/2,dimsizes(CMASS_PINE_avg_rcp45)/),float)
;  data_npp_oak = new((/2,dimsizes(NPP_OAK_avg_rcp45)/),float)
;  data_cmass_oak = new((/2,dimsizes(CMASS_OAK_avg_rcp45)/),float)
;  data_npp_poplar = new((/2,dimsizes(NPP_POPLAR_avg_rcp45)/),float)
;  data_cmass_poplar = new((/2,dimsizes(CMASS_POPLAR_avg_rcp45)/),float)

  data_npp_c3gpas(0,:) = NPP_C3GPAS_avg_rcp45
  data_npp_c3gpas(1,:) = NPP_C3GPAS_avg_rcp85
  data_cmass_c3gpas(0,:) = CMASS_C3GPAS_avg_rcp45
  data_cmass_c3gpas(1,:) = CMASS_C3GPAS_avg_rcp85
;  data_npp_beech(0,:) = NPP_BEECH_avg_rcp45
;  data_npp_beech(1,:) = NPP_BEECH_avg_rcp85
;  data_cmass_beech(0,:) = CMASS_BEECH_avg_rcp45
;  data_cmass_beech(1,:) = CMASS_BEECH_avg_rcp85
;  data_npp_spruce(0,:) = NPP_SPRUCE_avg_rcp45
;  data_npp_spruce(1,:) = NPP_SPRUCE_avg_rcp85
;  data_cmass_spruce(0,:) = CMASS_SPRUCE_avg_rcp45
;  data_cmass_spruce(1,:) = CMASS_SPRUCE_avg_rcp85
;  data_npp_pine(0,:) = NPP_PINE_avg_rcp45
;  data_npp_pine(1,:) = NPP_PINE_avg_rcp85
;  data_cmass_pine(0,:) = CMASS_PINE_avg_rcp45
;  data_cmass_pine(1,:) = CMASS_PINE_avg_rcp85
;  data_npp_oak(0,:) = NPP_OAK_avg_rcp45
;  data_npp_oak(1,:) = NPP_OAK_avg_rcp85
;  data_cmass_oak(0,:) = CMASS_OAK_avg_rcp45
;  data_cmass_oak(1,:) = CMASS_OAK_avg_rcp85
;  data_npp_poplar(0,:) = NPP_POPLAR_avg_rcp45
;  data_npp_poplar(1,:) = NPP_POPLAR_avg_rcp85
;  data_cmass_poplar(0,:) = CMASS_POPLAR_avg_rcp45
;  data_cmass_poplar(1,:) = CMASS_POPLAR_avg_rcp85

  time                       = ispan(1971,2100,1)

  wks                        = gsn_open_wks("pdf","C3GPas_CMASS_1971-2100_125")
  plot                       = new(2,graphic)
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

  plot(0)  = gsn_csm_xy(wks,time,data_npp_c3gpas,res)
  plot(1)  = gsn_csm_xy(wks,time,data_cmass_c3gpas,res)
;  plot(0)  = gsn_csm_xy(wks,time,data_npp_beech,res)
;  plot(1)  = gsn_csm_xy(wks,time,data_cmass_beech,res)
;  plot(0)  = gsn_csm_xy(wks,time,data_npp_spruce,res)
;  plot(1)  = gsn_csm_xy(wks,time,data_cmass_spruce,res)
;  plot(0)  = gsn_csm_xy(wks,time,data_npp_pine,res)
;  plot(1)  = gsn_csm_xy(wks,time,data_cmass_pine,res)
;  plot(0)  = gsn_csm_xy(wks,time,data_npp_oak,res)
;  plot(1)  = gsn_csm_xy(wks,time,data_cmass_oak,res)
;  plot(0)  = gsn_csm_xy(wks,time,data_npp_poplar,res)
;  plot(1)  = gsn_csm_xy(wks,time,data_cmass_poplar,res)

  resp                                  = True
  resp@txString                         = "~Z125~C3 Pasture Grass - statewide average 1971-2100"

  resp@gsnPanelFigureStrings            = (/"NPP (kgC/m~S~2~N~)","CMASS (kgC/m~S~2~N~)"/)

  resp@gsnPanelFigureStringsFontHeightF = 0.017
  resp@amJust                           = "BottomRight"
;  resp@amOrthogonalPosF                 = 0.5
  resp@gsnMaximize                      = True
  resp@gsnPanelRowSpec                  = True
  resp@gsnPaperOrientation              = "portrait"

  gsn_panel(wks,plot,(/1,1/),resp)

end


