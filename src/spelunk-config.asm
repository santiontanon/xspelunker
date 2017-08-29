;-----------------------------------------------
; game configuration screen
state_config:
  call fadeOutPatternsAndSprites
  ld hl,patterns_title_pletter
  call decompressPatternsToVDP

state_config_loop:
  halt

  ld hl,game_cycle
  inc (hl)

  ld a,(config_selected)
  and #01
  jr nz,state_config_loop_1
  ld a,(game_cycle)
  and #08
  jr nz,state_config_loop_1
  xor a
  ld bc,config_text1a_end - config_text1a
  ld hl,NAMTBL2+32*6+4
  call FILVRM
  jr state_config_loop_1_done
state_config_loop_1:
  ld a,(config_rope_jump)
  or a
  jr nz,state_config_loop_1b
  ld hl,config_text1a
  jr state_config_loop_1_render
state_config_loop_1b:
  ld hl,config_text1b
state_config_loop_1_render:
  ld bc,config_text1a_end - config_text1a
  ld de,NAMTBL2+32*6+4
  call LDIRVM
state_config_loop_1_done:

  ld a,(config_selected)
  and #01
  jr z,state_config_loop_2
  ld a,(game_cycle)
  and #08
  jr nz,state_config_loop_2
  xor a
  ld bc,config_text2a_end - config_text2a
  ld hl,NAMTBL2+32*8+4
  call FILVRM
  jr state_config_loop_2_done
state_config_loop_2:
  ld a,(config_machete_autoselect)
  or a
  jr nz,state_config_loop_2b
  ld hl,config_text2a
  jr state_config_loop_2_render
state_config_loop_2b:
  ld hl,config_text2b
state_config_loop_2_render:
  ld bc,config_text2a_end - config_text2a
  ld de,NAMTBL2+32*8+4
  call LDIRVM
state_config_loop_2_done:

  call checkInput
  ld a,(player_input_buffer+2)
  bit INPUT_TRIGGER2_BIT,a
  jr nz,state_config_done
  bit INPUT_UP_BIT,a
  jr nz,state_config_up
  bit INPUT_DOWN_BIT,a
  jr nz,state_config_up
  bit INPUT_TRIGGER1_BIT,a
  jr nz,state_config_change
  jr state_config_loop

state_config_up:
  ld hl,config_selected
  inc (hl)
  jp state_config_loop

state_config_change:
  ld a,(config_selected)
  and #01
  jr nz,state_config_right_b
  ld hl,config_rope_jump
  jr state_config_right_b_2
state_config_right_b:
  ld hl,config_machete_autoselect
state_config_right_b_2:
  ld a,(hl)
  inc a
  and #01
  ld (hl),a
  jp state_config_loop


state_config_done:
  call clearScreenLeftToRight
  jp state_title