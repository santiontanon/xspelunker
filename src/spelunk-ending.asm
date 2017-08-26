;-----------------------------------------------
; state where the brain games logo is displayed, and we wait for player to press space
state_ending:
  call state_intro_setup

  ld bc,0
  ; bc will be the timer that controls everything
state_ending_loop:
  halt
  inc bc

  ; text events:
  push bc
  ld a,c
  and #7f
  jp nz,state_ending_loop_events_done
  ld a,b
  add a,a
  bit 7,c
  jr z,state_ending_loop_events_even
  inc a
state_ending_loop_events_even:
  cp 1
  call z,state_intro_loop_draw_background
  cp 4
  call z,state_intro_loop_bubble1
  cp 5
  call z,state_intro_loop_draw_background
  cp 6
  jr z,state_ending_loop_bubble2
  cp 7
  call z,state_intro_loop_draw_background
  cp 8
  jr z,state_ending_loop_bubble3
  cp 9
  call z,state_intro_loop_draw_background
  cp 10
  jr z,state_ending_loop_bubble4
  cp 11
  call z,state_intro_loop_draw_background
  cp 12
  jr z,state_ending_loop_letter
  jr state_ending_loop_events_done


state_ending_loop_bubble2:
  ld hl,ending_bubble2_text
  call state_intro_create_bubble
  ld hl,buffer+6*32+13
  ld (hl),120
;  call state_intro_set_black_over_white
  jr state_ending_loop_events_done

state_ending_loop_bubble3:
  ld hl,ending_bubble3_text
  call state_intro_create_bubble
  ld hl,buffer+6*32+15
  ld (hl),120
;  call state_intro_set_black_over_white
  jr state_ending_loop_events_done


state_ending_loop_bubble4:
  ld hl,ending_bubble4_text
  call state_intro_create_bubble
  ld hl,buffer+6*32+13
  ld (hl),120
;  call state_intro_set_black_over_white
  jr state_ending_loop_events_done

state_ending_loop_letter:
  call StopPlayingMusic
  call fadeOutPatternsAndSprites
  ld hl,patterns_title_pletter
  call decompressPatternsToVDP
  ld hl,letter4
  call display_letter
  pop bc
  jp state_ending_loop_done
  
state_ending_loop_events_done:
  pop bc  

  call state_intro_animate_elaine
  call state_intro_animate_mailman

  ; draw all the changes:
  ld a,b
  or a
  jp nz,state_ending_loop_draw
  ld a,c
  and #80
  jp z,state_ending_loop_no_need_to_draw_yet
state_ending_loop_draw:
  push bc
  ld hl,sprite_attributes
  ld de,SPRATR2
  ld bc,12
  call LDIRVM

  ld hl,buffer
  ld de,NAMTBL2+32*6
  ld bc,32*10
  call LDIRVM  
  pop bc
state_ending_loop_no_need_to_draw_yet:
  jp state_ending_loop

state_ending_loop_done:  
  ld hl,patterns_title_pletter
  call decompressPatternsToVDP
  call StopPlayingMusic

  ld hl,ending_text
  ld de,NAMTBL2+32*9+(32 - (ending_text_end - ending_text))/2
  ld bc,ending_text_end - ending_text
  call LDIRVM

  ; display how long it took to play:
  ld hl,ending_text2
  ld de,buffer
  ld bc,ending_text2_end - ending_text2
  push bc
  ldir

  ; render accumulated time:
  ld hl,(accumulated_time)
  ld d,10
  call Div8
  add a,'0'
  ld (buffer+15),a
  ld d,6
  call Div8
  add a,'0'
  ld (buffer+14),a
  ld d,10
  call Div8
  add a,'0'
  ld (buffer+12),a
  ld a,l
  add a,'0'
  ld (buffer+11),a

  pop bc
  ld hl,buffer
  ld de,NAMTBL2+32*11+(32 - (ending_text2_end - ending_text2))/2
  call LDIRVM

state_ending_loop2:
  halt
  push bc
  call checkTrigger1updatingPrevious
  pop bc
  or a
  jr z,state_ending_loop2

  jp state_title
