load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"

;*******************************************
begin
;*******************************************  

  f = "/home/lsai/b7a/data/aresovsk/LPJCtest_Control/out/lai.out"
  g = "/home/lsai/b7a/data/aresovsk/LPJCtest_version1/out/lai.out"
  h = "/home/lsai/b7a/data/aresovsk/LPJCtest_version4/out/lai.out"
  i = "/home/lsai/b7a/data/aresovsk/LPJCtest_version5/out/lai.out"
  j = "/home/lsai/b7a/data/aresovsk/LPJCtest_version6/out/lai.out"
  k = "/home/lsai/b7a/data/aresovsk/LPJCtest_version7/out/lai.out"

  ncol = numAsciiCol(f)
  nrow = numAsciiRow(f) - 1   ; Ignore header row

  data_lai_control = readAsciiTable(f,ncol,"float",1)
  data_lai_vers1 = readAsciiTable(g,ncol,"float",1)
  data_lai_vers4 = readAsciiTable(h,ncol,"float",1)
  data_lai_vers5 = readAsciiTable(i,ncol,"float",1)
  data_lai_vers6 = readAsciiTable(j,ncol,"float",1)
  data_lai_vers7 = readAsciiTable(k,ncol,"float",1)

  year_count = count_unique_values(data_lai_control(:,2))
  nyear = year_count

  LAI_SPRUCE_1025_50_control = new((/nyear/),"float",0)
  LAI_SPRUCE_1025_50_vers1 = new((/nyear/),"float",0)
  LAI_SPRUCE_1025_50_vers4 = new((/nyear/),"float",0)
  LAI_SPRUCE_1025_50_vers5 = new((/nyear/),"float",0)
  LAI_SPRUCE_1025_50_vers6 = new((/nyear/),"float",0)
  LAI_SPRUCE_1025_50_vers7 = new((/nyear/),"float",0)

  do rr=0, nrow-1
    if (data_lai_control(rr,0) .eq. 10.25 .and. data_lai_control(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_lai_control(rr,2) .eq. (tt+1901))
          LAI_SPRUCE_1025_50_control(tt) = (/data_lai_control(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_lai_vers1(rr,0) .eq. 10.25 .and. data_lai_vers1(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_lai_vers1(rr,2) .eq. (tt+1901))
          LAI_SPRUCE_1025_50_vers1(tt) = (/data_lai_vers1(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_lai_vers4(rr,0) .eq. 10.25 .and. data_lai_vers4(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_lai_vers4(rr,2) .eq. (tt+1901))
          LAI_SPRUCE_1025_50_vers4(tt) = (/data_lai_vers4(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_lai_vers5(rr,0) .eq. 10.25 .and. data_lai_vers5(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_lai_vers5(rr,2) .eq. (tt+1901))
          LAI_SPRUCE_1025_50_vers5(tt) = (/data_lai_vers5(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_lai_vers6(rr,0) .eq. 10.25 .and. data_lai_vers6(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_lai_vers6(rr,2) .eq. (tt+1901))
          LAI_SPRUCE_1025_50_vers6(tt) = (/data_lai_vers6(rr,5)/)
        end if
      end do
    end if
  end do

  do rr=0, nrow-1
    if (data_lai_vers7(rr,0) .eq. 10.25 .and. data_lai_vers7(rr,1) .eq. 50.00)
      do tt=0, nyear-1
        if (data_lai_vers7(rr,2) .eq. (tt+1901))
          LAI_SPRUCE_1025_50_vers7(tt) = (/data_lai_vers7(rr,5)/)
        end if
      end do
    end if
  end do

  outname = "lai_out.nc"
  system("rm -rf "+outname)
  l = addfile(outname,"c")
  l->laicontrol = LAI_SPRUCE_1025_50_control
  l->laivers1 = LAI_SPRUCE_1025_50_vers1
  l->laivers4 = LAI_SPRUCE_1025_50_vers4
  l->laivers5 = LAI_SPRUCE_1025_50_vers5
  l->laivers6 = LAI_SPRUCE_1025_50_vers6
  l->laivers7 = LAI_SPRUCE_1025_50_vers7

end

