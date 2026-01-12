   10 gosub 50000:clr:goto 8910
  100 rem --dump disk to rs232--
  110 gosub 8010:gosub 1210:print "{home}{grn}ready. start xmodem on other computer";
  120 k=0:for w=-1 to 0:gosub 210:gosub 310:w=c<>21 and k=0:next:if k then return
  130 print "{home}                                      ";
  140 b=1:ba=0:ec=0:for t=ft to 35:gosub 810:gosub 710:next
  150 i=1:for w=-1 to 0:print "{home}{yel}eot";i;"{left}     ";:print#4,chr$(4);
  160 gosub 210:i=i+1:w=(i<5)and(c<>6):next:return
  200 rem ---receive character---
  210 sys 49248:c=peek(x):return
  300 rem ---check for kill---
  310 get#2,a$:k=k or a$="_":if k=0 then return
  320 print "{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{yel}operation terminated.";:return
  400 rem --update display--
  410 poke 55296+(t-1)+40*(s+2),co:poke 1024+(t-1)+40*(s+2),sy:return
  500 rem --calc max sec# for trk#t--
  510 ms=16-2*(t<18)-(t<25)-(t<31):return
  600 rem ---set the start track---
  610 print "{clr}new start track (1-35)"
  620 input a$:if val(a$)>0 and val(a$)<36 then ft=val(a$)
  630 return
  700 rem --send trk--
  710 for s=0 to ms:co=4:sy=87:gosub 410:mh=m/256+s:ml=0:gosub 2010
  720 co=10:sy=87:gosub 410:ml=128:gosub 2010:co=5:sy=81:gosub 410:next
  730 print "{home}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{yel}t";t;"{left} sent";:return
  800 rem ---read trk into m---
  810 open 15,8,15:open 5,8,5,"#"
  820 gosub 510:sy=90:for s=0 to ms:mh=m/256+s:co=7:gosub 1010:gosub 410:next
  830 close 5:close 15:return
  900 rem ---scan for bad sectors---
  910 gosub 8010:gosub 1210:open 15,8,15:open 5,8,5,"#":mh=m/256:k=0
  920 for t=ft to 35:gosub 510:for s=0 to ms:gosub 1010
  930 co=5+(e<>0):sy=81:gosub 410:next:gosub 310:if k=0 then next
  940 close 5:close 15:return
 1000 rem ---read sec#s,trk#t into mo---
 1010 print#15,"u1";5;0;t;s:input#15,e:poke y,mh:sys 49152:if e=0 then return
 1020 if e=29 then return
 1030 gosub 1310:co=2:ec=ec+1:if ec=1 then et=t
 1040 print"{home}{down}{yel}io errors:";ec"{left} t >=";et;:if c and (t<>18 or s) then return
 1050 ba=ba+1:if ba=1 then bt=t
 1060 print "{home}{down}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{red}bad:";ba;"{left} t >=";bt;:return
 1100 rem ---check bam---
 1110 gosub 8010:print "{home}{wht}block allocation map {grn}green=free {red}red=used":gosub 1210
 1120 k=0:sy=81:for t=1 to 35:gosub 510:for s=0 to ms:gosub 1310:co=5+(c=0)*3
 1130 gosub 410:next:gosub 310:if k then return
 1140 next:return
 1200 rem ---read bam into bm---
 1210 open 15,8,15:open 5,8,5,"#":ml=0:mh=bm/256:t=18:s=0
 1220 gosub 1010:close 5:close 15:if e=0 then return
 1230 print#3,"{home}{down}{red}bam failure!                            ";
 1240 for i=bm to bm+255:poke i,0:next:return
 1300 rem ---check if t;s allocated---
 1310 c=s and 7:w=1:for i=1 to c:w=w*2:next:c=peek(bm+t*4+int(s/8)+1)and w:return
 2000 rem ---send 128 bytes to rs232---
 2010 print#3,"{home}{yel}b";b;"{left}      {left}{left}{left}{left}{left}";:print#4,s$;
 2020 sys 49504:print#4,chr$(b);chr$(by-b);
 2030 poke x,ml:poke y,mh:sys 49184:c=peek(x)
 2040 if c=6 then print#3,"ack":b=(b+1)and by:return
 2050 if c=21 then print#3,"nak":goto 2010
 2060 if c then print#3,"{home}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}noise";c;"  {home}{yel}b";b;"{left}";
 2070 gosub 210:goto 2040
 7000 rem ---terminal---
 7010 print "{clr}{lblu}terminal mode. press ";chr$(95);" to return to menu"
 7020 gosub 210: if c then print chr$(c);:goto 7020
 7030 get #2,a$:if a$="" then 7020
 7040 print#4,a$;:if a$=chr$(95) then return
 7050 goto 7030
 8000 rem set up display
 8010 print "{clr}{red}{down}{down}";
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
 8930 a=780:a$=" ":b=1:b$=" ":ba=0:bm=24576:bt=0:by=255:c=0:c$=chr$(6):ck=0
 8940 d=0:e=0:ec=0:et=0:ft=1:i=0:k=0:k$=chr$(21):l=0:m=bm+256:mh=0:ml=0
 8950 n$=chr$(0):s=0:s$=chr$(1):t=1:w=0:x=781:y=782
 8960 br=peek(659)and 15:if br<>8 then br=6
 8970 close 3:open 3,3:close 2:open 2,0
 9000 rem ---main menu---
 9010 print "{clr}{cyn}";:poke 53280,0:poke 53281,0
 9020 print "disksumo v1.0, jul 26 2007"
 9025 print "chris pressey, cat's eye technologies"
 9026 print "2601 patch by aakoskin, bitwoods rbbs"
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
 9064 print "{rght}{rght}{rght}{rght}{rght} check ba{wht}m{cyn}"
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
 9300 if a$="m" then gosub 1110:goto 9500
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
 20060 gosub 8010:sys 49504:print#4,k$;:for t=ft to 35:gosub 510
 20070 gosub 20510:gosub 20610:sys 49504:gosub 20210:next:gosub 20910:return
 20200 rem ---xmodem ack---
 20210 print#4,c$;:b=(b+1)and by:print#3,"{home}{rght}{rght}{rght}{rght}{rght}{rght}{grn}ack";:return
 20300 rem ---receive xmodem packet---
 20310 print#3,"{home}{wht}b";b;"       ";
 20320 poke a,b:poke x,ml:poke y,mh:sys 49408:ss=st:if peek(a) then 20410
 20330 if sa then return
 20340 goto 20210
 20400 rem ---xmodem nak---
 20410 c=peek(782):sys 49504:print#4,k$;:print#3,"{home}{rght}{rght}{rght}{rght}{rght}{rght}{red}nak";c;ss;:goto 20320
 20500 rem ---receive track---
 20510 for s=0 to ms:co=7:sy=90:gosub 410
 20530 mh=m/256+s:ml=0:sa=0:gosub 20310:co=7:sy=87:gosub 410
 20550 ml=128:sa=(s=ms):gosub 20310:co=7:sy=81:gosub 410:next:return
 20600 rem ---write track---
 20610 open 15,8,15:open 5,8,5,"#":for s=0 to ms:co=10:sy=81:gosub 410
 20620 print#15,"b-p:";5;0:poke y,m/256+s:sys 49472
 20640 print#15,"u2";5;0;t;s:co=5:sy=81:gosub 410:next:close 5:close 15
 20650 print "{home}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{yel}t";t;"{left} written";:return
 20900 rem ---end of transfer---
 20910 i=1
 20920 gosub 210:print#3,"{home}{yel}eot ";i;"    {left}{left}{left}{left}";c:if c=4 then print#4,c$;
 20930 if c=0 or i=5 then return
 20940 if c<>4 then print#4,k$;
 20950 i=i+1:goto 20920
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
 60200 data 49184,18:rem c020 (send pkt)
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
 60370 data "2060c0":rem      jsr $c060                               (recv chr)
 60380 data "60":    rem      rts
 60400 data 49248,18:rem c060 (recv chr)
 60410 data "a204":  rem      ldx #4
 60420 data "20c6ff":rem      jsr $ffc6                                  (chkin)
 60425 rem               c065 (fast chr)
 60430 data "a200":  rem      ldx #0
 60440 data "8e89c0":remf     stx $c089
 60450 data "8e82c0":rem f    stx $c082
 60460 data "ae9c02":rem      ldx $29c
 60470 data "8e78c0":rem    f stx $c078
 60480 data "20e4ff":rem  *   jsr $ffe4                                  (getin)
 60490 data "aaa900":rem    * tax;lda #?
 60500 data "cd9c02":rem      cmp $29c
 60510 data "d010":  rem   f  bne 16
 60520 data "ee82c0":rem    f inc $c082
 60530 data "a900":  rem *  * lda #?
 60540 data "d0ee":  rem  b   bne -18
 60550 data "ee89c0":rem      inc $c089
 60560 data "a900":  rem*     lda #?
 60570 data "10de":  rem      bpl -34
 60580 data "a20060":rem   *  ldx #0;rts
 60600 data 49408,20:rem c100 (recv pkt)
 60610 data "8c1fc1":rem    f sty $c11f
 60620 data "8e1ec1":rem   f  stx $c11e
 60625 data "2080c1":rem      jsr $c180
 60630 data "f00160":rem *    beq 1;rts
 60640 data "a900":  rem      lda #0
 60645 data "8d0d03":rem      sta $30d
 60650 data "8d0c03":rem  *   sta $30c
 60660 data "2065c0":rem      jsr $c065
 60670 data "f0f28a":rem b    beq-14;txa
 60680 data "ac0d03":rem      ldy $30d
 60690 data "990000":rem   ** sta ?,y
 60700 data "18":    rem      clc
 60710 data "6d0c03":rem      adc $30c
 60720 data "ee0d03":rem      inc $30d
 60730 data "10e8":  rem  b   bpl -24
 60740 data "8d0c03":rem      sta $30c
 60750 data "2065c0":rem      jsr $c065
 60760 data "8a38":  rem      txa;sec
 60770 data "ed0c03":rem      sbc $30c
 60780 data "60":    rem      rts
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
 60900 data 49504,9 :rem c160 (flush in)
 60910 data "a204":  rem      ldx #4
 60920 data "20c6ff":rem      jsr $ffc6                                  (chkin)
 60930 data "ae9c02":rem      ldx $29c
 60940 data "8e6fc1":rem    f stx $c16f
 60950 data "20e4ff":rem   *  jsr $ffe4                                  (getin)
 60960 data "a90038":rem    * lda #?;sec
 60970 data "ed9c02":rem      sbc $29c
 60980 data "d0f5":  rem   b  bne -11
 60990 data "60":    rem      rts
 61000 data 49536,14:rem c180 (recv hdr)
 61010 data "8d93c1":rem    f sta $c193
 61020 data "49ff"  :rem      eor #$ff
 61040 data "8d9ac1":rem   f  sta $c19a
 61050 data "2060c0":rem      jsr $c060
 61060 data "e001"  :rem      cpx #1
 61070 data "d011"  :rem  f   bne 17
 61080 data "2065c0":rem      jsr $c065
 61090 data "e000"  :rem    * cpx #?
 61100 data "d00a"  :rem f    bne 10
 61110 data "2065c0":rem      jsr $c065
 61120 data "e000"  :rem   *  cpx #?
 61130 data "d003"  :rem    f bne 3
 61140 data "a90060":rem      lda #0;rts
 61150 data "a90160":rem ** * lda #1;rts
 62000 data 0:rem ----------------------
