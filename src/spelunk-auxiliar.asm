;-----------------------------------------------
; pletter v0.5c msx unpacker
; call unpack with "hl" pointing to some pletter5 data, and "de" pointing to the destination.
; changes all registers

GETBIT:  MACRO 
    add a,a
    call z,pletter_getbit
    ENDM

GETBITEXX:  MACRO 
    add a,a
    call z,pletter_getbitexx
    ENDM

pletter_unpack:
    ld a,(hl)
    inc hl
    exx
    ld de,0
    add a,a
    inc a
    rl e
    add a,a
    rl e
    add a,a
    rl e
    rl e
    ld hl,pletter_modes
    add hl,de
    ld e,(hl)
    ld ixl,e
    inc hl
    ld e,(hl)
    ld ixh,e
    ld e,1
    exx
    ld iy,pletter_loop
pletter_literal:
    ldi
pletter_loop:
    GETBIT
    jr nc,pletter_literal
    exx
    ld h,d
    ld l,e
pletter_getlen:
    GETBITEXX
    jr nc,pletter_lenok
pletter_lus:
    GETBITEXX
    adc hl,hl
    ret c
    GETBITEXX
    jr nc,pletter_lenok
    GETBITEXX
    adc hl,hl
    ret c
    GETBITEXX
    jp c,pletter_lus
pletter_lenok:
    inc hl
    exx
    ld c,(hl)
    inc hl
    ld b,0
    bit 7,c
    jp z,pletter_offsok
    jp ix

pletter_mode6:
    GETBIT
    rl b
pletter_mode5:
    GETBIT
    rl b
pletter_mode4:
    GETBIT
    rl b
pletter_mode3:
    GETBIT
    rl b
pletter_mode2:
    GETBIT
    rl b
    GETBIT
    jr nc,pletter_offsok
    or a
    inc b
    res 7,c
pletter_offsok:
    inc bc
    push hl
    exx
    push hl
    exx
    ld l,e
    ld h,d
    sbc hl,bc
    pop bc
    ldir
    pop hl
    jp iy

pletter_getbit:
    ld a,(hl)
    inc hl
    rla
    ret

pletter_getbitexx:
    exx
    ld a,(hl)
    inc hl
    exx
    rla
    ret

pletter_modes:
    dw pletter_offsok
    dw pletter_mode2
    dw pletter_mode3
    dw pletter_mode4
    dw pletter_mode5
    dw pletter_mode6


;-----------------------------------------------
; Source: http://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Random
;-----> Generate a random number
; ouput a=answer 0<=a<=255
; all registers are preserved except: af
random:
    push    hl
    push    de
    ld      hl,(randData)
    ld      a,r
    ld      d,a
    ld      e,(hl)
    add     hl,de
    add     a,l
    xor     h
    ld      (randData),hl
    pop     de
    pop     hl
    ret


randomSeedUpdate:
    ld a,(randSeedIndex)
    inc a
    ld (randSeedIndex),a
    and #01
    jp z,randomSeedUpdate2
    ld a,r
    ld (randData),a
    ret
randomSeedUpdate2:
    ld a,r
    ld (randData+1),a
    ret
    

;-----------------------------------------------
; Generates a random number between 0 and "a-1"
; - note: this function is slow, since it requires calling a division, so, do not
;         call in code that is supposed to run fast.
randomModuloA:
    push hl
    push de
    push af
    call random
    ld h,0
    ld l,a
    pop af
    ld d,a
    call Div8
    pop de
    pop hl
    ret


;-----------------------------------------------
; Source: (thanks to ARTRAG) https://www.msx.org/forum/msx-talk/development/memory-pages-again
; Sets the memory pages to : BIOS, ROM, ROM, RAM
setupROMRAMslots:
    call RSLREG     ; Reads the primary slot register
    rrca
    rrca
    and #03         ; keep the two bits for page 1
    ld c,a
    add a,#C1       
    ld l,a
    ld h,#FC        ; HL = EXPTBL + a
    ld a,(hl)
    and #80         ; keep just the most significant bit (expanded or not)
    or c
    ld c,a          ; c = a || c (a had #80 if slot was expanded, and #00 otherwise)
    inc l           
    inc l
    inc l
    inc l           ; increment 4, in order to get to the corresponding SLTTBL
    ld a,(hl)       
    and #0C         
    or c            ; in A the rom slotvar 
    ld h,#80        ; move page 1 of the ROM to page 2 in main memory
    jp ENASLT       
    

;-----------------------------------------------
; source: https://www.msx.org/forum/development/msx-development/how-0?page=0
; returns 1 in a and clears z flag if vdp is 60Hz
; size: 27 bytes
CheckIf60Hz:
    di
    in      a,(#99)
    nop
    nop
    nop
vdpSync:
    in      a,(#99)
    and     #80
    jr      z,vdpSync
    
    ld      hl,#900
vdpLoop:
    dec     hl
    ld      a,h
    or      l
    jr      nz,vdpLoop
    
    in      a,(#99)
    rlca
    and     1
    ei
    ret


;-----------------------------------------------
; decreases (hl) if it is not zero
decreaseHLIfNotZero:
    ld a,(hl)
    or a
    ret z
    dec (hl)
    ret


;-----------------------------------------------
; Divide "hl" by "d", output is:
; - division result in "hl"
; - remainder in "a"
; Code borrowed from: //sgate.emt.bme.hu/patai/publications/z80guide/part4.html
Div8:                            ; this routine performs the operation HL=HL/D
  push bc
  xor a                          ; clearing the upper 8 bits of AHL
  ld b,16                        ; the length of the dividend (16 bits)
Div8Loop:
  add hl,hl                      ; advancing a bit
  rla
  cp d                           ; checking if the divisor divides the digits chosen (in A)
  jp c,Div8NextBit               ; if not, advancing without subtraction
  sub d                          ; subtracting the divisor
  inc l                          ; and setting the next digit of the quotient
Div8NextBit:
  djnz Div8Loop
  pop bc
  ret


;-----------------------------------------------
; hl * 16 or 32
HLTimes32:
  add hl,hl
HLTimes16:
  add hl,hl
  add hl,hl
  add hl,hl
  add hl,hl
  ret


;-----------------------------------------------
; A couple of useful macros for adding 16 and 8 bit numbers

ADD_HL_A: MACRO 
    add a,l
    ld l,a
    jr nc, $+3
    inc h
    ENDM

ADD_DE_A: MACRO 
    add a,e
    ld e,a
    jr nc, $+3
    inc d
    ENDM    

ADD_HL_A_VIA_BC: MACRO
    ld b,0
    ld c,a
    add hl,bc
    ENDM
