load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

;*******************************************
begin
;*******************************************  

  f = "/home/lsai/b7a/data/aresovsk/LPJCtest_Control/out/cmass.out"
  g = "/home/lsai/b7a/data/aresovsk/LPJCtest_version1/out/cmass.out"
  h = "/home/lsai/b7a/data/aresovsk/LPJCtest_version4/out/cmass.out"
  i = "/home/lsai/b7a/data/aresovsk/LPJCtest_version5/out/cmass.out"
  j = "/home/lsai/b7a/data/aresovsk/LPJCtest_version6/out/cmass.out"
  k = "/home/lsai/b7a/data/aresovsk/LPJCtest_version7/out/cmass.out"
  l = "/home/lsai/b7a/data/aresovsk/LPJCtest_version9/out/cmass.out"

  ncol = numAsciiCol(f)
  nrow = numAsciiRow(f) - 1   ; Ignore header row

  data_cmass_control = readAsciiTable(f,ncol,"float",1)
  data_cmass_vers1 = readAsciiTable(g,ncol,"float",1)
  data_cmass_vers4 = readAsciiTable(h,ncol,"float",1)
  data_cmass_vers5 = readAsciiTable(i,ncol,"float",1)
  data_cmass_vers6 = readAsciiTable(j,ncol,"float",1)
  data_cmass_vers7 = readAsciiTable(k,ncol,"float",1)
  data_cmass_vers9 = readAsciiTable(l,ncol,"float",1)

  year_count = count_unique_values(data_cmass_control(:,2))
  nyear = year_count

  CMASS_SPRUCE_1025_50_control = new((/nyear/),"float",0)
  CMASS_SPRUCE_1025_50_vers1 = new((/nyear/),"float",0)
  CMASS_SPRUCE_1025_50_vers4 = new((/nyear/),"float",0)
  CMASS_SPRUCE_1025_50_vers5 = new((/nyear/),"float",0)
  CMASS_SPRUCE_1025_50_vers6 = new((/nyear/),"float",0)
  CMASS_SPRUCE_1025_50_vers7 = new((/nyear/),"float",0)
  CMASS_SPRUCE_1025_50_vers9 = new((/nyear/),"float",0)

  do rr=0, nrow-1
    if (data_cmass_control(rr,0) .eq. 10.25 .and. data_cmass_control(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_cmass_control(rr,2) .eq. (tt+1901))
          CMASS_SPRUCE_1025_50_control(tt) = (/data_cmass_control(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_cmass_vers1(rr,0) .eq. 10.25 .and. data_cmass_vers1(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_cmass_vers1(rr,2) .eq. (tt+1901))
          CMASS_SPRUCE_1025_50_vers1(tt) = (/data_cmass_vers1(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_cmass_vers4(rr,0) .eq. 10.25 .and. data_cmass_vers4(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_cmass_vers4(rr,2) .eq. (tt+1901))
          CMASS_SPRUCE_1025_50_vers4(tt) = (/data_cmass_vers4(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_cmass_vers5(rr,0) .eq. 10.25 .and. data_cmass_vers5(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_cmass_vers5(rr,2) .eq. (tt+1901))
          CMASS_SPRUCE_1025_50_vers5(tt) = (/data_cmass_vers5(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_cmass_vers6(rr,0) .eq. 10.25 .and. data_cmass_vers6(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_cmass_vers6(rr,2) .eq. (tt+1901))
          CMASS_SPRUCE_1025_50_vers6(tt) = (/data_cmass_vers6(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_cmass_vers7(rr,0) .eq. 10.25 .and. data_cmass_vers7(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_cmass_vers7(rr,2) .eq. (tt+1901))
          CMASS_SPRUCE_1025_50_vers7(tt) = (/data_cmass_vers7(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_cmass_vers9(rr,0) .eq. 10.25 .and. data_cmass_vers9(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_cmass_vers9(rr,2) .eq. (tt+1901))
          CMASS_SPRUCE_1025_50_vers9(tt) = (/data_cmass_vers9(rr,5)/)
        end if
      end do
    end if
  end do

  outname = "cmass.nc"
  system("rm -rf "+outname)
  m = addfile(outname,"c")
  m->cmasscontrol = CMASS_SPRUCE_1025_50_control
  m->cmassvers1 = CMASS_SPRUCE_1025_50_vers1
  m->cmassvers4 = CMASS_SPRUCE_1025_50_vers4
  m->cmassvers5 = CMASS_SPRUCE_1025_50_vers5
  m->cmassvers6 = CMASS_SPRUCE_1025_50_vers6
  m->cmassvers7 = CMASS_SPRUCE_1025_50_vers7
  m->cmassvers9 = CMASS_SPRUCE_1025_50_vers9

end

