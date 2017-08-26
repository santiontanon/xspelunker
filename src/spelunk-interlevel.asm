;-----------------------------------------------
; code the the game state where the name of the next level is being shown, 
; and the player is waiting for the level to be generated
state_interlevel:
  halt
  call clearAllTheSprites
  xor a
  call FILLSCREEN

  ; set the title patterns, so we have all the letter characters
  ld hl,patterns_title_pletter
  call decompressPatternsToVDP

  ld a,(current_level)
  or a
  jr nz,state_interlevel_done_with_letter
  ld a,(current_level_section)
  cp 1
  jp z,state_interlevel_letter2
  cp 2
  jp z,state_interlevel_letter3
  cp 3
  jp z,state_ending

state_interlevel_done_with_letter:
  ; since the pattern patch functions require buffer2 (the music buffer), we need to stop the music first:
  call StopPlayingMusic

  ld hl,patterns_jungle_pletter
  call decompressPatternsToVDP

  ; display the next level message:
  ld hl,interlevel_text
  ld de,buffer
  ld bc,interlevel_text_end - interlevel_text
  ldir

  ld a,(current_level_section)
  add a,'1'
  ld (buffer+6),a
  ld a,(current_level)
  add a,'1'
  ld (buffer+8),a  

  ld hl,buffer
  ld de,NAMTBL2+32*10+(32 - (interlevel_text_end - interlevel_text))/2
  ld bc,interlevel_text_end - interlevel_text
  call LDIRVM

  ld hl,interlevel_text2
  ld de,NAMTBL2+32*12+(32 - (interlevel_text2_end - interlevel_text2))/2
  ld bc,interlevel_text2_end - interlevel_text2
  call LDIRVM

  ; set the appropriate patterns for the level at hand:
  ld a,(current_level_section)
  or a
  jr z,state_interlevel_patterns_loaded
  ld hl,patterns_title_outer_ruins_patch
  call decompressPatternPatchToVDP

  ld a,(current_level_section)
  cp 2
  jp m,state_interlevel_patterns_loaded
  ld hl,patterns_title_inner_ruins_patch
  call decompressPatternPatchToVDP

state_interlevel_patterns_loaded:
  ; generate a new level according to the level specifications:
  ld hl,map
  ld de,map+1
  ld bc,(map_end-map)-1
  xor a
  ld (hl),a
  ldir

  ld a,(current_level_section)
  add a,a
  add a,a
  ld b,a
  ld a,(current_level)
  add a,b ; a is now the raw level
  ld hl,level_1
  ld bc,level_2 - level_1 
  or a
  jr z,state_interlevel_level_definition_pointer_found
state_interlevel_level_definition_pointer_loop:
  add hl,bc
  dec a
  jr nz,state_interlevel_level_definition_pointer_loop
state_interlevel_level_definition_pointer_found:
  call generateMapFromLevelSpecification

  xor a
  ld hl,NAMTBL2+32*12+(32 - (interlevel_text2_end - interlevel_text2))/2
  ld bc,interlevel_text2_end - interlevel_text2
  call FILVRM

  ld bc,250
state_interlevel_loop:
  dec bc
  ld a,b
  or c
  jp z,state_playing

  halt

  ;; wait for space to be pressed:
  push bc
  call checkTrigger1updatingPrevious
  pop bc
  or a
  jr z,state_interlevel_loop
  jp state_playing


state_interlevel_letter2:
  ld hl,letter2
  call display_letter
  jp state_interlevel_done_with_letter

state_interlevel_letter3:
  ld hl,letter3
  call display_letter
  jp state_interlevel_done_with_letter


;-----------------------------------------------
; Game over state
state_gameover:
  call clearScreenLeftToRight
  ld hl,patterns_title_pletter
  call decompressPatternsToVDP  ; we need this, since not all the letters in "game over" are in the in-game tileset

  ld hl,gameover_text
  ld de,NAMTBL2+32*10+(32 - (gameover_text_end - gameover_text))/2
  ld bc,gameover_text_end - gameover_text
  call LDIRVM

  ld a,6
  ld hl,music_gameover  
  call PlayCompressedSong

  ld bc,250
state_gameover_loop:
  dec bc
  ld a,b
  or c
  jr z,state_gameover_loop

  halt

  ;; wait for space to be pressed:
  push bc
  call checkTrigger1updatingPrevious
  pop bc
  or a
  jr z,state_gameover_loop

state_gameover_loop_done:  
  jp state_intro

