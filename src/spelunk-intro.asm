;-----------------------------------------------
; state where the brain games logo is displayed, and we wait for player to press space
state_intro:
  call state_intro_setup

  ld hl,braingames_text
  ld de,NAMTBL2+32*18+(32 - (braingames_text_end - braingames_text))/2
  ld bc,braingames_text_end - braingames_text
  call LDIRVM

  ld bc,0
  ; bc will be the timer that controls everything
state_intro_loop:
  halt
  inc bc

  ; text events:
  push bc
  ld a,c
  and #7f
  jp nz,state_intro_loop_events_done
  ld a,b
  add a,a
  bit 7,c
  jr z,state_intro_loop_events_even
  inc a
state_intro_loop_events_even:
  cp 1
  call z,state_intro_loop_draw_background
  cp 3
  jr z,state_intro_loop_remove_braingames_subtext
  cp 4
  call z,state_intro_loop_bubble1
  cp 5
  call z,state_intro_loop_draw_background
  cp 6
  jp z,state_intro_loop_bubble2
  cp 7
  call z,state_intro_loop_draw_background
  cp 8
  jp z,state_intro_loop_bubble3
  cp 9
  call z,state_intro_loop_draw_background
  cp 10
  jp z,state_intro_loop_letter
  jp state_intro_loop_events_done

state_intro_loop_draw_background:
  push af
  ld hl,intro_data
  ld de,buffer
  push ix
  call pletter_unpack
  pop ix
  pop af
  ret

state_intro_loop_remove_braingames_subtext:
  xor a
  ld hl,NAMTBL2+32*18+(32 - (braingames_text_end - braingames_text))/2
  ld bc,braingames_text_end - braingames_text
  call FILVRM
  jp state_intro_loop_events_done

state_intro_create_bubble:
  push hl
  ld de,buffer+4*32+11
  ld bc,10
  push bc
  ldir
  pop bc
  pop hl
  add hl,bc
  ld de,buffer+5*32+11
  ldir
  ld hl,buffer+4*32+10
  ld (hl),116
  ld hl,buffer+5*32+10
  ld (hl),117
  ld hl,buffer+4*32+21
  ld (hl),118
  ld hl,buffer+5*32+21
  ld (hl),119
  ret

state_intro_loop_bubble1:
  push af
  ld hl,intro_bubble1_text
  call state_intro_create_bubble
  ld hl,buffer+6*32+15
  ld (hl),120
  call state_intro_set_black_over_white
  pop af
  ret

state_intro_loop_bubble2:
  ld hl,intro_bubble2_text
  call state_intro_create_bubble
  ld hl,buffer+6*32+13
  ld (hl),120
;  call state_intro_set_black_over_white
  jr state_intro_loop_events_done

state_intro_loop_bubble3:
  ld hl,intro_bubble3_text
  call state_intro_create_bubble
  ld hl,buffer+6*32+15
  ld (hl),120
;  call state_intro_set_black_over_white
  jr state_intro_loop_events_done

state_intro_loop_letter:
  call StopPlayingMusic
  call fadeOutPatternsAndSprites
  ld hl,patterns_title_pletter
  call decompressPatternsToVDP
  ld hl,letter1
  call display_letter
  pop bc
  jr state_intro_loop_done
  
state_intro_loop_events_done:
  pop bc  

  call state_intro_animate_elaine
  call state_intro_animate_mailman

  ; draw all the changes:
  ld a,b
  or a
  jr nz,state_intro_loop_draw
  ld a,c
  and #80
  jr z,state_intro_loop_no_need_to_draw_yet
state_intro_loop_draw:
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
state_intro_loop_no_need_to_draw_yet:

  ;; if space is pressed, skip the intro, and go to title
  push bc
  call checkTrigger1updatingPrevious
  pop bc
  or a
  jp z,state_intro_loop

state_intro_loop_done_fadeout:
  call fadeOutPatternsAndSprites  
state_intro_loop_done:  
;  call state_intro_restore_attributes
  call StopPlayingMusic
  jp state_title


state_intro_animate_elaine:
  push bc
  ; animate elaine:
  ld hl,buffer+7*32+13
  bit 5,c
  jr z,state_intro_loop_elaine2
state_intro_loop_elaine1:
  ld (ix+2),0
  ld (hl),107
  inc hl
  ld (hl),108
  ld hl,buffer+8*32+13
  ld (hl),123
  inc hl
  ld (hl),124
  jr state_intro_loop_elaine_done
state_intro_loop_elaine2:
  ld (ix+2),4
  ld (hl),109
  inc hl
  ld (hl),110
  ld hl,buffer+8*32+13
  ld (hl),125
  inc hl
  ld (hl),126
state_intro_loop_elaine_done:
  pop bc
  ret

state_intro_animate_mailman:
  ; mail man:
  push bc
  ld a,b
  cp 1
  jr nz,state_intro_loop_mailman_done
state_intro_loop_mailman_coming_in:
  ld (ix+4),13*8-1
  ld (ix+8),13*8-1
  ld a,(ix+5)
  cp 15*8+1
  jp m,state_intro_loop_mailman_move1
  ld a,c
  and #03
  jr nz,state_intro_loop_mailman_move_done
  dec (ix+5)
  dec (ix+9)
state_intro_loop_mailman_move_done:
  ; running animation
  bit 3,c
  jr z,state_intro_loop_mailman_move2
state_intro_loop_mailman_move1:
  ld (ix+6),8
  ld (ix+10),12
  jr state_intro_loop_mailman_done
state_intro_loop_mailman_move2:
  ld (ix+6),16
  ld (ix+10),20
state_intro_loop_mailman_done:
  pop bc
  ret  


state_intro_set_black_over_white:
  ; overwrite the attributes of the letters:
  ld a,#0f
  ld hl,CLRTBL2+32*8
  ld bc,64*8
  call FILVRM
  ld a,#0f
  ld hl,CLRTBL2+32*8+256*8
  ld bc,64*8
  jp FILVRM


state_intro_setup:
  call clearScreenLeftToRight
  ld hl,patterns_title_pletter
  call decompressPatternsToVDP

  ; start playing music:
  ld a,6
  ld hl,music_intro
  call PlayCompressedSong

  ; we are going to polay with some pattern attribute values, so, we first save them to be able to restore them
;  call state_intro_save_attributes

  ; 1) Decompress the intro data, and display the intro image:
  ld hl,intro_data
  ld de,buffer
  call pletter_unpack

  ld hl,sprite_attributes
  ld ix,sprite_attributes
  ld (hl),13*8-1
  inc hl
  ld (hl),13*8
  inc hl
  ld (hl),0
  inc hl
  ld (hl),COLOR_DARK_YELLOW
  inc hl
  ld (hl),200
  inc hl
  ld (hl),21*8
  inc hl
  ld (hl),8
  inc hl
  ld (hl),COLOR_DARK_BLUE
  inc hl
  ld (hl),200
  inc hl
  ld (hl),21*8
  inc hl
  ld (hl),12
  inc hl
  ld (hl),COLOR_DARK_YELLOW

  ; do not show the background at first
  ld hl,buffer
  ld de,buffer+1
  ld (hl),0
  ld bc,32*10-1
  ldir

  ld hl,buffer+32*10
  ld de,SPRTBL2
  ld bc,6*32
  jp LDIRVM
