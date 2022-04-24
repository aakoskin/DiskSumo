   10 goto 8900
  100 rem --dump disk to rs232--
  110 m=fre(0):m=24576:t=1:s=0:b%=1
  120 open 15,8,15
  130 open 5,8,5,"#"
  160 gosub 8000: rem setup display
  165 print "{home}{grn}ready. start xmodem on other computer";
  170 get#4,a$: if a$<>chr$(nak%) then 170
  175 print "{home}                                      ";
  180 be=ti
  200 for t=1 to 35
  210 gosub 500: rem calc max sec
  220 gosub 800: rem read track
  230 gosub 700: rem send track
  240 next
  300 print#4, chr$(eot%);
  310 mi=(ti-5184e3*(ti<be)-be)/3600
  320 print "{clr}";mi;"minutes elapsed"
  330 close 15: close 5
  340 return
  400 rem --update display--
  405 poke 55296+(t-1)+40*(s+1), co%
  410 poke 1024+(t-1)+40*(s+1), sy%
  420 return
  500 rem --calc max sec# for trk#t--
  510 if t<=17 then ms%=20: return
  520 if t<=24 then ms%=18: return
  530 if t<=30 then ms%=17: return
  540 ms%=16: return
  700 rem --send trk--
  710 for s=0 to ms%
  720 co%=4:sy%=87: gosub 400
  730 mo=m+s*256: gosub 2000: rem send 1st
  740 co%=10:sy%=87: gosub 400
  750 mo=mo+128: gosub 2000: rem send 2nd
  760 co%=5:sy%=81: gosub 400
  770 next
  799 return
  800 rem ---read trk into m---
  810 gosub 500: rem calc max sec in ms%
  820 for s=0 to ms%
  830 mo=m+s*256: gosub 1000
  840 co%=7:sy%=90: gosub 400
  850 next
  899 return
 1000 rem ---read sec#s, trk#t into mo---
 1010 print#15,"u1";5;0;t;s
 1020 for i=mo to mo+255
 1030 get#5,a$
 1035 if a$="" then a$=chr$(0)
 1040 poke i, asc(a$)
 1050 next
 1060 return
 2000 rem ---send 128 bytes at mo to rs232---
 2005 ck%=0
 2007 print "{home}{yel}b";b%;"{left}      {left}{left}{left}{left}{left}";
 2010 print#4, chr$(soh%);chr$(b%);chr$(255-b%);
 2020 for i=mo to mo+127
 2025 y%=peek(i)
 2030 print#4, chr$(y%);
 2035 ck%=(ck%+y%) and 255
 2040 next
 2045 print#4, chr$(ck%);
 2050 get#4, a$: if a$="" goto 2050
 2055 if a$=chr$(nak%) then print"nak":goto 2005
 2060 if a$<>chr$(ack%) then print"???";asc(a$) :goto 2005
 2070 print "ack"
 2090 b%=b%+1: if b% > 255 then b% = 0
 2099 return
 7000 rem ---terminal---
 7010 print "{clr}{lblu}terminal mode. press ";chr$(95);" to return to menu"
 7020 get#4, a$: if a$="" goto 7040
 7030 print a$;: goto 7020
 7040 get a$:if a$="" goto 7020
 7050 print#4, a$;
 7055 if a$=chr$(95) then return
 7060 goto 7020
 8000 rem set up display
 8010 print "{clr}{red}{down}";
 8020 for i=1 to 17
 8030 print "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
 8040 next
 8050 print "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
 8060 print "ZZZZZZZZZZZZZZZZZZZZZZZZ"
 8070 for i=1 to 2
 8080 print "ZZZZZZZZZZZZZZZZZ"
 8090 next
 8099 return
 8900 rem ---initialize---
 8910 open 4, 2, 0, chr$(6)+chr$(0)
 8920 poke 52,96:poke 56,96
 8930 m=24576:t=1:s=0:b%=1
 8940 soh%=1:eot%=4:ack%=6:nak%=21
 8950 ri%=668:nul$=chr$(0):by%=255
 9000 rem ---main menu---
 9010 print "{clr}{cyn}";
 9012 poke 53280, 0: poke 53281, 0
 9020 print "disksumo v1.0, jul 26 2007"
 9025 print "chris pressey, cat's eye technologies"
 9026 print "2204 patch by aakoskin, bitwoods rbbs"
 9027 print "this program is in the public domain"
 9030 print "{down}{down}{down}";spc(16);"main menu"
 9035 print spc(16);"{CBM-T}{CBM-T}{CBM-T}{CBM-T} {CBM-T}{CBM-T}{CBM-T}{CBM-T}"
 9040 print "{down}{rght}{rght}{rght}{rght}{rght} {wht}t{cyn}erminal"
 9045 print "{rght}{rght}{rght}{rght}{rght} {wht}d{cyn}irectory"
 9050 print "{rght}{rght}{rght}{rght}{rght} {wht}e{cyn}rror status"
 9055 print "{rght}{rght}{rght}{rght}{rght} {wht}b{cyn}egin dump"
 9060 print "{rght}{rght}{rght}{rght}{rght} {wht}r{cyn}eceive dump"
 9065 print "{rght}{rght}{rght}{rght}{rght} {red}q{cyn}uit"
 9200 get a$: if a$="" goto 9200
 9210 if a$="t" then gosub 7000: goto 9000
 9220 if a$="d" then gosub 10000: goto 9500
 9230 if a$="e" then gosub 12000: goto 9500
 9240 if a$="b" then gosub 100: goto 9500
 9250 if a$="q" then goto 15000
 9260 if a$="r" then gosub 20000: goto 9500
 9490 goto 9000
 9500 print "{wht}press any key to continue";
 9510 get a$: if a$="" goto 9510
 9990 goto 9000
 10000 rem ---directory---
 10010 open 1, 8, 0, "$0": get#1, a$, a$
 10020 get#1, a$, a$: if a$="" then 10060
 10030 get#1, a$, b$: print asc(a$+chr$(0))+asc(b$+chr$(0))*256;
 10040 get#1, a$: if a$="" then print: goto 10020
 10050 print a$;: goto 10040
 10060 close 1: return
 12000 rem ---error status---
 12010 open 14,8,15
 12020 input#14, en, em$, et, es
 12030 print en, em$, et, es
 12040 close 14: return
 15000 rem ---shutdown---
 15010 close 4
 15099 end
 20000 rem --dump rs232 to disk--
 20010 t=1:s=0:b%=1:p%=1
 20020 print "{clr}insert a formatted floppy,"
 20030 print "start xmodem on the other computer,"
 20040 print "and press {wht}s{cyn} to start.";
 20050 get a$:if a$="" then 20050
 20060 if a$<>"s" then 9000
 20070 gosub 8000: rem setup display
 20080 be=ti
 20090 gosub 20700:print#4,chr$(nak%);
 20100 for t=1 to 35
 20110 gosub 500: rem calc max sec
 20120 gosub 20500: rem receive track
 20130 gosub 20600: rem write track
 20140 gosub 20380: rem ack for more
 20150 next
 20160 gosub 20900: rem finish
 20170 mi=(ti-5184e3*(ti<be)-be)/3600
 20180 print "{clr}";mi;"minutes elapsed"
 20190 return
 20300 rem ---receive xmodem packet---
 20310 gosub 20800:if asc(a$)<>soh% then 20410
 20320 gosub 20800:if asc(a$)<>p% then 20410
 20330 gosub 20800:if asc(a$)+p%<>by% then 20410
 20340 ck%=0
 20345 for i=mo to mo+127
 20350 gosub 20800:d%=asc(a$):ck%=(ck%+d%) and by%:poke i,d%
 20360 next
 20370 gosub 20800:if asc(a$)<>ck% then 20410
 20375 if sa% then return
 20380 print#4,chr$(ack%);:p%=(p%+1) and by%
 20390 return
 20400 rem ---xmodem nak---
 20410 d=10:gosub 30000:gosub 20700:print#4,chr$(nak%);:goto 20300
 20500 rem ---receive track---
 20520 for s=0 to ms%
 20530 co%=7:sy%=90:gosub 400
 20540 mo=m+s*256:sa%=0:gosub 20300
 20550 co%=7:sy%=87:gosub 400
 20560 mo=mo+128:sa%=(s=ms%):gosub 20300
 20570 co%=7:sy%=81:gosub 400
 20580 next
 20590 return
 20600 rem ---write track---
 20605 open 15,8,15:open 5,8,5,"#"
 20610 for s=0 to ms%
 20620 co%=10:sy%=81:gosub 400
 20630 print#15,"b-p:";5;0
 20640 mo=m+s*256:for i=mo to mo+255
 20650 print#5,chr$(peek(i));
 20660 next
 20670 print#15,"u2";5;0;t;s
 20680 co%=5:sy%=81:gosub 400
 20690 next:close 15:close 5
 20700 rem ---drain input---
 20710 was%=peek(ri%)
 20720 get#4,a$:now%=peek(ri%):if now%<>was% then 20710
 20730 return
 20800 rem ---receive character---
 20810 was%=now%
 20820 get#4,a$:now%=peek(ri%):if now%=was% then 20820
 20830 if a$="" then a$=nul$
 20840 return
 20900 rem ---end of transfer---
 20910 gosub 20800:if asc(a$)=eot% then print#4,chr$(nak%);
 20920 gosub 20800:if asc(a$)=eot% then print#4,chr$(ack%);
 20930 return
 30000 rem ---delay---
 30010 t0=ti:for d=t0+d*60 to d:d=ti:d=d-5184e3*(d<t0):next:return
