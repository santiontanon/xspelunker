;-----------------------------------------------
; game configuration screen
state_config:
  call fadeOutPatternsAndSprites
  ld hl,patterns_title_pletter
  call decompressPatternsToVDP

  xor a
  ld (config_selected),a

  ld hl,config_text1
  ld bc,config_text1_end - config_text1
  ld de,NAMTBL2+32*6+4
  call LDIRVM

  ld hl,config_text2
  ld bc,config_text2_end - config_text2
  ld de,NAMTBL2+32*8+4
  call LDIRVM

  ld hl,config_text3
  ld bc,config_text3_end - config_text3
  ld de,NAMTBL2+32*10+4
  call LDIRVM

state_config_loop:
  halt

  ld hl,game_cycle
  inc (hl)

  ld a,(config_selected)
  or a
  ld a,(config_rope_jump)
  ld bc,config_text1a_end - config_text1a
  ld de,NAMTBL2+32*6+4+(config_text1_end - config_text1)+1
  ld ix,config_text1a
  ld iy,config_text1b
  call state_config_print_option_generic

  ld a,(config_selected)
  cp 1
  ld a,(config_machete_autoselect)
  ld bc,config_text2a_end - config_text2a
  ld de,NAMTBL2+32*8+4+(config_text2_end - config_text2)+1
  ld ix,config_text2a
  ld iy,config_text2b
  call state_config_print_option_generic

  ld a,(config_selected)
  cp 2
  ld a,(config_music)
  ld bc,config_text3a_end - config_text3a
  ld de,NAMTBL2+32*10+4+(config_text3_end - config_text3)+1
;  ld ix,config_text3a
;  ld iy,config_text3b
  call state_config_print_option_generic

  call checkInput
  ld a,(player_input_buffer+2)
  bit INPUT_TRIGGER2_BIT,a
  jr nz,state_config_done
  bit INPUT_UP_BIT,a
  jr nz,state_config_up
  bit INPUT_DOWN_BIT,a
  jr nz,state_config_down
  bit INPUT_TRIGGER1_BIT,a
  jr nz,state_config_change
  jr state_config_loop

state_config_down:
  ld hl,config_selected
  ld a,(hl)
  inc a
  ld (hl),a
  cp 3
  jr nz,state_config_loop
  xor a
state_config_down_continue:
  ld (hl),a
  jr state_config_loop

state_config_up:
  ld hl,config_selected
  ld a,(hl)
  dec a
  ld (hl),a
  cp -1
  jr nz,state_config_loop
  ld a,2
  jr state_config_down_continue


state_config_change:
  ld a,(config_selected)
  or a
  jr z,state_config_right_a
  dec a
  jr z,state_config_right_b
  ld hl,config_music
  jr state_config_change_continue
state_config_right_a:
  ld hl,config_rope_jump
  jr state_config_change_continue
state_config_right_b:
  ld hl,config_machete_autoselect
  jr state_config_change_continue
state_config_change_continue:
  ld a,(hl)
  inc a
  and #01
  ld (hl),a
  jp state_config_loop


state_config_print_option_generic:
  push af
  jr nz, state_config_print_option_generic_not_selected
  ld a,(game_cycle)
  and #08
  jr nz,state_config_print_option_generic_not_selected
  pop af
  xor a
  push de
  pop hl
  jp FILVRM
state_config_print_option_generic_not_selected:
  pop af
  or a
  jr nz,state_config_print_option_generic_b
  push ix
  pop hl
  jr state_config_print_option_generic_render
state_config_print_option_generic_b:
  push iy
  pop hl
state_config_print_option_generic_render:
  jp LDIRVM


state_config_done:
  call clearScreenLeftToRight
  jp state_title
