;-----------------------------------------------
; This function uses a tile-based Procedural Content Generation (PCG) algorihm to generate a level
generateMapFromLevelSpecification:
  ; prepare the input to the map generator
  ld de,map_width_log2
  ldi
  ldi
  ldi
  ld de,pcg_width_in_chunks
  ldi
  ldi

  ld de,pcg_add_pinecones
  ld bc,10  ; 9 bytes for the probability of each enemy, pluse 1 byte for the minimum number of enemies
  ldir

  ld c,(hl)
  inc hl
  ld b,(hl) ; level chunk table to use
  push bc
  pop ix
  jp generateMap


generateMap:
  call generateMap_step1	; generate the level path
  call generateMap_step2	; generate the background
  call generateMap_step3	; add double rooms
  call generateMap_step4	; add foreground chunks
  call generateMap_step5	; beautify the map
  call generateMap_step6	; add enemies
  call generateMap_step7	; if an idol is required, add it to the map
  ; find all the animation tiles in the generated map:
  xor a
  ld (map_n_animations),a

  ld hl,map_animations
  ld de,map
  ld a,(map_height)
  ld c,a
generateMap_find_animations_loop1:
  ld a,(map_width)
  ld b,a
generateMap_find_animations_loop2:
  ld a,(de)
  cp 129  ; water tile
  jr z,generateMap_waterAnimationFound
  cp 13
  jr z,generateMap_torchAnimationFound
  cp 146
  jr z,generateMap_computerAnimationFound
  cp 124
  jr z,generateMap_beamEmitterAnimationFound
  cp 126
  jr z,generateMap_beamAnimationFound
generateMap_find_animations_loop2_continue:
  inc de
  djnz generateMap_find_animations_loop2
  dec c
  jr nz,generateMap_find_animations_loop1
  ret
generateMap_waterAnimationFound:
  ld (hl),animation_water/256
  inc hl
  ld (hl),animation_water%256
  inc hl
generateMap_animationFoundSecondPart:
  ld (hl),d
  inc hl
  ld (hl),e
  inc hl
  ld (hl),4 ; timer
  inc hl
  ld (hl),0 ; current frame
  inc hl
  push hl
  ld hl,map_n_animations
  inc (hl)
  pop hl
  jr generateMap_find_animations_loop2_continue
generateMap_torchAnimationFound:
  ld a,(current_level_section)
  cp 1
  jr nz,generateMap_find_animations_loop2_continue
  ld (hl),animation_torch/256
  inc hl
  ld (hl),animation_torch%256
  inc hl
  jr generateMap_animationFoundSecondPart
generateMap_computerAnimationFound:
  ld a,(current_level_section)
  cp 2
  jr nz,generateMap_find_animations_loop2_continue
  ld (hl),animation_computer/256
  inc hl
  ld (hl),animation_computer%256
  inc hl
  jr generateMap_animationFoundSecondPart
generateMap_beamEmitterAnimationFound:
  ld a,(current_level_section)
  cp 2
  jr nz,generateMap_find_animations_loop2_continue
  ld (hl),animation_beam_emitter/256
  inc hl
  ld (hl),animation_beam_emitter%256
  inc hl
  jr generateMap_animationFoundSecondPart
generateMap_beamAnimationFound:
  ld a,(current_level_section)
  cp 2
  jr nz,generateMap_find_animations_loop2_continue
  ld (hl),animation_beam/256
  inc hl
  ld (hl),animation_beam%256
  inc hl
  jr generateMap_animationFoundSecondPart


;-----------------------------------------------
; Generates the path the level should follow in "pcg_chunk_map_buffer"
; Note: for now this assumes we are generating a 4x4 level
generateMap_step1:
  ; STEP 1: - generate level path (in "pcg_chunk_map_buffer")
  ;	    - width and size in chunks is taken from (pcg_width_in_chunks),(pcg_height_in_chunks)
  ld hl,pcg_height_in_chunks
  ld b,(hl)
  dec b
  call random
  and b

  ; In the inner ruins: If the start y is the bottom chunk, restart (since that's under water)
  ld c,a
  ld a,(current_level_section)
  cp 2
  jr nz,generateMap_step1_not_inner_ruins
  ld a,(hl)
  dec a
  cp c
  jr z,generateMap_step1
generateMap_step1_not_inner_ruins:
  ld a,c

  xor a
  ld (pcg_path_length),a  ; pcg_path_length stores the length of the generate path
                          ; if the generate path is less than (pcg_width_in_chunks)+2, then we regenerate
                          ; since the path is too short.

  ; player initial position:
  push af
  add a,a
  add a,a
  add a,a
  add a,a	
  add a,6	; a = a*16+8
  ld (player_y),a
  ld a,1
  ld (player_x),a  
  pop af

  ld c,0
  ld b,a	; initial position
  ld hl,pcg_chunk_map_buffer
  or a
  jr z,generateMap_step1_pointer_calculated
  push af
  ld a,(pcg_width_in_chunks)
  ld d,0
  ld e,a
  pop af
generateMap_step1_calculate_starting_pointer:
  add hl,de
  dec a
  jr nz,generateMap_step1_calculate_starting_pointer
generateMap_step1_pointer_calculated:

  ld d,1	; "d" stores the previous direction in which we are moving
  		; "e" will store the new direction
  		; UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3
generateMap_step1_loop:
  push hl
  ld hl,pcg_path_length
  inc (hl)
  pop hl

  ld a,d
  cp 1		; is previous direction == RIGHT?
  jr nz,generateMap_step1_previous_was_not_right

generateMap_step1_previous_was_right:
  call random
  or a
  jr z,generateMap_step1_move_right
  push hl
  ld hl,pcg_height_in_chunks
  inc a
  cp (hl)	; if we are at the bottom, we need to more right
  pop hl
  jp m,generateMap_step1_move_down
generateMap_step1_move_up:
  ld e,0
  ld a,b
  or a		; if we are at the top, we need to move right
  jr z,generateMap_step1_move_right
  jr generateMap_step1_move
generateMap_step1_move_down:
  ld e,2
  ld a,b  
  push hl
  ld hl,pcg_height_in_chunks
  inc a
  cp (hl)	; if we are at the bottom, we need to more right
  pop hl
  jr z,generateMap_step1_move_right
  jr generateMap_step1_move
generateMap_step1_previous_was_not_right:
  call random
  or a
  jr z,generateMap_step1_move_right
  ld a,d	; keep moving in the same direction
  or a
  jr z,generateMap_step1_move_up
  jr generateMap_step1_move_down
generateMap_step1_move_right:
  ld e,1	
generateMap_step1_move: 
  push hl
  ld a,d
  add a,d
  add a,d
  add a,e	; a = previous_direction * 3 + current_direction
  ld hl,pcg_chunk_type_table
  ADD_HL_A
  ld a,(hl)
  pop hl
  ld (hl),a	; we write the chunk type in "pcg_chunk_map_buffer"

  ld a,e
  dec a
  jr z,generateMap_step1_update_pointers_right
  dec a
  jr z,generateMap_step1_update_pointers_down
generateMap_step1_update_pointers_up:
  push bc
  ld a,(pcg_width_in_chunks)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  pop bc
  dec b
  jr generateMap_step1_continue
generateMap_step1_update_pointers_right:
  inc hl
  inc c
  jr generateMap_step1_continue
generateMap_step1_update_pointers_down:
  push bc
  ld a,(pcg_width_in_chunks)
  ld b,0
  ld c,a
  add hl,bc
  pop bc
  inc b
generateMap_step1_continue:
  ld d,e	; previous_direction = current_direction
  ld a,(pcg_width_in_chunks)
  cp c
  jr nz,generateMap_step1_loop

  ; In the inner ruins: If the end y is the bottom chunk, restart (since that's under water)
  ld a,(current_level_section)
  cp 2
  jr nz,generateMap_step1_not_inner_ruins2
  ld a,(pcg_height_in_chunks)
  dec a
  cp b
  jp z,generateMap_step1
generateMap_step1_not_inner_ruins2:

  ld a,b
  ld (pcg_exit_y_coordinate),a	; store the last y coordinate to later generate the exit sign

  ld a,(pcg_width_in_chunks)
  add a,2
  ld b,a
  ld a,(pcg_path_length)
  cp b
  jp m,generateMap_step1

  ret


;-----------------------------------------------
; Adds the background to the map
generateMap_step2:
  ld a,16
  ld (pcg_current_chunk_width),a	; regular width chunks

  xor a
  ld (pcg_current_chunk_y),a
  ld (pcg_current_chunk_x),a

  ld bc,0	; c = chunk x, b = chunk y
  ld hl,map	; de will keep the pointer to the map corresponding to the current chunk
generateMap_step2_y_loop:
generateMap_step2_x_loop:
  ; add a chunk:
  ; - if b == 0, choose a chunk at random between those with tag: PCG_CHUNK_FG_BACKGROUND or PCG_CHUNK_FG_BACKGROUND+PCG_CHUNK_TOP
  ; - if b == (pcg_height_in_chunks)-1, choose a chunk at random between those with tag: PCG_CHUNK_FG_BACKGROUND or PCG_CHUNK_FG_BACKGROUND+PCG_CHUNK_BOTTOM
  ; - else, choose a chunk at random between those with tag: PCG_CHUNK_FG_BACKGROUND
  push hl
  ld a,b
  or a
  jr z,generateMap_step2_choose_top_chunk
  ld a,(pcg_height_in_chunks)
  dec a
  cp b
  jr z,generateMap_step2_choose_bottom_chunk
  jr generateMap_step2_choose_regular_chunk

generateMap_step2_continue:
  pop hl
  jr z,generateMap_step2_continue_no_chunk

generateMap_step2_continue_copy_chunk:
  ; copy the chunk to the map:
  call generateMap_copyCompressedChunkToMap

generateMap_step2_continue_no_chunk:

  ld a,(pcg_current_chunk_x)
  add a,16
  ld (pcg_current_chunk_x),a

  inc c		; increment the x coordinate
  ld de,16
  add hl,de	; increment the pointer to the map
  ld a,(pcg_width_in_chunks)
  cp c
  jr nz,generateMap_step2_x_loop

  xor a
  ld (pcg_current_chunk_x),a
  ld a,(pcg_current_chunk_y)
  add a,16
  ld (pcg_current_chunk_y),a

  ld c,0	; reset x coordinate
  inc b		; increment the y coordinate

  ex de,hl	; map pointer is now on "de"
  ld a,(map_width)
  ld h,0
  ld l,a
  call HLTimes16
  push bc
  ld b,0
  ld c,a
  xor a
  sbc hl,bc	; we subtract (map_width), so, now hl = (map_width)*15
  pop bc
  add hl,de	; increment the pointer to the map

  ld a,(pcg_height_in_chunks)
  cp b
  jr nz,generateMap_step2_y_loop
  ret

generateMap_step2_choose_top_chunk:
  ld hl,chunkFilter_background_top
  call chooseRandomChunk
  jr generateMap_step2_continue

generateMap_step2_choose_bottom_chunk:
  ld hl,chunkFilter_background_bottom
  call chooseRandomChunk
  jr generateMap_step2_continue

generateMap_step2_choose_regular_chunk:
  ld hl,chunkFilter_background
  call chooseRandomChunk
  jr generateMap_step2_continue


;-----------------------------------------------
; Add the double rooms to the map
generateMap_step3:
  ld a,32
  ld (pcg_current_chunk_width),a	; double size chunks

  xor a
  ld (pcg_current_chunk_y),a
  ld (pcg_current_chunk_x),a

  ld bc,0	; c = chunk x, b = chunk y
  ld hl,map	; de will keep the pointer to the map corresponding to the current chunk
generateMap_step3_y_loop:
generateMap_step3_x_loop:

  ld a,(pcg_width_in_chunks)
  dec a
  cp c
  jr z,generateMap_step3_continue_no_chunk	; we ignore the last column

  ; check if there is space for a double chunk:
  push hl
  ld hl,pcg_chunk_map_buffer
  ld a,(pcg_width_in_chunks)
  ld d,0
  ld e,a
  ld a,b
generateMap_step3_get_pointer_to_chunk_map_loop:
  or a
  jr z,generateMap_step3_get_pointer_to_chunk_map_done
  add hl,de
  dec a
  jr generateMap_step3_get_pointer_to_chunk_map_loop
generateMap_step3_get_pointer_to_chunk_map_done:
  ld d,0
  ld e,c
  add hl,de
  ld a,(hl)
  or a
  jr nz,generateMap_step3_no_space_for_double_chunk
  inc hl
  ld a,(hl)
  or a
  jr nz,generateMap_step3_no_space_for_double_chunk

  ; there is space!
  ; add one with probability 1 over 5:
  ld a,5
  call randomModuloA
  or a
  jr nz,generateMap_step3_no_space_for_double_chunk
  ; mark the spots as empty, so no more chunks are generated over it
  ld (hl),PCG_CHUNK_EMPTY
  dec hl
  ld (hl),PCG_CHUNK_EMPTY
  pop hl
  push hl
  ld a,b
  or a
  jr z,generateMap_step3_choose_top_doublechunk
  ld a,(pcg_height_in_chunks)
  dec a
  cp b
  jr z,generateMap_step3_choose_bottom_doublechunk
  jr generateMap_step3_choose_regular_doublechunk

generateMap_step3_no_space_for_double_chunk:
  pop hl
  jr generateMap_step3_continue_no_chunk

generateMap_step3_continue:
  pop hl
  jr z,generateMap_step3_continue_no_chunk

generateMap_step3_continue_copy_chunk:
  ; copy the chunk to the map:
  call generateMap_copyCompressedChunkToMap

  ; after writing a chunk, we need to increment x twice:
  ld a,(pcg_current_chunk_x)
  add a,16
  ld (pcg_current_chunk_x),a
  inc c		; increment the x coordinate
  ld de,16
  add hl,de	; increment the pointer to the map

generateMap_step3_continue_no_chunk:
  ld a,(pcg_current_chunk_x)
  add a,16
  ld (pcg_current_chunk_x),a
  inc c		; increment the x coordinate
  ld de,16
  add hl,de	; increment the pointer to the map

  ld a,(pcg_width_in_chunks)
  cp c
  jp nz,generateMap_step3_x_loop

  xor a
  ld (pcg_current_chunk_x),a
  ld a,(pcg_current_chunk_y)
  add a,16
  ld (pcg_current_chunk_y),a

  ld c,0
  inc b		; increment the y coordinate
  ld a,(map_width)
  ex de,hl
  ld h,0
  ld l,a
  call HLTimes16
  push bc
  ld b,0
  ld c,a
  xor a
  sbc hl,bc	; we subtract (map_width), so, now hl = (map_width)*15
  pop bc  
  add hl,de	; increment the pointer to the map

  ld a,(pcg_height_in_chunks)
  cp b
  jp nz,generateMap_step3_y_loop
  ret

generateMap_step3_choose_top_doublechunk:
  ld hl,chunkFilter_doublechunk_top
  call chooseRandomChunk
  jr generateMap_step3_continue

generateMap_step3_choose_bottom_doublechunk:
  ld hl,chunkFilter_doublechunk_bottom
  call chooseRandomChunk
  jr generateMap_step3_continue

generateMap_step3_choose_regular_doublechunk:
  ld hl,chunkFilter_doublechunk
  call chooseRandomChunk
  jr generateMap_step3_continue


;-----------------------------------------------
; Add the regular foreground chunks to the map
generateMap_step4:
  ld a,16
  ld (pcg_current_chunk_width),a	; regular size chunks

  xor a
  ld (pcg_current_chunk_y),a
  ld (pcg_current_chunk_x),a

  ld bc,0	; c = chunk x, b = chunk y
  ld hl,map	; de will keep the pointer to the map corresponding to the current chunk
generateMap_step4_y_loop:
generateMap_step4_x_loop:

  ; get the type of chunk we need
  push hl
  ld hl,pcg_chunk_map_buffer
  ld a,(pcg_width_in_chunks)
  ld d,0
  ld e,a
  ld a,b
generateMap_step4_get_pointer_to_chunk_map_loop:
  or a
  jr z,generateMap_step4_get_pointer_to_chunk_map_done
  add hl,de
  dec a
  jr generateMap_step4_get_pointer_to_chunk_map_loop
generateMap_step4_get_pointer_to_chunk_map_done:
  ld d,0
  ld e,c
  add hl,de
  ld a,(hl)
  ld (pcg_current_chunk_type),a
  pop hl

  push hl
  ld a,b
  or a
  jr z,generateMap_step4_choose_top_chunk
  ld a,(pcg_height_in_chunks)
  dec a
  cp b
  jr z,generateMap_step4_choose_bottom_chunk
  jr generateMap_step4_choose_regular_chunk

generateMap_step4_continue:
  pop hl
  jr z,generateMap_step4_continue_no_chunk

generateMap_step4_continue_copy_chunk:
  ; copy the chunk to the map:
  call generateMap_copyCompressedChunkToMap

generateMap_step4_continue_no_chunk:
  ld a,(pcg_current_chunk_x)
  add a,16
  ld (pcg_current_chunk_x),a
  inc c		; increment the x coordinate
  ld de,16
  add hl,de	; increment the pointer to the map

  ld a,(pcg_width_in_chunks)
  cp c
  jr nz,generateMap_step4_x_loop

  xor a
  ld (pcg_current_chunk_x),a
  ld a,(pcg_current_chunk_y)
  add a,16
  ld (pcg_current_chunk_y),a

  ld c,0
  inc b		; increment the y coordinate
  ld a,(map_width)
  ex de,hl
  ld h,0
  ld l,a
  call HLTimes16
  push bc
  ld b,0
  ld c,a
  xor a
  sbc hl,bc	; we subtract (map_width), so, now hl = (map_width)*15
  pop bc  
  add hl,de	; increment the pointer to the map

  ld a,(pcg_height_in_chunks)
  cp b
  jp nz,generateMap_step4_y_loop
  ret

generateMap_step4_choose_top_chunk:
  ld hl,chunkFilter_fg_top
  call chooseRandomChunk
  jr generateMap_step4_continue

generateMap_step4_choose_bottom_chunk:
  ld hl,chunkFilter_fg_bottom
  call chooseRandomChunk
  jr generateMap_step4_continue

generateMap_step4_choose_regular_chunk:
  ld hl,chunkFilter_fg
  call chooseRandomChunk
  jr generateMap_step4_continue


;-----------------------------------------------
; Beautify the map:
generateMap_step5:
  ld a,(current_level_section)
  or a
  ; call the appropriate function to beautify the maps:
  push af
  call z,generateMap_beautifyJungle
  pop af
  dec a
  push af
  call z,generateMap_beautifyOuterRuins
  pop af
  dec a
  call z,generateMap_beautifyInnerRuins  

  ; add the exit sign:  
  ld a,(pcg_exit_y_coordinate)
  add a,a
  add a,a
  add a,a
  add a,a
  add a,13
  ld b,a
  ld a,(map_width)
  sub 2
  ld c,a
generateMap_step5_loop:
  push bc
  call getMapCellPointer
  pop bc
  ld a,(hl)
  cp TILE_BG_END+1
  jp c,generateMap_step5_found_spot
  dec b
  jr nz,generateMap_step5_loop

  ; we should not reach here, but just in case!
  ld a,(pcg_exit_y_coordinate)
  add a,a
  add a,a
  add a,a
  add a,a
  add a,13
  ld b,a

generateMap_step5_found_spot:
  dec b
  ld a,b
  ld (pcg_exit_y_coordinate),a
  ld a,c
  ld (pcg_exit_x_coordinate),a

  ld (hl),37	; 35, 36, 37 and 38 are the patterns that make up the exit sign
  inc hl
  ld (hl),38
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  ld (hl),36
  dec hl
  ld (hl),35
  ret


;-----------------------------------------------
; Add enemies to the map
generateMap_step6:
  ; Iterate over the map (at x increments of 2) (ignoring the two first rows/columns, the last row and the last two columns):
  ; - If there is a branch: have 1 in 8 probability of having a pinecone underneath
  ; - If there is "right tree" and also below: 1 in 24 of having a monkey
  ; - If there is water here and to the right, and a 2x2 empty space above: 1 in 3 of a piranha
  ; - If rock here and right, and 2x2 space below: 1/40 of a bee nest
  ; - If there is wall here and right, and a 2x2 empty space above:
  ; 	- chance of a scorpion, Snake, Maya or Alien
  ;	  - otherwise 1/64 of a stone
  ;	  - otherwise 1/128 of an arrow
  ; - it (y%16) == 3, and there is a 2x2 empty space, then chance of adding a sentinel
  call drawAllItems           ; we first draw all items to the map, just in case there are boulders that affect walls
  ld a,(map_n_items)          ; store the value of (map_n_items) in case we need to re-execute this function
  ld (pcg_n_items_buffer),a
generateMap_step6_repeat:
;  ld hl,map+4
  ld a,(map_width)
  ld d,0
  ld e,a
;  add hl,de
;  add hl,de	; hl now points to the (4,2) position in the map
  ld bc,#0204	; starting coordinates, (4,2)
generateMap_step6_x_loop:
  ld hl,map
  ld b,0
  add hl,bc
  ld b,2
  add hl,de
  add hl,de
  xor a
  ld (pcg_n_monkeys_per_column),a
generateMap_step6_y_loop:
  push de
  ld a,(pcg_add_pinecones)
  or a
  call nz,generateMap_step6_pinecones
  ld a,(pcg_add_monkeys)
  or a
  call nz,generateMap_step6_monkeys
  ld a,(pcg_add_piranhas)
  or a
  call nz,generateMap_step6_piranhas
  ld a,(pcg_add_bee_nests)
  or a
  call nz,generateMap_step6_bee_nests
  ld a,(pcg_add_sentinels)
  or a
  call nz,generateMap_step6_sentinels
  call generateMap_step6_scorpions_or_supplies	; since scorpions and supplies have the same conditions, I add them in the same function to save time and space
  pop de

  inc b
  add hl,de
  ld a,(map_height)
  dec a
  cp b
  jr nz,generateMap_step6_y_loop
  inc c
  inc c
  ld a,(map_width)
  sub 2
  cp c
  jr nz,generateMap_step6_x_loop

;  inc c
;  inc c
;  inc hl
;  inc hl
;  ld a,(map_width)
;  sub 2
;  cp c
;  jr nz,generateMap_step6_x_loop
;  ld c,4
;  inc b
;  inc hl
;  inc hl
;  inc hl
;  inc hl
;  inc hl
;  inc hl
;  ld a,(map_height)
;  dec a
;  cp b
;  jr nz,generateMap_step6_y_loop

  ld a,(pcg_minimum_number_of_enemies)
  ld b,a
  ld a,(map_n_enemies)
  cp b
  jp p,generateMap_step6_number_of_enemies_ok
  ; there are less enemies than the minimum, so, we need to restart:
  xor a
  ld (map_n_enemies),a
  ld a,(pcg_n_items_buffer)
  ld (map_n_items),a
  jr generateMap_step6_repeat 
generateMap_step6_number_of_enemies_ok:
  ; we remove from the map all the items we drew temporarily (for this, we need to reset the "map_n_items" variable temporarilly)
  ld a,(map_n_items)
  push af
  ld a,(pcg_n_items_buffer)
  ld (map_n_items),a
  call removeAllItems
  pop af
  ld (map_n_items),a
  ret


generateMap_step6_pinecones:
  ; - If there is a branch: have 1 in 8 probability of having a pinecone underneath
  ld a,(hl)
  call isPlatform
  ret z
  ld a,(pcg_add_pinecones)
  call randomModuloA
  or a
  ret nz
  ; add a pinecone:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  ret z	; no more enemies fit
  push hl
  push iy
  pop hl
  ld (hl),ENEMY_PINECONE
  inc hl
  ld (hl),1
  xor a
  inc hl
  ld (hl),a
generateMap_step6_pinecone_second_part:
  inc hl
  ld (hl),a
  inc b
  inc hl
  ld (hl),b
  dec b
  inc hl
  ld (hl),a
  inc hl
  ld (hl),c
  inc hl
  ld (hl),a
  pop hl
  ret

generateMap_step6_monkeys:
  ; - If there is "right tree" and also below: 1 in 24 of having a monkey
  ld a,(pcg_n_monkeys_per_column)
  cp 2
  ret p ; if there are already 2 monkeys in a vertical line, stop!
  ld a,(hl)
  cp 13
  jr z,generateMap_step6_monkeys_tree1
  cp 23
  jr z,generateMap_step6_monkeys_tree1
  ret
generateMap_step6_monkeys_tree1:
  push bc
  push hl
  ld a,(map_width)
  ld b,0
  ld c,a
  add hl,bc
  ld a,(hl)
  pop hl
  pop bc
  cp 13
  jr z,generateMap_step6_monkeys_tree2
  cp 23
  jr z,generateMap_step6_monkeys_tree2
  ret
generateMap_step6_monkeys_tree2:
  ld a,(pcg_add_monkeys)
  call randomModuloA
  or a
  ret nz
  ; add a monkey:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  ret z	; no more enemies fit
  push hl
  ld hl,pcg_n_monkeys_per_column ; count the number of monkeys per vertical column
  inc (hl)
  push iy
  pop hl
  ld (hl),ENEMY_MONKEY
  inc hl
  ld (hl),1
  inc hl
  ld (hl),1
generateMap_step6_monkeys_style_enemy:
  xor a
  inc hl
  ld (hl),a
  inc hl
  ld (hl),b
  inc hl
  ld (hl),a
  inc hl
  ld (hl),c
  inc hl
  ld (hl),a
  pop hl
  ret 


generateMap_step6_piranhas:
  ; - If there is water here and to the right, and empty space above: 1 in 3 of a piranha
  ld a,(hl)
  call isWater
  ret z
  inc hl
  ld a,(hl)
  dec hl
  call isWater
  ret z
  ; we know there is water:
  push bc
  push hl
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  ld a,(hl)
  cp TILE_BG_END+1
  jp nc,generateMap_step6_piranhas_no_spaceabove
  xor a
  sbc hl,bc
  ld a,(hl)
  cp TILE_BG_END+1
  jp nc,generateMap_step6_piranhas_no_spaceabove
  pop hl
  pop bc
  ld a,(pcg_add_piranhas)
  call randomModuloA
  or a
  ret nz
  ; add a piranha:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  ret z	; no more enemies fit
  push hl
  push iy
  pop hl
  ld (hl),ENEMY_PIRANHA
  inc hl
  ld (hl),1 ; hp
  call random
  and #07f
  inc hl
  ld (hl),a ; state
  jp generateMap_step6_monkeys_style_enemy

generateMap_step6_bee_nests_no_spacebelow:
generateMap_step6_piranhas_no_spaceabove:
generateMap_step6_scorpions_or_supplies_no_spaceabove:
  pop hl
  pop bc
  ret


generateMap_step6_bee_nests:
  ; - If rock here and right, and 2x2 space below: 1/40 of a bee nest
  ld a,(hl)
;  call generateMap_isRock
;  ret z
  cp TILE_WALL_START
  ret c
  inc hl
  ld a,(hl)
  dec hl
;  call generateMap_isRock
;  ret z
  cp TILE_WALL_START
  ret c
  push bc
  push hl
  ld a,(map_width)
  ld b,0
  ld c,a
  add hl,bc
  ld a,(hl)
  cp TILE_BG_END+1
  jr nc,generateMap_step6_bee_nests_no_spacebelow
  inc hl
  ld a,(hl)
  cp TILE_BG_END+1
  jr nc,generateMap_step6_bee_nests_no_spacebelow
  pop hl
  pop bc
  ld a,(pcg_add_bee_nests)
  call randomModuloA
  or a
  ret nz
  ; add a bee nest:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  ret z	; no more enemies fit
  push hl
  push iy
  pop hl
  ld (hl),ENEMY_BEE_NEST
  inc hl
  ld (hl),3 ; hp
  call random
  inc hl
  ld (hl),a ; state timer
  xor a
  jp generateMap_step6_pinecone_second_part
;  inc hl
;  ld (hl),a
;  inc b
;  inc hl
;  ld (hl),b
;  dec b
;  inc hl
;  ld (hl),a
;  inc hl
;  ld (hl),c
;  inc hl
;  ld (hl),a
;  pop hl
;  ret

generateMap_step6_sentinels:
  ld a,b
  and #0f
  cp 3
  ret nz
  ld a,(hl)
  cp TILE_BG_END+1
  ret nc
  inc hl
  ld a,(hl)
  dec hl
  cp TILE_BG_END+1
  ret nc

  ld a,(pcg_add_sentinels)
  call randomModuloA
  or a
  ret nz

  ; add a sentinel:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  ret z ; no more enemies fit
  push hl
  push iy
  pop hl
  ld (hl),ENEMY_SENTINEL
  inc hl
  ld (hl),1 ; hp
  call random
  inc hl
  ld (hl),a ; state timer
  jp generateMap_step6_monkeys_style_enemy

generateMap_step6_scorpions_or_supplies:
  ; - If there is wall here and right, and a 2x2 empty space above:
  ; 	- 1/32 of a scorpion
  ;	- otherwise 1/64 of a stone
  ;	- otherwise 1/128 of an arrow
  ld a,(hl)
;  call generateMap_isRock
;  ret z
  cp TILE_WALL_START
  ret c
  inc hl
  ld a,(hl)
  dec hl
;  call generateMap_isRock
;  ret z
  cp TILE_WALL_START
  ret c
  push bc
  push hl
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  ld a,(hl)
  cp TILE_BG_END+1
  jp nc,generateMap_step6_scorpions_or_supplies_no_spaceabove
  inc hl
  ld a,(hl)
  cp TILE_BG_END+1
  jp nc,generateMap_step6_scorpions_or_supplies_no_spaceabove
  pop hl
  pop bc
  ld a,(pcg_add_scorpions)
  or a
  jr z,generateMap_step6_scorpions_or_supplies_no_scorpion
  ld a,(pcg_add_scorpions)
  call randomModuloA
  or a
  jr nz,generateMap_step6_scorpions_or_supplies_no_scorpion
  ; add a scorpion:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  jr z,generateMap_step6_scorpions_or_supplies_no_scorpion	; no more enemies fit
  push hl
  push iy
  pop hl
  ld (hl),ENEMY_SCORPION
generateMap_step6_scorpions_style_enemy:
  inc hl
  ld (hl),2 ; hp
  inc hl
  ld (hl),0 ; state timer
  call random
  and #01
  inc hl
  ld (hl),a ; state (left/right)
  dec b
  dec b
  inc hl
  ld (hl),b
  inc b
  inc b
  xor a
  inc hl
  ld (hl),a
  inc hl
  ld (hl),c
  inc hl
  ld (hl),a
  pop hl
  ret
generateMap_step6_scorpions_or_supplies_no_scorpion:

  ld a,(pcg_add_snakes)
  or a
  jr z,generateMap_step6_scorpions_or_supplies_no_snake
  ld a,(pcg_add_snakes)
  call randomModuloA
  or a
  jr nz,generateMap_step6_scorpions_or_supplies_no_snake
  ; add a snake:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  jr z,generateMap_step6_scorpions_or_supplies_no_snake  ; no more enemies fit
  push hl
  push iy
  pop hl
  ld (hl),ENEMY_SNAKE
  jr generateMap_step6_scorpions_style_enemy
;  inc hl
;  ld (hl),2 ; hp
;  inc hl
;  ld (hl),0 ; state timer
;  call random
;  and #01
;  inc hl
;  ld (hl),a ; state (left/right)
;  dec b
;  dec b
;  inc hl
;  ld (hl),b
;  inc b
;  inc b
;  xor a
;  inc hl
;  ld (hl),a
;  inc hl
;  ld (hl),c
;  inc hl
;  ld (hl),a  
;  pop hl
;  ret

generateMap_step6_scorpions_or_supplies_no_snake:

  ld a,(pcg_add_mayas)
  or a
  jr z,generateMap_step6_scorpions_or_supplies_no_maya
  ld a,(pcg_add_mayas)
  call randomModuloA
  or a
  jr nz,generateMap_step6_scorpions_or_supplies_no_maya
  ; add a maya:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  jr z,generateMap_step6_scorpions_or_supplies_no_maya  ; no more enemies fit
  push hl
  push iy
  pop hl
  ld (hl),ENEMY_MAYA
  jr generateMap_step6_scorpions_style_enemy
;  inc hl
;  ld (hl),2 ; hp
;  inc hl
;  ld (hl),0 ; state timer
;  call random
;  and #01
;  inc hl
;  ld (hl),a ; state (left/right)
;  dec b
;  dec b
;  inc hl
;  ld (hl),b
;  inc b
;  inc b
;  xor a
;  inc hl
;  ld (hl),a
;  inc hl
;  ld (hl),c
;  inc hl
;  ld (hl),a 
;  pop hl 
;  ret

generateMap_step6_scorpions_or_supplies_no_maya:
  ld a,(pcg_add_aliens)
  or a
  jr z,generateMap_step6_scorpions_or_supplies_no_alien
  ld a,(pcg_add_aliens)
  call randomModuloA
  or a
  jr nz,generateMap_step6_scorpions_or_supplies_no_alien
  ; add an alien:
  push bc
  push hl
  call spawnNewEnemy
  pop hl
  pop bc
  jr z,generateMap_step6_scorpions_or_supplies_no_alien  ; no more enemies fit
  push hl
  push iy
  pop hl
  ld (hl),ENEMY_ALIEN
  jp generateMap_step6_scorpions_style_enemy

generateMap_step6_scorpions_or_supplies_no_alien:  

  call random
  and #3f	; 1/64th
  jr nz,generateMap_step6_scorpions_or_supplies_no_stone
  ld a,ITEM_STONE
  jr generateMap_step6_scorpions_or_supplies_item2
;  dec b
;  dec b
;  push hl
;  call spawnItemInMapPCG
;  pop hl
;  inc b
;  inc b
;  ret
generateMap_step6_scorpions_or_supplies_no_stone:
  call random
  and #7f	; 1/128th
  ret nz
  ld a,ITEM_ARROW
generateMap_step6_scorpions_or_supplies_item2:
  dec b
  dec b
  push hl
  call spawnItemInMapPCG
  pop hl
  inc b
  inc b
  ret


;-----------------------------------------------
; If an idol is required, add it to the map
; For adding the idol, it does the following: 
; - pick an X position at random (multiple of 2)
; - go down until a suitable location is found (space over wall)
; - if we reach the bottom of the map, we start again
generateMap_step7:
  ld a,(pcg_button_in_map)
  or a
  ret z

generateMap_step7_we_need_an_idol:
  ld a,(map_width)
  call randomModuloA
  and #fe	; we make it an even number
  ld b,2
  ld c,a
  push bc
  call getMapCellPointer
  pop bc
generateMap_step7_loop:
  ld a,(hl)
  call generateMap_isRock
  jr z,generateMap_step7_not_a_good_position
  inc hl
  ld a,(hl)
  dec hl
  call generateMap_isRock
  jr z,generateMap_step7_not_a_good_position
  push bc
  push hl
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  ld a,(hl)
  cp TILE_BG_END+1
  jr nc,generateMap_step7_not_a_good_position_pop
  inc hl
  ld a,(hl)
  cp TILE_BG_END+1
  jr nc,generateMap_step7_not_a_good_position_pop
  pop hl
  pop bc
  ; Add idol!
  ld a,ITEM_IDOL
  dec b
  dec b
  call spawnItemInMapPCG
  ret
generateMap_step7_not_a_good_position_pop:
  pop hl
  pop bc
generateMap_step7_not_a_good_position:
  inc b
  ld a,(map_height)
  cp b
  jr z,generateMap_step7_we_need_an_idol	; we have reached the bottom of the map
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  add hl,bc
  pop bc
  jr generateMap_step7_loop


;-----------------------------------------------
; Jungle-specific: 
; - completes all the tree trunks all the way to the top of the map
; - replaces the generic rock tile by the appropriate tile (top, bottom, left, right, corner, etc.)
generateMap_beautifyJungle:
  ; Complete trees: for each map column:
  ; - filling = 0 (iy_l)
  ; - start at the bottom, and go up until the top:
  ;   - if a left trunk is found (13,23) -> filling = 1
  ;   - if a right trunk is found (14,24) -> filling = 2
  ;   - if a tree stopper is found (15,16) -> filling = 0
  ;   - if foliage is found (17,18,26,27) -> abord column
  ;   - if tile == 0 and filling == 1 -> add random left trunk (13,23)
  ;   - if tile == 0 filling == 2 -> add random right trunk (13,23)
  ld iyl,0	; filling = 0
  ld c,0
  ld a,(map_height)
  dec a
  ld b,a
  push bc
  call getMapCellPointer
  pop bc
  ld (pcg_current_map_pointer),hl
generateMap_beautifyJungle_x_loop:
generateMap_beautifyJungle_y_loop:
  ld a,(hl)
  cp 12
  jr z,generateMap_beautifyJungle_left_trunk_found
  cp 22
  jr z,generateMap_beautifyJungle_left_trunk_found
  cp 13
  jr z,generateMap_beautifyJungle_right_trunk_found
  cp 23
  jr z,generateMap_beautifyJungle_right_trunk_found
  cp 14
  jr z,generateMap_beautifyJungle_tree_stopper_found
  cp 15
  jr z,generateMap_beautifyJungle_tree_stopper_found
  cp 17
  jr z,generateMap_beautifyJungle_tree_stopper_found
  cp 18
  jr z,generateMap_beautifyJungle_tree_stopper_found
  cp 26
  jr z,generateMap_beautifyJungle_tree_stopper_found
  cp 27
  jr z,generateMap_beautifyJungle_tree_stopper_found
  cp 145	; if it's a default rock
  jr z,generateMap_beautifyJungle_rock_found
  cp 146	; if it's a default rock
  jr z,generateMap_beautifyJungle_rock_found
  or a
  jr nz,generateMap_beautifyJungle_loop_continue 

  ld a,iyl
  or a
  jr z,generateMap_beautifyJungle_loop_continue
  dec a
  jr z,generateMap_beautifyJungle_set_left_trunk
generateMap_beautifyJungle_set_right_trunk
  call random
  or #01
  jr z,generateMap_beautifyJungle_set_right_trunk_b
  ld (hl),13
  jr generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_set_right_trunk_b:
  ld (hl),23
  jr generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_set_left_trunk:
  call random
  or #01
  jr z,generateMap_beautifyJungle_set_left_trunk_b
  ld (hl),12
  jr generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_set_left_trunk_b:
  ld (hl),22
generateMap_beautifyJungle_loop_continue:
  dec b
  jr z,generateMap_beautifyJungle_y_loop_done
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  pop bc
  jr generateMap_beautifyJungle_y_loop
generateMap_beautifyJungle_y_loop_done:
  ld hl,(pcg_current_map_pointer)
  inc hl
  ld (pcg_current_map_pointer),hl
  ld iyl,0
  ld a,(map_height)
  dec a
  ld b,a
  inc c
  ld a,(map_width)
  cp c
  jr nz,generateMap_beautifyJungle_x_loop
  ret

generateMap_beautifyJungle_left_trunk_found:
  ld iyl,1
  jr generateMap_beautifyJungle_loop_continue

generateMap_beautifyJungle_right_trunk_found:
  ld iyl,2
  jr generateMap_beautifyJungle_loop_continue

generateMap_beautifyJungle_tree_stopper_found:
  ld iyl,0
  jr generateMap_beautifyJungle_loop_continue

generateMap_beautifyJungle_rock_found:
  ; 1) If x>0 and there is NO rock to the left
  ;     1a) otherwise, if y>0 and there is NO rock above: put a 140
  ;     1b) if y<(map_height)-1 and there is NO rock below: put a 148
  ;     1c) otherwise: put a 144
  ; 2) Otherwise, if x<(map_width)-1 and there is NO rock to the right
  ;     2a) otherwise, if y>0 and there is NO rock above: put a 143
  ;     2b) if y<(map_height)-1 and there is NO rock below: put a 151
  ;     2c) otherwise: put a 147
  ; 3) Otherwise, 
  ;     3a) if y>0 and there is NO rock above: put 141, 142
  ;     3b) Otherwise, if y<(map_height)-1 and there is NO rock below: put 149, 150
  ;     3c) Otherwise: put 145, 146
  ld a,c
  or a
  jr z,generateMap_beautifyJungle_rock_found_2_rock_left
  dec hl
  ld a,(hl)
  inc hl
  call generateMap_isRock
  jr nz,generateMap_beautifyJungle_rock_found_2_rock_left
  ; 1) there is no rock to the left:
  ld a,b
  or a
  jr z,generateMap_beautifyJungle_rock_found_1b_rock_above
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  ld a,(hl)
  add hl,bc
  pop bc
  call generateMap_isRock
  jr nz,generateMap_beautifyJungle_rock_found_1b_rock_above
  ; 1a) there is no rock above:
  ld (hl),140
  jr generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_rock_found_1b_rock_above:
  ld a,(map_height)
  dec a
  cp b
  jr z,generateMap_beautifyJungle_rock_found_1c_rock_below
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  add hl,bc
  ld a,(hl)
  sbc hl,bc
  pop bc
  call generateMap_isRock
  jr nz,generateMap_beautifyJungle_rock_found_1c_rock_below
  ; 1b) there is no rock below:
  ld (hl),148
  jr generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_rock_found_1c_rock_below:
  ; 1c) rock above and below
  ld (hl),144
  jr generateMap_beautifyJungle_loop_continue

generateMap_beautifyJungle_rock_found_2_rock_left:
  ld a,(map_width)
  dec a
  cp c
  jr z,generateMap_beautifyJungle_rock_found_3_rock_right
  inc hl
  ld a,(hl)
  dec hl
  call generateMap_isRock
  jr nz,generateMap_beautifyJungle_rock_found_3_rock_right
  ; 2) there is no rock to the right:
  ld a,b
  or a
  jr z,generateMap_beautifyJungle_rock_found_2b_rock_above
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  ld a,(hl)
  add hl,bc
  pop bc
  call generateMap_isRock
  jr nz,generateMap_beautifyJungle_rock_found_2b_rock_above
  ; 2a) there is no rock above:
  ld (hl),143
  jp generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_rock_found_2b_rock_above:
  ld a,(map_height)
  dec a
  cp b
  jr z,generateMap_beautifyJungle_rock_found_2c_rock_below
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  add hl,bc
  ld a,(hl)
  sbc hl,bc
  pop bc
  call generateMap_isRock
  jr nz,generateMap_beautifyJungle_rock_found_2c_rock_below
  ; 2b) there is no rock below:
  ld (hl),151
  jp generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_rock_found_2c_rock_below:
  ; 2c) rock above and below
  ld (hl),147
  jp generateMap_beautifyJungle_loop_continue

generateMap_beautifyJungle_rock_found_3_rock_right:
  ld a,b
  or a
  jr z,generateMap_beautifyJungle_rock_found_3b_rock_above
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  ld a,(hl)
  add hl,bc
  pop bc
  call generateMap_isRock
  jr nz,generateMap_beautifyJungle_rock_found_3b_rock_above
  ; 3a) there is no rock above:
  call random
  and #01
  add a,141  
  ld (hl),a
  jp generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_rock_found_3b_rock_above:
  ld a,(map_height)
  dec a
  cp b
  jr z,generateMap_beautifyJungle_rock_found_3c_rock_below
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  add hl,bc
  ld a,(hl)
  sbc hl,bc
  pop bc
  call generateMap_isRock
  jr nz,generateMap_beautifyJungle_rock_found_3c_rock_below
  ; 3b) there is no rock below:
  call random
  and #01
  add a,149
  ld (hl),a
  jp generateMap_beautifyJungle_loop_continue
generateMap_beautifyJungle_rock_found_3c_rock_below:
  ; 3c) rock above and below
  call random
  and #01
  add a,145
  ld (hl),a
  jp generateMap_beautifyJungle_loop_continue

generateMap_isRock:
  cp 140
  jp m,generateMap_isRock_noRock
  cp 152
  jp p,generateMap_isRock_noRock
generateMap_isRock_rock:
  or 1
  ret
generateMap_isRock_noRock:
  xor a
  ret


;-----------------------------------------------
; Outer ruins-specific:
; - completes ropes all the way to the top
; - randomizes rubble tiles
; - randomize brick tiles
generateMap_beautifyOuterRuins:
  ld iyl,0  ; filling = 0
  ld c,0
  ld a,(map_height)
  dec a
  ld b,a
  push bc
  call getMapCellPointer
  pop bc
  ld (pcg_current_map_pointer),hl
generateMap_beautifyOuterRuins_x_loop:
generateMap_beautifyOuterRuins_y_loop:
  ld a,b
  cp -1
  jr z,generateMap_beautifyOuterRuins_y_loop_done
  ld a,(hl)
  cp 132
  jr z,generateMap_beautifyOuterRuins_rope_found
  cp 133
  jr z,generateMap_beautifyOuterRuins_rope_found
  cp 134
  jr z,generateMap_beautifyOuterRuins_rope_found
  cp 160
  jr z,generateMap_beautifyOuterRuins_rubble_found
  cp 157
  jr z,generateMap_beautifyOuterRuins_thin_brick_found
  cp 149
  jr z,generateMap_beautifyOuterRuins_thick_brick_found
  cp TILE_BG_END+1
  jr nc,generateMap_beautifyOuterRuins_non_bg_found
  ld a,iyl
  or a
  jr z,generateMap_beautifyOuterRuins_loop_continue
  ; continue ropes/cables
  ld a,(current_level_section)
  cp 2
  jr nz,generateMap_beautifyOuterRuins_ropes
generateMap_beautifyOuterRuins_cables:
  ld (hl),132
  jr generateMap_beautifyOuterRuins_loop_continue
generateMap_beautifyOuterRuins_ropes:
  call random
  or #07
  jr z,generateMap_beautifyOuterRuins_set_rope_b
  ld (hl),134
generateMap_beautifyOuterRuins_loop_continue:
  dec b
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  pop bc
  jr generateMap_beautifyOuterRuins_y_loop
generateMap_beautifyOuterRuins_y_loop_done:
  ld hl,(pcg_current_map_pointer)
  inc hl
  ld (pcg_current_map_pointer),hl
  ld iyl,0
  ld a,(map_height)
  dec a
  ld b,a
  inc c
  ld a,(map_width)
  cp c
  jr nz,generateMap_beautifyOuterRuins_x_loop
  ret

generateMap_beautifyOuterRuins_set_rope_b:
  ld (hl),132
  jr generateMap_beautifyOuterRuins_loop_continue

generateMap_beautifyOuterRuins_rope_found:
  ld iyl,1
  jr generateMap_beautifyOuterRuins_loop_continue

generateMap_beautifyOuterRuins_rubble_found:
  call random
  and #03
  add a,160
  ld (hl),a
;  jr generateMap_beautifyOuterRuins_loop_continue

generateMap_beautifyOuterRuins_non_bg_found:
  ld a,iyl
  or a
  jr z,generateMap_beautifyOuterRuins_loop_continue
  ld a,(hl)
  cp 136
  jr z,generateMap_beautifyOuterRuins_non_bg_found_replace_platform_by_rope
  cp 137
  jr z,generateMap_beautifyOuterRuins_non_bg_found_replace_platform_by_rope
  ld iyl,0
  jr generateMap_beautifyOuterRuins_loop_continue
generateMap_beautifyOuterRuins_non_bg_found_replace_platform_by_rope:
  ld a,135
  ld (hl),a
  ld iyl,0
  jr generateMap_beautifyOuterRuins_loop_continue

generateMap_beautifyOuterRuins_thin_brick_found:
  ld a,3
  call randomModuloA
  add a,157
  ld (hl),a
  jr generateMap_beautifyOuterRuins_non_bg_found

generateMap_beautifyOuterRuins_thick_brick_found:
  ld a,3
  call randomModuloA
  or a
  jr z,generateMap_beautifyOuterRuins_thick_brick_found0
  dec a
  jr z,generateMap_beautifyOuterRuins_thick_brick_found1
generateMap_beautifyOuterRuins_thick_brick_found2:
  ld (hl),155
  push hl
  push bc
  ld b,0
  ld a,(map_width)
  ld c,a
  add hl,bc
  ld (hl),151
  pop bc
  pop hl
  jr generateMap_beautifyOuterRuins_non_bg_found
generateMap_beautifyOuterRuins_thick_brick_found0:
  ld (hl),150
  jr generateMap_beautifyOuterRuins_thick_brick_found1b
generateMap_beautifyOuterRuins_thick_brick_found1:
  ld (hl),149
generateMap_beautifyOuterRuins_thick_brick_found1b:
  push hl
  push bc
  ld b,0
  ld a,(map_width)
  ld c,a
  add hl,bc
  ld (hl),152
  pop bc
  pop hl
  jr generateMap_beautifyOuterRuins_non_bg_found


;-----------------------------------------------
; Inner ruins-specific:
; - completes cables all the way to the top
; - randomizes rubble tiles
; - randomize brick tiles
; - complete the vertical beams
; - fix the platforms
; - fill the bottom of the level with water
generateMap_beautifyInnerRuins:
  call generateMap_beautifyOuterRuins
  ld iyl,0  ; filling = 0
  ld c,0
  ld a,(map_height)
  dec a
  ld b,a
  push bc
  call getMapCellPointer
  pop bc
  ld (pcg_current_map_pointer),hl
generateMap_beautifyInnerRuins_x_loop:
generateMap_beautifyInnerRuins_y_loop:
  ld a,b
  cp -1
  jr z,generateMap_beautifyInnerRuins_y_loop_done
  ld a,(hl)
  cp 59
  jr z,generateMap_beautifyInnerRuins_verticalBeam_found
  cp 137
  jp z,generateMap_beautifyInnerRuins_platform_found
  cp TILE_BG_END+1
  jp nc,generateMap_beautifyInnerRuins_non_bg_found
  ld a,iyl
  or a
  jr z,generateMap_beautifyInnerRuins_loop_continue
  call random
  and #03
  dec a
  jr z,generateMap_beautifyInnerRuins_set_beam_b
  dec a
  jr z,generateMap_beautifyInnerRuins_set_beam_c
  ld (hl),47
  inc hl
  ld (hl),64
  dec hl
generateMap_beautifyInnerRuins_loop_continue:
  dec b
  push bc
  ld a,(map_width)
  ld b,0
  ld c,a
  xor a
  sbc hl,bc
  pop bc
  jr generateMap_beautifyInnerRuins_y_loop
generateMap_beautifyInnerRuins_y_loop_done:
  ld hl,(pcg_current_map_pointer)
  inc hl
  ld (pcg_current_map_pointer),hl
  ld iyl,0
  ld a,(map_height)
  dec a
  ld b,a
  inc c
  ld a,(map_width)
  cp c
  jr nz,generateMap_beautifyInnerRuins_x_loop

  ; fill the bottom with water:
  ld c,0
  ld a,(map_height)
  sub 15
  ld b,a
  call getMapCellPointer
  ld a,(map_width)
  ld b,a
generateMap_beautifyInnerRuins_water_loop1:
  ld a,(hl)
  cp TILE_BG_END+1
  jr nc,generateMap_beautifyInnerRuins_water_loop1_no_bg
  ld (hl),129
generateMap_beautifyInnerRuins_water_loop1_no_bg:
  inc hl
  djnz generateMap_beautifyInnerRuins_water_loop1

  ld c,14
generateMap_beautifyInnerRuins_water_loop2y:
  ld a,(map_width)
  ld b,a
generateMap_beautifyInnerRuins_water_loop2x:
  ld a,(hl)
  cp 129
  jr z,generateMap_beautifyInnerRuins_water_loop2_water
  cp TILE_BG_END+1
  jr nc,generateMap_beautifyInnerRuins_water_loop2_no_bg
generateMap_beautifyInnerRuins_water_loop2_water:
  ld (hl),128
generateMap_beautifyInnerRuins_water_loop2_no_bg:
  inc hl
  djnz generateMap_beautifyInnerRuins_water_loop2x
  dec c
  jr nz,generateMap_beautifyInnerRuins_water_loop2y
  ret

generateMap_beautifyInnerRuins_verticalBeam_found:
  ld iyl,1
  jr generateMap_beautifyInnerRuins_loop_continue

generateMap_beautifyInnerRuins_set_beam_b:
  ld (hl),59
  inc hl
  ld (hl),60
  dec hl
  jr generateMap_beautifyInnerRuins_loop_continue

generateMap_beautifyInnerRuins_set_beam_c:
  ld (hl),61
  inc hl
  ld (hl),62
  dec hl
  jr generateMap_beautifyInnerRuins_loop_continue

generateMap_beautifyInnerRuins_non_bg_found:
  ld iyl,0
  jr generateMap_beautifyInnerRuins_loop_continue

generateMap_beautifyInnerRuins_platform_found:
  dec hl
  ld a,(hl)
  inc hl
  call isPlatform
  jr z,generateMap_beautifyInnerRuins_platform_found_left
  inc hl
  ld a,(hl)
  dec hl
  call isPlatform
  jr z,generateMap_beautifyInnerRuins_platform_found_right
  call random
  and #03
  jp nz,generateMap_beautifyInnerRuins_loop_continue
  ld (hl),138
  jp generateMap_beautifyInnerRuins_loop_continue
generateMap_beautifyInnerRuins_platform_found_left:
  ld (hl),136
  jp generateMap_beautifyInnerRuins_loop_continue
generateMap_beautifyInnerRuins_platform_found_right:
  ld (hl),139
;;  jp generateMap_beautifyInnerRuins_loop_continue
  jr generateMap_beautifyInnerRuins_non_bg_found


;-----------------------------------------------
; Given a chunk filter in "hl", and the chunk table in "ix" choose a random chunk
; The selected chunk is returned in "de", and "NZ" is set
; If no chunk was selected, then "Z" is set
chooseRandomChunk:
  push bc
  push ix
  ld b,(ix) ; number of chunks
  ld c,0    ; number of candidates
  inc ix
chooseRandomChunk_loop1:	; in the first loop we find and count candidates
  ld a,(ix)
  call callFilter
  jr nz,chooseRandomChunk_loop1_not_passed
  inc c
chooseRandomChunk_loop1_not_passed:
  inc ix
  inc ix
  inc ix
  djnz chooseRandomChunk_loop1
  pop ix
  ld a,c  ; number of chunks that passed the filter
  pop bc
  or a
  ret z

  call randomModuloA	; select one at random

  push bc
  ld c,a
  inc c		; we increment it in 1, to make the check later easier
  push ix
  inc ix
chooseRandomChunk_loop2:	; in this second loop, we iterate until arriving at the selected chunk
  ld a,(ix)
  call callFilter
  jr nz,chooseRandomChunk_loop2_not_passed
  dec c
  jr z,chooseRandomChunk_chunk_found
chooseRandomChunk_loop2_not_passed:
  inc ix
  inc ix
  inc ix
  jr chooseRandomChunk_loop2	
chooseRandomChunk_chunk_found:
  ld d,(ix+2)	; we get the pointer to the chunk
  ld e,(ix+1)
  pop ix
  pop bc
  or 1	; indicate we found the chunk
  ret


;-----------------------------------------------
; Filters that select certain chunks depending on their type
callFilter:	; this is an auxiliary function, so that I can do "ret" in the filters
  jp (hl)

chunkFilter_background_top:
  cp PCG_CHUNK_BACKGROUND
  ret z
  cp PCG_CHUNK_BACKGROUND+PCG_CHUNK_TOP
  ret

chunkFilter_background:
  cp PCG_CHUNK_BACKGROUND
  ret

chunkFilter_background_bottom:
  cp PCG_CHUNK_BACKGROUND
  ret z
  cp PCG_CHUNK_BACKGROUND+PCG_CHUNK_BOTTOM
  ret

chunkFilter_doublechunk_top:
  cp PCG_CHUNK_DOUBLE_ROOM
  ret z
  cp PCG_CHUNK_DOUBLE_ROOM+PCG_CHUNK_TOP
  ret

chunkFilter_doublechunk:
  cp PCG_CHUNK_DOUBLE_ROOM
  ret

chunkFilter_doublechunk_bottom:
  cp PCG_CHUNK_DOUBLE_ROOM
  ret z
  cp PCG_CHUNK_DOUBLE_ROOM+PCG_CHUNK_BOTTOM
  ret

chunkFilter_fg_top:
  push bc
  ld b,a
  ld a,(pcg_current_chunk_type)
  or a
  jr z,chunkFilter_fg_top_any
  cp b
  jr z,chunkFilter_fg_top_filter_pass
  add a,PCG_CHUNK_TOP
  cp b
chunkFilter_fg_top_filter_pass:
  ld a,b
  pop bc
  ret
chunkFilter_fg_top_any:
  ld a,b
;  cp PCG_CHUNK_FG_TYPE6+1
;  jp m,chunkFilter_fg_any_pass
  and #7f   ; clear the bit that represents "TOP"
  cp PCG_CHUNK_FG_TYPE6+1
  jp c,chunkFilter_fg_any_pass
  or 1	; fail
  ld a,b
  pop bc
  ret

chunkFilter_fg:
  push bc
  ld b,a
  ld a,(pcg_current_chunk_type)
  or a
  jr z,chunkFilter_fg_any
  cp b
  ld a,b
  pop bc
  ret
chunkFilter_fg_any:
  ld a,b
  cp PCG_CHUNK_FG_TYPE6+1
  jp c,chunkFilter_fg_any_pass
  or 1	; fail
  ld a,b
  pop bc
  ret
chunkFilter_fg_any_pass:
  xor a ; success
  ld a,b
  pop bc
  ret  


chunkFilter_fg_bottom:
  push bc
  ld b,a
  ld a,(pcg_current_chunk_type)
  or a
  jr z,chunkFilter_fg_bottom_any
  cp b
  jr z,chunkFilter_fg_top_filter_pass
  add a,PCG_CHUNK_BOTTOM
  cp b
  ld a,b
  pop bc
  ret
chunkFilter_fg_bottom_any:
  ld a,b
;  cp PCG_CHUNK_FG_TYPE6+1
;  jp m,chunkFilter_fg_any_pass
  res 6,a	; clear the bit that represents "BOTTOM"
  cp PCG_CHUNK_FG_TYPE6+1
  jp c,chunkFilter_fg_any_pass
  or 1	; fail
  ld a,b
  pop bc
  ret


;-----------------------------------------------
; Copies a compressed chunk pointed by "de" to the map position "hl"
generateMap_copyCompressedChunkToMap:
  push bc
  push de
  push hl
  push ix
  ex de,hl
  ld de,buffer2
  call pletter_unpack
  pop ix
  pop hl
  pop de
  pop bc

  ; copy the chunk map data:
  push hl
  push de
  push bc

  ld de,buffer2

  ld b,16
generateMap_copyCompressedChunkToMap_loop:
  push bc
  ex de,hl
  ld a,(pcg_current_chunk_width)
  ld b,a
generateMap_copyCompressedChunkToMap_inner_loop:
  ld a,(hl)
  inc hl
  or a  
  jr z,generateMap_copyCompressedChunkToMap_inner_loop_skip
  ld (de),a
generateMap_copyCompressedChunkToMap_inner_loop_skip:
  inc de
  djnz generateMap_copyCompressedChunkToMap_inner_loop

  ld a,(pcg_current_chunk_width)
  ld b,a
  ld a,(map_width)
  sub b
  ld b,0
  ld c,a
  ex de,hl
  add hl,bc
  pop bc
  djnz generateMap_copyCompressedChunkToMap_loop

  ; copy the chunk enemies and items:
  ; Note: this is all commented out, since I eneded up not adding any enemy
  ;       to any of the chunks
;  ld a,(de)
  inc de
;  or a
;  jr z,generateMap_copyCompressedChunkToMap_no_more_enemies
;  ld b,a
;
;  ld a,(map_n_enemies)
;  ld h,0
;  ld l,a
;  add hl,hl
;  add hl,hl
;  add hl,hl	; hl = (map_n_enemies)*8
;  push de
;  ld de,map_enemies
;  add hl,de
;  pop de
;
;  add a,b
;  ld (map_n_enemies),a
;
;  ex de,hl	; we swap so we can use "ldir", now "hl" points to the chunk, and "de" to the map_enemies
;generateMap_copyCompressedChunkToMap_copy_enemies_loop:
;  push bc
;  ldi
;  ldi
;  ldi
;  ldi
;  ld c,(hl)
;  ld a,(pcg_current_chunk_x)
;  add a,c
;  ld (de),a
;  inc hl
;  inc de
;  ldi
;  ld b,(hl)
;  ld a,(pcg_current_chunk_y)
;  add a,b
;  ld (de),a
;  inc hl
;  inc de
;  ldi
;  pop bc
;  djnz generateMap_copyCompressedChunkToMap_copy_enemies_loop
;generateMap_copyCompressedChunkToMap_no_more_enemies:

  ex de,hl
  ld a,(hl)
  inc hl
  or a
  jr z,generateMap_copyCompressedChunkToMap_no_more_items
  ld b,a
generateMap_copyCompressedChunkToMap_copy_items_loop:
  push bc
  ld a,(hl)
  push af
  inc hl
  ld c,(hl)
  ld a,(pcg_current_chunk_x)
  add a,c
  ld c,a
  inc hl
  ld b,(hl)
  ld a,(pcg_current_chunk_y)
  add a,b
  ld b,a
  pop af
  inc hl
  inc hl
  cp ITEM_PCG_SUPPLY
  call z,generateMap_sample_supply_item
  cp ITEM_PCG_ANY_JUNGLE
  call z,generateMap_sample_any_item_jungle
  cp ITEM_PCG_GOOD_ITEM_JUNGLE
  call z,generateMap_sample_good_item_jungle
  cp ITEM_PCG_ANY_INNER_RUINS
  call z,generateMap_sample_any_item_ruins
  cp ITEM_PCG_GOOD_ITEM_INNER_RUINS
  call z,generateMap_sample_good_item_ruins
  or a
  jr z,generateMap_copyCompressedChunkToMap_copy_items_loop_no_item
  push hl
  call spawnItemInMapPCG
  pop hl
generateMap_copyCompressedChunkToMap_copy_items_loop_no_item:
  pop bc
  djnz generateMap_copyCompressedChunkToMap_copy_items_loop
generateMap_copyCompressedChunkToMap_no_more_items:

  pop bc
  pop de
  pop hl

  ret

; :3,bomb:1,rope:1,arrow:1
generateMap_sample_supply_item:
  push hl
  ld a,pcg_item_supply_end-pcg_item_supply
  call randomModuloA
  ld hl,pcg_item_supply
generateMap_sample_supply_item_continue:
  ADD_HL_A
  ld a,(hl)
  pop hl
  ret

; :5,bomb:3,rope:3,shield:1,bow:2,arrow:3,boots:1,scubamask:1,boulder:2
generateMap_sample_any_item_jungle:
  push hl
  ld a,pcg_item_any_jungle_end-pcg_item_any_jungle
  call randomModuloA
  ld hl,pcg_item_any_jungle
  jr generateMap_sample_supply_item_continue
;  ADD_HL_A
;  ld a,(hl)
;  pop hl
;  ret

; shield:1,bow:1,boots:1,scubamask:1
generateMap_sample_good_item_jungle:
  push hl
  ld a,pcg_item_good_item_jungle_end-pcg_item_good_item_jungle
  call randomModuloA
  ld hl,pcg_item_good_item_jungle
  jr generateMap_sample_supply_item_continue
;  ADD_HL_A
;  ld a,(hl)
;  pop hl
;  ret

; :5,bomb:3,rope:3,shield:1,bow:2,arrow:3,boots:1,scubamask:1,boulder:2
generateMap_sample_any_item_ruins:
  push hl
  ld a,pcg_item_any_ruins_end-pcg_item_any_ruins
  call randomModuloA
  ld hl,pcg_item_any_ruins
  jr generateMap_sample_supply_item_continue
;  ADD_HL_A
;  ld a,(hl)
;  pop hl
;  ret

; shield:1,bow:1,boots:1,scubamask:1
generateMap_sample_good_item_ruins:
  push hl
  ld a,pcg_item_good_item_ruins_end-pcg_item_good_item_ruins
  call randomModuloA
  ld hl,pcg_item_good_item_ruins
  jr generateMap_sample_supply_item_continue
;  ADD_HL_A
;  ld a,(hl)
;  pop hl
;  ret

;-----------------------------------------------
; zeroes the current map, in preparation to call the procedural map generator
clearMap:
  ld hl,map
  ld de,map+1
  xor a
  ld (hl),a
  ld bc,(map_end-map)-1
  ldir
  ret


;-----------------------------------------------
; This function differs from "spawnItemInMap" in that it is simplified, not considering 
; all of those situations that cnanot arse during PCG. It also includes a few additional
; checks required during PCG.
; Adds an item of type "a" to the map, in position "bc" (b is "y", and c is "x")
; the "z" flag upon return indicates success (z or not, nz)
spawnItemInMapPCG:
    cp ITEM_BUTTON
    jr nz,spawnItemInMapPCG_not_a_button

    ld l,a
    ld a,(pcg_button_in_map)
    or a    
    ld a,l
    ret nz	; there can only be one button per map!

    ld hl,pcg_button_in_map
    ld (hl),1

spawnItemInMapPCG_not_a_button:
    push af ; save the type of item to add
    push bc

    ; put the item in the map
    ld hl,map_items
    ld de,ITEM_STRUCT_SIZE
    ld a,(map_n_items)
    cp MAX_MAP_ITEMS
    jp p,spawnItemInMapPCG_no_space
    or a
    jr z,spawnItemInMapPCG_skip_loop
    ld b,a
spawnItemInMapPCG_loop:
    add hl,de
    djnz spawnItemInMapPCG_loop

spawnItemInMapPCG_skip_loop:
    inc a
    ld (map_n_items),a

    pop bc
    pop af  ; we recover the type of item to add
    ld (hl),a
    inc hl
    ld (hl),c
    inc hl
    ld (hl),b
    ret

 spawnItemInMapPCG_no_space:
    pop bc
    pop af  ; we restore the stack
    ret

