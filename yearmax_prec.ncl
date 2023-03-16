load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/usr/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
load "../shapefile_utils.ncl"

;*******************************************
begin

  system("rm -rf max_precip.txt")

  years = (/"1957","1958","1959","1960","1961","1962","1963","1964","1965","1966", \
            "1967","1968","1969","1970","1971","1972","1973","1974","1975","1976", \
            "1977","1978","1979","1980","1981","1982","1983","1984","1985","1986", \
            "1987","1988","1989","1990","1991","1992","1993","1994","1995","1996", \
            "1997","1998","1999","2000","2001","2002","2003","2004","2005","2006", \
            "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016", \
            "2017","2018","2019","2020","2021"/)

  max_precip = (/"Year","Date","max_prec(m)","surface_runoff(m)","ss_runoff(m)"/)
  write_table("max_precip.txt", "a", [/max_precip/], "%s")

  time = new((/365/),"integer",0)
  rain_total = new((/dimsizes(time)/),"float",0)

  do y = 0, dimsizes(years)-1

    fpath = systemfunc("ls ./daily_rain_"+years(y)+"_masked.nc")
    f     = addfile(fpath, "r")
    year  = tostring(years(y))

    delete(time)
    delete(rain_total)
    time  = f->time
    rain_total = new((/dimsizes(time)/),"float",0)

    do tt = 0, dimsizes(time)-1
      rainavg = tofloat(avg(f->tp(tt,:,:)))
      rain_total(tt) = rainavg
    end do

    precmax = max(rain_total)
    doy = maxind(rain_total)+1 
    print(doy)   
    doy_str = where(doy.lt.100, where(doy.lt.10, tostring("00"+tostring(doy)), tostring("0"+tostring(doy))), tostring(doy))
    print(doy_str)
    yeardoy = toint(tostring(year+doy_str))
    print(yeardoy)
    date = tostring(yyyyddd_to_yyyymmdd(yeardoy))
    print(date)

    precmax_vars = new((/dimsizes(max_precip)/),"string",0)
    precmax_vars = year
    precmax_vars(1) = date
    precmax_vars(2) = precmax
    precmax_vars(3) = tofloat(avg(f->ro(doy-1,:,:)))
    precmax_vars(4) = tofloat(avg(f->ssro(doy-1,:,:)))

    write_table("max_precip.txt", "a", [/precmax_vars/], "%s")

  end do

end
