load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/usr/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
load "../shapefile_utils.ncl"

;*******************************************
begin

  system("rm -rf precip_all.txt")
  system("rm -rf evap_all.txt")
  system("rm -rf runoff_all.txt")
  system("rm -rf ss_runoff_all.txt")

  years = (/"1957","1958","1959","1960","1961","1962","1963","1964","1965","1966", \
            "1967","1968","1969","1970","1971","1972","1973","1974","1975","1976", \
            "1977","1978","1979","1980","1981","1982","1983","1984","1985","1986", \
            "1987","1988","1989","1990","1991","1992","1993","1994","1995","1996", \
            "1997","1998","1999","2000","2001","2002","2003","2004","2005","2006", \
            "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016", \
            "2017","2018","2019","2020","2021"/)

  monthly_precip = (/"Year","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
  monthly_evap = (/"Year","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
  monthly_runoff = (/"Year","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
  monthly_ssrunoff = (/"Year","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)

  do y = 0, dimsizes(years)-1

    fpath = systemfunc("ls ./monthly_rain_"+years(y)+".nc")
    f     = addfile(fpath, "r")

    yr = (/years(y)/)
    monthly_precip(0) = tostring(yr)    
    year_colname = tostring(yr)+"_col"

    do m = 1, dimsizes(monthly_precip)-1

      precip = f->tp((m-1),:,:)
      avg_prec = (/tostring(avg(precip))/)
      monthly_precip(m) = avg_prec

      evap = f->e((m-1),:,:)
      avg_evap = (/tostring(avg(evap))/)
      monthly_evap(m) = avg_evap

      runoff = f->ro((m-1),:,:)
      avg_runoff = (/tostring(avg(runoff))/)
      monthly_runoff(m) = avg_runoff

      ssrunoff = f->ssro((m-1),:,:)
      avg_ssrunoff  = (/tostring(avg(ssrunoff))/)
      monthly_ssrunoff(m) = avg_ssrunoff

    end do

    write_table("precip_all.txt", "a", [/monthly_precip/], "%s")
    write_table("evap_all.txt", "a", [/monthly_evap/], "%s")
    write_table("runoff_all.txt", "a", [/monthly_runoff/], "%s")
    write_table("ss_runoff_all.txt", "a", [/monthly_ssrunoff/], "%s")

  end do

end
