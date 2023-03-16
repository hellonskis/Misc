load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/usr/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
load "../shapefile_utils.ncl"

;*******************************************
begin
;*******************************************  

  f = addfile("rain_1961_2020.nc","r")

  tp   = f->tp(0,:,:)
  e    = f->e(0,:,:)
  ro   = f->ro(0,:,:)
  ssro = f->ssro(0,:,:)

;************************************************
; create plot
;************************************************
  
  wks                           = gsn_open_wks("pdf","prec_vars_plots")
; plot                          = new(1,graphic)
  axislabelstyle                = "panel"

  lat_min                       = -17.5
  lat_max                       = -9
  lon_min                       = 32
  lon_max                       = 36.5

  res                           = True
; res@gsnPanelCenter            = True
; res@gsnPanelTop               = 1.0
  res@gsnDraw                   = True
  res@gsnFrame                  = True 
  res@gsnMaximize               = True
  res@gsnAddCyclic              = False

  res@mpMinLatF                 = lat_min
  res@mpMaxLatF                 = lat_max
  res@mpMinLonF                 = lon_min
  res@mpMaxLonF                 = lon_max
  res@mpCenterLonF              = (res@mpMinLonF + res@mpMaxLonF) / 2.

  res@mpFillOn                  = False              ; Turn off gray fill
  res@cnFillOn                  = True               ; color Fill 
; res@cnFillMode                = "RasterFill"       ; Raster Mode
  res@cnLinesOn                 = False              ; Turn off contour lines
  res@cnMissingValFillPattern   = 0
  res@cnMissingValFillColor     = "Transparent"
; res@cnLevelSelectionMode      = "ExplicitLevels"   ; set explicit contour levels
; res@cnLevels                  = (//)
; res@cnFillPalette             = "MPL_RdYlBu"  
  res@cnFillPalette             = "MPL_Blues"

  res@mpDataBaseVersion         = "MediumRes"
  res@mpDataSetName             = "Earth..4"
  res@mpOutlineBoundarySets     = "National"         ; turn on country boundaries

  res@tiMainString              = "Average annual rainfall 1961-2020"
  plot  = gsn_csm_contour_map(wks,tp,res)
  res@tiMainString              = "Average annual evaporation 1961-2020"
  plot  = gsn_csm_contour_map(wks,e,res)
  res@tiMainString              = "Average annual surface runoff 1961-2020"
  plot  = gsn_csm_contour_map(wks,ro,res)
  res@tiMainString              = "Average annual subsurface runoff 1961-2020"
  plot  = gsn_csm_contour_map(wks,ssro,res)

;  resp                                  = True
;; resp@gsnPanelFigureStrings            = (/"Average annual rainfall 1961-2020"/)
;
;  resp@gsnPanelFigureStringsFontHeightF = 0.012
;  resp@amJust                           = "BottomRight"
;; resp@amOrthogonalPosF                 = 0.5
;  resp@gsnMaximize                      = True
;  resp@gsnPanelRowSpec                  = True

;  gsn_panel(wks,plot,(/1/),resp)

end
