   10 goto 8910
  100 rem --dump disk to rs232--
  110 b=1
  120 gosub 8010:print "{home}{grn}ready. start xmodem on other computer";
  130 for w=-1 to 0:get#4,a$:w=a$<>k$:next
  140 print "{home}                                      ";
  150 for t=ft to 35:gosub 810:gosub 710:next
  160 i=1:for w=-1 to 0:print "{home}{yel}eot";i;"{left}     ";:print#4,chr$(4);
  170 d=1:gosub 30000:get#4,a$:i=i+1:w=(i<=10)and(a$<>c$):next:return
  200 rem ---receive character---
  210 x=peek(r):for w=-1 to 0:get#4,a$:d=d-1:w=peek(r)=x and d>0:next:a$=a$+n$:return
  400 rem --update display--
  410 poke 55296+(t-1)+40*(s+1),co:poke 1024+(t-1)+40*(s+1),sy:return
  500 rem --calc max sec# for trk#t--
  510 if t<=17 then ms=20:return
  520 if t<=24 then ms=18:return
  530 if t<=30 then ms=17:return
  540 ms=16:return
  600 rem ---set the start track---
  610 print "{clr}new start track (1-35)"
  620 input a$:if val(a$)>0 and val(a$)<36 then ft=val(a$)
  630 return
  700 rem --send trk--
  710 gosub 20710
  720 for s=0 to ms
  730 co=4:sy=87:gosub 410:mo=m+s*256:gosub 2010
  740 co=10:sy=87:gosub 410:mo=mo+128:gosub 2010
  750 co=5:sy=81:gosub 410:next
  760 print "{home}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{yel}t";t;"{left} sent";:return
  800 rem ---read trk into m---
  810 open 15,8,15:open 5,8,5,"#"
  820 gosub 510:for s=0 to ms:mo=m+s*256:gosub 1010:co=7:sy=90:gosub 410:next
  830 close 5:close 15:return
  900 rem ---scan for bad sectors---
  910 gosub 8010:open 15,8,15:open 5,8,5,"#"
  930 for t=ft to 35:gosub 510
  960 for s=0 to ms:print#15,"u1";5;0;t;s:input#15,ec
  980 co=5+(ec<>0):sy=81:gosub 410
  990 next:next:close 5:close 15:return
 1000 rem ---read sec#s,trk#t into mo---
 1010 print#15,"u1";5;0;t;s:for i=mo to mo+by step 2:get#5,a$,b$
 1020 poke i,asc(a$+n$):poke i+1,asc(b$+n$):next:return
 2000 rem ---send 128 bytes at mo to rs232---
 2010 print "{home}{yel}b";b;"{left}      {left}{left}{left}{left}{left}";
 2020 print#4,s$;chr$(b);chr$(by-b);
 2030 ck=0:for i=mo to mo+127:print#4,chr$(peek(i));:ck=(ck+peek(i))and by:next
 2040 print#4,chr$(ck);:for w=0 to 1:get#4,a$:w=len(a$):next
 2050 if a$=k$ then print"nak":goto 2010
 2060 if a$<>c$ then print asc(a$):goto 2010
 2070 print "ack":b=(b+1)and by:return
 7000 rem ---terminal---
 7010 print "{clr}{lblu}terminal mode. press ";chr$(95);" to return to menu"
 7020 get#4,a$:if a$="" then 7040
 7030 print a$;:goto 7020
 7040 get a$:if a$="" then 7020
 7050 print#4,a$;:if a$=chr$(95) then return
 7060 goto 7020
 8000 rem set up display
 8010 print "{clr}{red}{down}";
 8020 for i=1 to 17:print "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ":next
 8030 print "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
 8040 print "ZZZZZZZZZZZZZZZZZZZZZZZZ"
 8050 for i=1 to 2:print "ZZZZZZZZZZZZZZZZZ":next
 8060 return
 8800 rem ---1200 bps---
 8810 close 4:open 4,2,0,chr$(8)+chr$(0):goto 8920
 8900 rem ---initialize---
 8910 close 4:open 4,2,0,chr$(6)+chr$(0)
 8920 poke 52,96:poke 51,0:poke 56,96:poke 55,0
 8930 a$="  ":b=1:b$=" ":by=255:c=0:c$=chr$(6):can=24:ck=0:d=0:ft=1:i=0
 8940 k$=chr$(21):m=24576:n$=chr$(0):r=668:s=0:s$=chr$(1):t=1:w=0:x=0
 8950 br=peek(659)and 15:if br<>8 then br=6
 9000 rem ---main menu---
 9010 print "{clr}{cyn}";:poke 53280,0:poke 53281,0
 9020 print "disksumo v1.0, jul 26 2007"
 9025 print "chris pressey, cat's eye technologies"
 9026 print "2510 patch by aakoskin, bitwoods rbbs"
 9027 print "this program is in the public domain"
 9030 print "{down}{down}{down}";spc(16);"main menu"
 9035 print spc(16);"{CBM-T}{CBM-T}{CBM-T}{CBM-T} {CBM-T}{CBM-T}{CBM-T}{CBM-T}"
 9040 print "{down}{rght}{rght}{rght}{rght}{rght} {wht}t{cyn}erminal"
 9045 print "{rght}{rght}{rght}{rght}{rght} {wht}d{cyn}irectory"
 9050 print "{rght}{rght}{rght}{rght}{rght} {wht}e{cyn}rror status"
 9055 print "{rght}{rght}{rght}{rght}{rght} {wht}b{cyn}egin dump"
 9060 print "{rght}{rght}{rght}{rght}{rght} {wht}r{cyn}eceive dump"
 9061 print "{rght}{rght}{rght}{rght}{rght} {wht}s{cyn}tart track ("+mid$(str$(ft),2)+")"
 9062 print "{rght}{rght}{rght}{rght}{rght} b{wht}i{cyn}t rate ("+mid$("300) 1200)",-5*(br=8)+1,5)
 9063 print "{rght}{rght}{rght}{rght}{rght} s{wht}c{cyn}an disk"
 9065 print "{rght}{rght}{rght}{rght}{rght} {red}q{cyn}uit"
 9200 get a$:if a$="" then 9200
 9210 if a$="t" then gosub 7010:goto 9010
 9220 if a$="d" then gosub 10010:goto 9500
 9230 if a$="e" then gosub 12010:goto 9500
 9240 if a$="b" then gosub 110:goto 9500
 9250 if a$="q" then 15000
 9260 if a$="r" then gosub 20010:goto 9500
 9270 if a$="s" then gosub 610:goto 9010
 9280 if a$="i" then on -(br=6) goto 8810:goto 8910
 9290 if a$="c" then gosub 910:goto 9500
 9490 goto 9010
 9500 print "{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{wht}press any key to continue";
 9510 get a$:if a$="" goto 9510
 9520 goto 9010
 10000 rem ---directory---
 10010 open 1,8,0,"$0":get#1,a$,a$
 10020 get#1,a$,a$:if a$="" then 10060
 10030 get#1,a$,b$:print asc(a$+n$)+asc(b$+n$)*256;
 10040 get#1,a$:if a$="" then print:goto 10020
 10050 print a$;:goto 10040
 10060 close 1:return
 12000 rem ---error status---
 12010 open 14,8,15
 12020 input#14,en,em$,et,es
 12030 print en,em$,et,es
 12040 close 14:return
 15000 rem ---shutdown---
 15010 close 4
 15020 end
 20000 rem --dump rs232 to disk--
 20010 b=1
 20020 print "{clr}insert a formatted floppy,"
 20030 print "start xmodem on the other computer,"
 20040 print "and press {wht}s{cyn} to start.";
 20050 for w=-1 to 0:get a$:w=a$="":next:if a$<>"s" then return
 20060 gosub 8010:gosub 20710:print#4,k$;:for t=ft to 35:gosub 510
 20070 gosub 20510:gosub 20610:gosub 20210:next:gosub 20910:return
 20200 rem ---xmodem ack---
 20210 print#4,c$;:b=(b+1)and by:return
 20300 rem ---receive xmodem packet---
 20310 d=300:gosub 210:if a$<>s$+n$ then 20410
 20320 gosub 210:if asc(a$)<>b then 20410
 20330 gosub 210:if asc(a$)+b<>by then 20410
 20340 ck=0:for i=mo to mo+127:gosub 210:c=asc(a$):ck=(ck+c)and by:poke i,c:next
 20350 gosub 210:if asc(a$)<>ck then 20410
 20360 if sa then return
 20370 goto 20210
 20400 rem ---xmodem nak---
 20410 d=10:gosub 30010:gosub 20710:print#4,k$;:goto 20310
 20500 rem ---receive track---
 20510 for s=0 to ms
 20520 co=7:sy=90:gosub 410
 20530 mo=m+s*256:sa=0:gosub 20310
 20540 co=7:sy=87:gosub 410
 20550 mo=mo+128:sa=(s=ms):gosub 20310
 20560 co=7:sy=81:gosub 410
 20570 next
 20580 return
 20600 rem ---write track---
 20610 open 15,8,15:open 5,8,5,"#":for s=0 to ms:co=10:sy=81:gosub 410
 20620 print#15,"b-p:";5;0:mo=m+s*256
 20630 for i=mo to mo+255 step 2:print#5,chr$(peek(i));chr$(peek(i+1));:next
 20640 print#15,"u2";5;0;t;s:co=5:sy=81:gosub 410:next:close 5:close 15
 20650 print "{home}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{yel}t";t;"{left} written";:goto 20710
 20700 rem ---drain input---
 20710 for w=-1 to 0:x=peek(r):get#4,a$:w=peek(r)<>x:next:return
 20900 rem ---end of transfer---
 20910 i=1:d=100
 20920 print "{home}{yel}eot";i;"{left} ";
 20930 gosub 210:if asc(a$)=4 then print#4,c$;
 20940 gosub 210:if asc(a$)=0 or i=10 then return
 20950 print#4,k$;:i=i+1:goto 20920
 30000 rem ---delay---
 30010 t0=ti:for d=t0+d*60 to d:d=ti:d=d-5184e3*(d<t0):next:return
