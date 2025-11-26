   10 gosub 50000:clr:goto 8910
  100 rem --dump disk to rs232--
  110 b=1
  120 gosub 8010:print "{home}{grn}ready. start xmodem on other computer";
  130 for w=-1 to 0:get#4,a$:w=a$<>k$:next
  140 print "{home}                                      ";
  150 for t=ft to 35:gosub 810:gosub 710:next
  160 i=1:for w=-1 to 0:print "{home}{yel}eot";i;"{left}     ";:print#4,chr$(4);
  170 d=1:gosub 30000:get#4,a$:i=i+1:w=(i<=10)and(a$<>c$):next:return
  200 rem ---receive character---
  210 sys 49248:c=peek(x):return
  220 sys 49253:c=peek(x):return
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
  710 gosub 20710:for s=0 to ms:co=4:sy=87:gosub 410:mh=m/256+s:ml=0:gosub 2010
  720 co=10:sy=87:gosub 410:ml=128:gosub 2010:co=5:sy=81:gosub 410:next
  730 print "{home}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{yel}t";t;"{left} sent";:return
  800 rem ---read trk into m---
  810 open 15,8,15:open 5,8,5,"#"
  820 gosub 510:for s=0 to ms:mh=m/256+s:gosub 1010:co=7:sy=90:gosub 410:next
  830 close 5:close 15:return
  900 rem ---scan for bad sectors---
  910 gosub 8010:open 15,8,15:open 5,8,5,"#"
  930 for t=ft to 35:gosub 510
  960 for s=0 to ms:print#15,"u1";5;0;t;s:input#15,ec
  980 co=5+(ec<>0):sy=81:gosub 410
  990 next:next:close 5:close 15:return
 1000 rem ---read sec#s,trk#t into mo---
 1010 print#15,"u1";5;0;t;s:poke y,mh:sys 49152:return
 2000 rem ---send 128 bytes to rs232---
 2010 print#3,"{home}{yel}b";b;"{left}      {left}{left}{left}{left}{left}";
 2020 print#4,s$;chr$(b);chr$(by-b);:wait 162,1:wait 162,1,1
 2030 poke x,ml:poke y,mh:sys 49184
 2040 gosub 210:if c=0 then 2040
 2050 if c=6 then print#3,"ack":b=(b+1)and by:return
 2060 if c=21 then print#3,"nak":d=1:gosub 30010:gosub 20710:goto 2010
 2070 goto 2040
 7000 rem ---terminal---
 7010 print "{clr}{lblu}terminal mode. press ";chr$(95);" to return to menu"
 7020 gosub 210: if c then print chr$(c);:goto 7020
 7030 get #2,a$:if a$="" then 7020
 7040 print#4,a$;:if a$=chr$(95) then return
 7050 goto 7020
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
 8930 a=780:a$=" ":b=1:b$=" ":by=255:c=0:c$=chr$(6):can=24:ck=0:d=0:ft=1:i=0
 8940 k$=chr$(21):m=24576:mh=0:ml=0:n$=chr$(0):r=668:s=0:s$=chr$(1):t=1:w=0
 8950 x=781:y=782
 8960 br=peek(659)and 15:if br<>8 then br=6
 8970 close 3:open 3,3:close 2:open 2,0
 9000 rem ---main menu---
 9010 print "{clr}{cyn}";:poke 53280,0:poke 53281,0
 9020 print "disksumo v1.0, jul 26 2007"
 9025 print "chris pressey, cat's eye technologies"
 9026 print "2511 patch by aakoskin, bitwoods rbbs"
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
 9200 get#2,a$:if a$="" then 9200
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
 9510 get#2,a$:if a$="" goto 9510
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
 15010 close 4:close 3:close 2
 15020 end
 20000 rem --dump rs232 to disk--
 20010 b=1
 20020 print "{clr}insert a formatted floppy,"
 20030 print "start xmodem on the other computer,"
 20040 print "and press {wht}s{cyn} to start.";
 20050 for w=-1 to 0:get#2,a$:w=a$="":next:if a$<>"s" then return
 20060 gosub 8010:gosub 20710:print#4,k$;:for t=ft to 35:gosub 510
 20070 gosub 20510:gosub 20610:gosub 20210:next:gosub 20910:return
 20200 rem ---xmodem ack---
 20210 print#4,c$;:b=(b+1)and by:return
 20300 rem ---receive xmodem packet---
 20310 gosub 210:if c<>1 then 20410
 20320 gosub 220:if c<>b then 20410
 20330 gosub 220:if c+b<>by then 20410
 20340 poke x,ml:poke y,mh:sys 49408:ck=peek(a)
 20350 gosub 220:if c<>ck then 20410
 20360 if sa then return
 20370 goto 20210
 20400 rem ---xmodem nak---
 20410 d=10:gosub 30010:gosub 20710:print#4,k$;:goto 20310
 20500 rem ---receive track---
 20510 for s=0 to ms:co=7:sy=90:gosub 410
 20530 mh=m/256+s:ml=0:sa=0:gosub 20310:co=7:sy=87:gosub 410
 20550 ml=128:sa=(s=ms):gosub 20310:co=7:sy=81:gosub 410:next:return
 20600 rem ---write track---
 20610 open 15,8,15:open 5,8,5,"#":for s=0 to ms:co=10:sy=81:gosub 410
 20620 print#15,"b-p:";5;0:poke y,m/256+s:sys 49472
 20640 print#15,"u2";5;0;t;s:co=5:sy=81:gosub 410:next:close 5:close 15
 20650 print "{home}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{yel}t";t;"{left} written";:goto 20710
 20700 rem ---drain input---
 20710 for w=-1 to 0:c=peek(r):get#4,a$:w=peek(r)<>c:next:return
 20900 rem ---end of transfer---
 20910 i=1:d=100
 20920 print "{home}{yel}eot";i;"{left} ";
 20930 gosub 210:if c=4 then print#4,c$;
 20940 gosub 210:if c=0 or i=10 then return
 20950 print#4,k$;:i=i+1:goto 20920
 30000 rem ---delay---
 30010 t0=ti:for d=t0+d*60 to d:d=ti:d=d-5184e3*(d<t0):next:return
 50000 print "loading machine code...";
 50010 def fna(i)=asc(mid$(h$,i,1))-48
 50020 def fnh(i)=fna(i)+7*(fna(i)>16)
 50030 def fnb(i)=fnh(i)*16+fnh(i+1)
 50040 read l:if l then read c:for h=1 to c:read h$:gosub 50060:next:goto 50040
 50050 print e:return
 50060 for i=1 to len(h$) step 2:poke l,fnb(i):l=l+1:next:e=l:return
 60000 rem --- machine code routines ---
 60100 data 49152,9: rem c000 (read sec)
 60110 data "8c0fc0":rem    f sty $c00f
 60120 data "a205":  rem      ldx #5
 60130 data "20c6ff":rem      jsr $ffc6                                  (chkin)
 60140 data "a200":  rem      ldx #0
 60150 data "20cfff":rem   *  jsr $ffcf                                  (chrin)
 60160 data "9d0000":rem    * sta ?,x
 60170 data "e8":    rem      inx
 60180 data "d0f7":  rem   b  bne -9
 60190 data "60":    rem      rts
 60200 data 49184,17:rem c020 (send pkt)
 60210 data "8c32c0":rem    f sty $c032
 60220 data "8e31c0":rem   f  stx $c031
 60230 data "a204":  rem      ldx #4
 60240 data "20c9ff":rem      jsr $ffc9                                 (chkout)
 60250 data "a200":  rem      ldx #0
 60260 data "8e0e03":rem      stx $30e
 60270 data "bd0000":rem  *** lda ?,x
 60280 data "a818"  :rem      tay; clc
 60290 data "6d0e03":rem      adc $30e
 60300 data "8d0e03":rem      sta $30e
 60310 data "98":    rem      tya
 60320 data "20d2ff":rem      jsr $ffd2                                 (chrout)
 60330 data "e8":    rem      inx
 60340 data "10ee":  rem  b   bpl -18
 60350 data "ad0e03":rem      lda $30e
 60360 data "20d2ff":rem      jsr $ffd2                                 (chrout)
 60370 data "60":    rem      rts
 60400 data 49248,15:rem c060 (recv chr)
 60410 data "a204":  rem      ldx #4
 60420 data "20c6ff":rem      jsr $ffc6                                  (chkin)
 60425 rem               c065 (fast chr)
 60430 data "a200":  rem      ldx #0
 60440 data "86a2":  rem      stx $a2
 60450 data "ae9c02":rem      ldx $29c
 60460 data "8e75c0":rem    f stx $c075
 60470 data "20e4ff":rem  *   jsr $ffe4                                  (getin)
 60480 data "aa38":  rem      tax;sec
 60490 data "a900":  rem    * lda #?
 60500 data "ed9c02":rem      sbc $29c
 60510 data "d006":  rem   f  bne 6
 60520 data "a940":  rem      lda #$40
 60530 data "25a2":  rem      and $a2
 60540 data "f0ee":  rem  b   beq -18
 60550 data "60":    rem   *  rts
 60600 data 49408,14:rem c100 (recv pkt)
 60610 data "8c17c1":rem    f sty $c117
 60620 data "8e16c1":rem   f  stx $c116
 60630 data "a900":  rem      lda #0
 60640 data "8d0d03":rem      sta $30d
 60650 data "8d0c03":rem      sta $30c
 60660 data "2065c0":rem  *   jsr $c065
 60670 data "8a":    rem      txa
 60680 data "ac0d03":rem      ldy $30d
 60690 data "990000":rem   ** sta ?,y
 60700 data "18":    rem      clc
 60710 data "6d0c03":rem      adc $30c
 60720 data "ee0d03":rem      inc $30d
 60730 data "10ea":  rem  b   bpl -22
 60740 data "60":    rem      rts
 60800 data 49472,9: rem c140 (wrt sect)
 60810 data "8c4cc1":rem    f sty $c14c
 60820 data "a205":  rem      ldx #5
 60830 data "20c9ff":rem      jsr $ffc9                                 (chkout)
 60840 data "a200":  rem      ldx #0
 60850 data "bd0000":rem   ** lda ?,x
 60860 data "20d2ff":rem      jsr $ffd2                                 (chrout)
 60870 data "e8":    rem      inx
 60880 data "d0f7":  rem   b  bne -9
 60890 data "60":    rem      rts
 61000 data 0:rem ----------------------
