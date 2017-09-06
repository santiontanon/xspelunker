;-----------------------------------------------
; sets the target scroll variables to be centered around the player
centerScrollOnCharacterY_lower:
  ld a,(player_y)
  sub 6  ; a = (player_y/8)-6 ; to see 4 more tiles below
  jr centerScrollOnCharacterY2

centerScrollOnCharacterY:
  ; y coordinates:
  ld a,(player_y)
  sub 10  ; a = (player_y/8)-10
centerScrollOnCharacterY2:
  jp p,centerScrollOnCharacter_noUpLimit
  xor a
centerScrollOnCharacter_noUpLimit:
  ld hl,scroll_y_limit
  ld b,(hl)
  cp b
  jp m,centerScrollOnCharacter_noBottomLimit
  ld a,b
centerScrollOnCharacter_noBottomLimit:
  ld (target_scroll_map_y),a
  ret

centerScrollOnCharacterX:
  ; x coordinate:
  ld a,(player_x)
  sub 15  ; a = (player_x/8)-15
  jp p,centerScrollOnCharacter_noLeftLimit
  xor a
centerScrollOnCharacter_noLeftLimit:
  ld hl,scroll_x_limit
  ld b,(hl)
  cp b
  jp m,centerScrollOnCharacter_noRightLimit
  ld a,b
centerScrollOnCharacter_noRightLimit:
  ld (target_scroll_map_x),a
  ret


;-----------------------------------------------
; Moves the map toward the target scroll x and y positions
updateMapScroll:
  ld hl,scroll_map_y
  ld b,(hl)
  ld a,(target_scroll_map_y)
  cp b
  jp z,updateMapScroll_x
  jp p,updateMapScroll_inc_y
  dec (hl)
  xor a
  ld (need_to_redraw_map),a   ; trigger redraw
  jp updateMapScroll_x
updateMapScroll_inc_y:
  inc (hl)
  xor a
  ld (need_to_redraw_map),a   ; trigger redraw
updateMapScroll_x:
  inc hl
  ld b,(hl)
  ld a,(target_scroll_map_x)
  cp b
  ret z
  jp p,updateMapScroll_inc_x
  dec (hl)
  xor a
  ld (need_to_redraw_map),a   ; trigger redraw
  ret
updateMapScroll_inc_x:
  inc (hl)
  xor a
  ld (need_to_redraw_map),a   ; trigger redraw
  ret


;-----------------------------------------------
; Checks if the coordinates specified in (c,b) are out of bounds
checkCoordinatesOutOfBounds:
  ld a,(map_width)
  dec a
  cp c
  jp c,getMapCellPointerCheckingBounds_outOfBounds
  ld a,(map_height)
  dec a
  cp b
  jp c,getMapCellPointerCheckingBounds_outOfBounds
  xor a
  ret


;-----------------------------------------------
; Given x,y coordiantes in (c,b), this returns a pointer (in "HL") to the cell in the map
; - If the function is called as "getMapCellPointer" it does not check for out of bounds
; - If the function is called as "getMapCellPointerCheckingBounds", the pointer will be only computed if it's inside
;   of the bounds of the map. The "Z" flag is used to indicate this ("Z" means inside of map, and "NZ" means out of bounds)
getMapCellPointerCheckingBounds:
  ld a,(map_width)
  dec a
  cp c
  jp c,getMapCellPointerCheckingBounds_outOfBounds
  ld a,(map_height)
  dec a
  cp b
  jp c,getMapCellPointerCheckingBounds_outOfBounds
getMapCellPointer:
  ld h,0
  ld l,b  ; hl = y
  ld a,(map_width_log2)
  ld b,a
getMapCellPointer_loop:
  add hl,hl
  djnz getMapCellPointer_loop
;  ld b,0  ; at this point, since b = 0, we have that bc = x
  ld a,c
  or a
  jp p,getMapCellPointer_positive_x_offset
  ld b,#ff
getMapCellPointer_positive_x_offset:
  add hl,bc
  ld bc,map
  add hl,bc
  xor a ; "Z" flag to indicate we are inside the bounds of the map
  ret
;getMapCellPointerCheckingBounds_outOfBounds:
;  or 1  ; "NZ" flag to indicate we are out of bounds
;  ret


;-----------------------------------------------
; gets the content of a position in the map
; c: x, b: y in cell coordiantes
getMapCell:
  ld a,(map_width)
  dec a
  cp c
  jp c,getMapCell_outofbounds
  ld a,250  ; something very high, but below 255
  cp b
  jp c,getMapCell_outofbounds
  ld a,(map_height)
  dec a
  cp b
  jp c,getMapCell_outofbound_below
  call getMapCellPointer
  xor a ; set Z so, it's inside of bounds
  ld a,(hl)
  ret
getMapCell_outofbounds:
  or 1    ; we set NZ to be true (out of bounds)
  ld a,TILE_WALL_START
  ret
getMapCell_outofbound_below:
  or 1    ; we set NZ to be true (out of bounds)
  ld a,0  ;we cannot use "xor", since that will mess up the flags
  ret


;-----------------------------------------------
; checks whether the tile type specified in "a" is a vine
isVine:
  cp TILE_VINE_START
  jp c,isVine_false
  cp TILE_VINE_END+1
  jp nc,isVine_false
isVine_true:
getMapCellPointerCheckingBounds_outOfBounds:
  or 1
  ret
isHazard_false:
isWater_false:
isVine_false:
isWall_false:
isPlatform_false:
isIdolTile_false:
  xor a
  ret


;-----------------------------------------------
; checks whether the tile type specified in "a" is a hazard
isHazard:
  cp TILE_HAZARD_START
  jp c,isHazard_false
  cp TILE_HAZARD_END+1
  jp nc,isVine_false
  or 1
  ret


;-----------------------------------------------
; checks whether the tile type specified in "a" is water
isWater:
  cp TILE_WATER_START
  jp c,isWater_false
  cp TILE_WATER_END+1
  jp nc,isWater_false
  or 1
  ret


;-----------------------------------------------
; checks whether the tile type specified in "a" is a wall
isWall:
  cp TILE_WALL_START
  jp c,isWall_false
  or 1
  ret


;-----------------------------------------------
; checks whether the tile type specified in "a" is a platform
isPlatform:
  cp TILE_PLATFORM_START
  jp c,isPlatform_false
  cp TILE_PLATFORM_END+1
  jp nc,isPlatform_false
  or 1
  ret


;-----------------------------------------------
; checks whether the tile type specified in "a" is part of the "idol" item
isIdolTile:
  cp 104
  jp c,isIdolTile_false
  cp 108
  jp nc,isIdolTile_false
  or 1
  ret


;-----------------------------------------------
; updates all the animations in the map
updateMapAnimations:
  ld a,(game_cycle)
  ld iyl,a
  ld a,(map_n_animations)
  or a
  ret z
  ld b,a
  ld ix,map_animations
  ld de,ANIMATION_STRUCT_SIZE
updateMapAnimations_loop:
  ld a,b
  xor iyl ; we group the animations into 4 groups, and only update one group per frame
  and #03
  jp nz,updateMapAnimations_loop_continue
  dec (ix+4)
  jp z,updateMapAnimations_next_frame
updateMapAnimations_loop_continue:
  add ix,de
  djnz updateMapAnimations_loop
  ret

updateMapAnimations_next_frame:
  exx
  ld h,(ix)
  ld a,h
  or a    ; this is to check if the animation was destroyed by an explosion
  jp z,updateMapAnimations_next_frame_no_animation
  ld l,(ix+1)
  ld d,(ix+2)
  ld e,(ix+3)
  
  ld a,(hl)
  ld (ix+4),a ; reset the timer
  inc (ix+5)  ; next frame

  inc hl
  ld a,(hl)
  cp (ix+5)   ; check if we went beyond the last frame
  jp nz,updateMapAnimations_loop_set_Frame
  ld (ix+5),0
updateMapAnimations_loop_set_Frame:
  ld a,(ix+5)

  inc hl
  ADD_HL_A
  ld a,(hl) ; we cannot use "ldi", since it would modify "bc"
  ld (de),a
updateMapAnimations_next_frame_no_animation:
  exx
  jp updateMapAnimations_loop_continue


;-----------------------------------------------
; renders the map using (scroll_map_x) and (scroll_map_y) as the top-left coordinates
;renderMap:   
;  set the VDP for writing:
;  ld hl,NAMTBL2+32*2
;  call SETWRT
renderMap_no_swtwrt:
  ld a,(need_to_redraw_map)
  or a
  jp nz,renderMap_partially ; if we don't need to redraw the whole thing, at least draw a part of it (to keep animatinos flowing)
  ld hl,need_to_redraw_map
  ld (hl),1

  ; calculate the top-left offset of the map:
  ld a,(scroll_map_y)
  ld h,0
  ld l,a  ; hl = y
  ld a,(map_width_log2)
renderMap_topleft_loop:
  add hl,hl
  dec a
  jp nz,renderMap_topleft_loop
  ld a,(scroll_map_x)
  ADD_HL_A_VIA_BC
  ld bc,map
  add hl,bc

  ; calculate the vertical offset:
  ld a,(map_width)
  ld d,0
  ld e,a
  ld bc,-32
  ex de,hl
  add hl,bc
  ex de,hl
  
  ; get the VDP write register:
  ld a,(VDP.DW)
  ld c,a

  ; number of rows to copy:
  ld a,22
renderMap_loop:

  ; copy a row:
  ld b,32
renderMap_loop_outi: 
  outi
  jp nz,renderMap_loop_outi

  dec a
  ret z
  add hl,de
  jp renderMap_loop

renderMap_partially:
  ld hl,map_redrawing_cycle
  inc (hl)
  ld a,(hl)
  and #03   ; check wich of the 4 4ths of the map we will be rendering
  add a,a
  ld b,a
  add a,a
  add a,b   ; a = (map_redrawing_cycle)%4 * 6

  jp z,renderMap_partially_no_need_to_setwrt
  ld h,0
  ld l,a
  call HLTimes32
  ld bc,NAMTBL2+32*2
  add hl,bc   ; hl now points to the address we need to start drawing at
  push af
  call SETWRT
  pop af
renderMap_partially_no_need_to_setwrt:

  push af
  ; calculate the top-left offset of the map:
  ld hl,scroll_map_y
  add a,(hl)
  ld h,0
  ld l,a  ; hl = y
  ld a,(map_width_log2)
renderMap_partially_topleft_loop:
  add hl,hl
  dec a
  jp nz,renderMap_partially_topleft_loop
  ld a,(scroll_map_x)
  ADD_HL_A_VIA_BC
  ld bc,map
  add hl,bc

  ; calculate the vertical offset:
  ld a,(map_width)
  ld d,0
  ld e,a
  ld bc,-32
  ex de,hl
  add hl,bc
  ex de,hl
  
  ; get the VDP write register:
  ld a,(VDP.DW)
  ld c,a
  pop af

  ; number of rows to copy (only 6):
  cp 3*6
  jp z,renderMap_partially_last_part
  ld a,6
  jp renderMap_partially_loop
renderMap_partially_last_part:
  ld a,4
renderMap_partially_loop:

  ; copy a row:
  ld b,32
renderMap_lpartially_oop_outi: 
  outi
  jp nz,renderMap_lpartially_oop_outi

  dec a
  ret z
  add hl,de
  jp renderMap_partially_loop



;-----------------------------------------------
; checks if there is an animation in "hl", and if there is, it removes it
removeMapAnimation:
    ld a,(map_n_animations)
    or a
    ret z
    push bc
    push de
    push ix

    ld b,a
    ld ix,map_animations
    ld de,ANIMATION_STRUCT_SIZE
bombExplosion_loop_animations_loop:
    ld a,(ix+2) ; (ix+2) and (ix+3) contain a pointer to the tile the animation is controlling
    cp h
    jp nz,bombExplosion_loop_animations_no_match
    ld a,(ix+3)
    cp l
    jp nz,bombExplosion_loop_animations_no_match
    ld (ix),0 ; match! clear the animatino record
bombExplosion_loop_animations_no_match:
    add ix,de
    djnz bombExplosion_loop_animations_loop
    
    pop ix
    pop de
    pop bc
    ret
