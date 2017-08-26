;-----------------------------------------------
; debugging function that creates a 16x16 matrix with all the patterns in screen
;showAllPatterns:
;    ld a,0
;    ld hl,NAMTBL2
;showAllPatterns_loop:
;    call WRTVRM
;    inc hl
;    inc a
;    ld b,a
;    and #0f
;    ld a,b
;    jp nz,showAllPatterns_loop
;    ld bc,32-16
;    add hl,bc
;    or a
;    jp nz,showAllPatterns_loop
;    ret


;-----------------------------------------------
;; clear sprites:
clearAllTheSprites:
    xor a
    ld bc,32*4
    ld hl,SPRATR1
    jp FILVRM


;-----------------------------------------------
; Fills the whole screen with the pattern in register 'a'
FILLSCREEN:
    ld bc,768
    ld hl,NAMTBL2
    jp FILVRM


;-----------------------------------------------
; Clears the screen left to right
clearScreenLeftToRight:
    call clearAllTheSprites
    ld a,32
    ld bc,0
clearScreenLeftToRightExternalLoop
    push af
    push bc
    ld a,24
    ld hl,NAMTBL2
    add hl,bc
clearScreenLeftToRightLoop:
    push hl
    push af
    xor a
    ld bc,1
    call FILVRM
    pop af
    pop hl
    ld bc,32
    add hl,bc
    dec a
    jr nz,clearScreenLeftToRightLoop
    pop bc
    pop af
    inc bc
    dec a
    halt
    jr nz,clearScreenLeftToRightExternalLoop
    ret  


;-----------------------------------------------
; decompresses patterns patch to the VDP:
; input: the pattern patch to decompress are in "HL"
; requirements: this function requires buffer and buffer2 to be empty
decompressPatternPatchToVDP:
    push hl

    ; 1) get the current patterns into the buffer
    ld hl,CHRTBL2
    ld de,buffer
    ld bc,256*8
    push bc
    call LDIRMV
    ld hl,CLRTBL2
    ld de,buffer+256*8
    pop bc
    call LDIRMV

    ; 2) decompress the patch into buffer2
    pop hl
    ld de,buffer2
    call pletter_unpack

    ; 3) apply the patch
    ld a,(buffer2)
    ld b,a
    ld de,buffer2+1
decompressPatternPatchToVDP_loop:
    push bc

    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    inc de      ; bc = offset
    
    ld hl,buffer
    add hl,bc

    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    inc de      ; bc = length of the patch

    ex de,hl    ; now "de" = buffer + start, and "hl" = patch data to copy
    ldir
    ex de,hl

    pop bc
    djnz decompressPatternPatchToVDP_loop

    ; 4) re-upload the patch to the VDP
    jr decompressPatternsToVDP_upload_to_VDP


;-----------------------------------------------
; decompresses patterns to the VDP:
; input: the patterns to decompress are in "HL"
decompressPatternsToVDP:
    ld de,buffer
    call pletter_unpack

decompressPatternsToVDP_upload_to_VDP:
    ld hl,buffer
    ld de,CHRTBL2
    ld bc,256*8
    push bc
    push hl
    call LDIRVM

    pop hl
    pop bc
    ld de,CHRTBL2+256*8
    push bc
    push hl
    call LDIRVM
    pop hl
    pop bc

    ld de,CHRTBL2+256*8*2
    push bc
    call LDIRVM

    pop bc
    ld hl,buffer+2048
    ld de,CLRTBL2
    push bc
    push hl
    call LDIRVM

    pop hl
    pop bc
    ld de,CLRTBL2+256*8
    push bc
    push hl
    call LDIRVM

    pop hl
    pop bc
    ld de,CLRTBL2+256*8*2
    jp LDIRVM


;-----------------------------------------------
; copies the sprite pointed at by "de" to VDP address pointed by "hl"
loadSpriteToVDP:
    push de
    call SETWRT
    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld b,32
    pop hl
loadSpriteToVDP_loop:
    outi
    jp nz,loadSpriteToVDP_loop
    ret


;-----------------------------------------------
; renders the player and other sprites:
renderSprites:
    ld hl,SPRATR2
    call SETWRT

    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a

    ld a,(game_cycle)
    and #01
    jr nz,renderSprites_reverse_order

    ld b,4*NUMBER_OF_SPRITES_USED
    ld hl,sprite_attributes
renderSprites_loop:
    outi
    jp nz,renderSprites_loop
    ret

renderSprites_reverse_order:
    ld hl,sprite_attributes+(NUMBER_OF_SPRITES_USED-1)*4
    ld de,-8
    ld a,NUMBER_OF_SPRITES_USED
renderSprites_loop_reverse_pre:
    ld b,4
renderSprites_loop_reverse:
    outi
    jp nz,renderSprites_loop_reverse
    add hl,de
    dec a
    jp nz,renderSprites_loop_reverse_pre
    ret


;-----------------------------------------------
; calculates the coordinates the sprite for an anemy or player bullet
; enemy/bullet structure pointed to by 'ix' (coordinates in ix+4 to ix+7, coordinates are returned in 'bc' and 'nz' is set if sprite is IN the screen
calculateSpriteScreenCoordinates:
    ld a,(scroll_map_y)
    ld b,a
    ld a,(ix+4)   ; sprite y
    sub b
    ; check if we are in screen range:
    jp m,calculateSpriteScreenCoordinates_outofbouds
    cp 23
    jp p,calculateSpriteScreenCoordinates_outofbouds
    add a,a
    add a,a
    add a,a
    ld b,a
    ld a,(ix+5)   ; sprite pixel y
    add a,b
    add a,15  ; we add (16-1) to skip the scoreboard and the -1 is because since sprites are rendered at (y+1) by the VDP (oh well...)
    ld b,a      ; sprite x
calculateSpriteScreenCoordinatesX:
    ld a,(scroll_map_x)
    ld c,a
    ld a,(ix+6)   ; sprite x
    sub c
    ; check if we are in screen range:
    jp m,calculateSpriteScreenCoordinates_outofbouds
    cp 31
    jp p,calculateSpriteScreenCoordinates_outofbouds
    add a,a
    add a,a
    add a,a
    ld c,a
    ld a,(ix+7)   ; sprite pixel x
    add a,c
    ld c,a      ; sprite y
    or 1    ; indicate the sprite was inside the screen
    ret
calculateSpriteScreenCoordinates_outofbouds:
    ld b,200
    xor a   ; indicate sprite was out of bounds
    ret


;-----------------------------------------------
; updates the position of an enemy of player bullet incrementing the x coordinate by "c" and the y coordinate by "b"
; "ix" points to the bulllet
moveSprite:
    ld a,(ix+5) ; get "pixel y"
    add a,b
    cp 8
    jp p,moveSprite_incrementY_tileChange
    or a
    jp m,moveSprite_decrementY_tileChange
    ld (ix+5),a
    jp moveSprite_x
moveSprite_incrementY_tileChange:
    sub 8
    ld (ix+5),a
    inc (ix+4)
    cp 8
    jp p,moveSprite_incrementY_tileChange
    jp moveSprite_x
moveSprite_decrementY_tileChange:
    add a,8
    ld (ix+5),a
    dec (ix+4)
    or a
    jp m,moveSprite_decrementY_tileChange
moveSprite_x:
    ld a,(ix+7)   ; get "pixel x"
    add a,c
    cp 8
    jp p,moveSprite_incrementX_tileChange
    or a
    jp m,moveSprite_decrementX_tileChange
    ld (ix+7),a
    ret
moveSprite_incrementX_tileChange:
    sub 8
    ld (ix+7),a
    inc (ix+6)
    cp 8
    jp p,moveSprite_incrementX_tileChange
    ret
moveSprite_decrementX_tileChange:
    add a,8
    ld (ix+7),a
    dec (ix+6)
    or a
    jp m,moveSprite_decrementX_tileChange
    ret


;-----------------------------------------------
; returns (in "BC") the coordinates in the map of this sprite (pointed by IX)
; the sprite can be a player bullet or an enemy
getSpriteMapCoordinates:
    ld b,(ix+4)
    ld a,(ix+5)
    cp 4
    jp m,getSpriteMapCoordinates_no_increase_in_y
    inc b
getSpriteMapCoordinates_no_increase_in_y:
    ld c,(ix+6)
    ld a,(ix+7)
    cp 4
    ret m
    inc c
    ret


;-----------------------------------------------
; Fades the current image in the screen (screen 2), including sprites, out
; notes: 
; 1) this function destroys the pattern attributes and the sprites
; 2) this function requires 3KB of the buffer memory to work
fadeOutPatternsAndSprites:
  ld hl,CLRTBL2
  ld de,buffer
  ld bc,256*8
  call LDIRMV
  ld hl,SPRTBL2
  ld de,buffer+256*8
  ld bc,32*32
  call LDIRMV
  
  xor a
fadeOutPatternsAndSprites_loop:
  push af
  ld hl,buffer
  ADD_HL_A_VIA_BC
  ld bc,(256*8+32*32)/8
  ld de,8
fadeOutPatternsAndSprites_inner_loop:
  ld (hl),0
  add hl,de
  dec bc
  ld a,c
  or b
  jp nz,fadeOutPatternsAndSprites_inner_loop

  call fadeOutPatternsAndSprites_copy_attributes
  pop af

  halt
  inc a
  cp 8
  jp nz,fadeOutPatternsAndSprites_loop

  xor a
  call FILLSCREEN
  jp clearAllTheSprites

fadeOutPatternsAndSprites_copy_attributes:
  ld hl,buffer+256*8
  ld de,SPRTBL2
  ld bc,32*32
  call LDIRVM

  ld hl,buffer
  ld de,CLRTBL2
  ld bc,256*8
  push hl
  push bc
  call LDIRVM
  pop bc
  pop hl
  ld de,CLRTBL2+256*8
  push hl
  push bc
  call LDIRVM
  pop bc
  pop hl
  ld de,CLRTBL2+512*8
  call LDIRVM  
  ret

