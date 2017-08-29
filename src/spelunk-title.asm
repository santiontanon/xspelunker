;-----------------------------------------------
; game title screen
state_title:
  ld a,GAME_STATE_TITLE
  ld (game_state),a

  ld hl,patterns_title_pletter
  call decompressPatternsToVDP

  ; decompress the title data:
  ld hl,title_data
  ld de,buffer
  call pletter_unpack

  halt  ; to synchronize the copies below

  ; copy the pattern data to the VDP:
  ld hl,buffer
  ld de,NAMTBL2+4*32
  ld bc,32*10
  call LDIRVM

  ld a,(buffer+32*10) ; number of sprites
  ld h,0
  ld l,a
  add hl,hl
  add hl,hl
  push hl   ; we save this for later (# sprites * 4)
  add hl,hl
  add hl,hl
  add hl,hl ; hl = # sprites * 32
  push hl
  pop bc

  ; copy the sprite data:
  ld hl,buffer+1+32*10
  ld de,SPRTBL2
  push bc
  call LDIRVM
  pop bc

  ; copy the sprite attribute data:
  ld hl,buffer+1+32*10
  add hl,bc
  ld de,SPRATR2
  pop bc  ; we recover # sprites * 4
  call LDIRVM

  ; credits:
  ld hl,credits_text
  ld de,NAMTBL2+32*23+(32 - (credits_text_end - credits_text))/2
  ld bc,credits_text_end - credits_text
  call LDIRVM

  ld hl,title_config_text
  ld de,NAMTBL2+32*19+(32 - (title_config_text_end - title_config_text))/2
  ld bc,title_config_text_end - title_config_text
  call LDIRVM


  ; wait for the player to press SPACE:
  ld b,0
state_title_loop:
  halt
  inc b
  push bc
  bit 4,b
  call z,state_title_loop_flash_out
  call nz,state_title_loop_flash_in
;  call checkTrigger1updatingPrevious
  call checkInput
  pop bc
  ld a,(player_input_buffer+2)
  bit INPUT_TRIGGER2_BIT,a
  jp nz,state_config
  bit INPUT_TRIGGER1_BIT,a
  jr z,state_title_loop

  ld a,4
  ld hl,music_gamestart
  call PlayCompressedSong

  ; player has pressed SPACE:
  ld b,0
state_title_loop2:
  halt
  inc b
  push bc
  bit 2,b
  call z,state_title_loop_flash_out
  call nz,state_title_loop_flash_in
  pop bc
  ld a,b
  cp 64
  jr nz,state_title_loop2

  call fadeOutPatternsAndSprites
  call initGameMemory
  jp state_interlevel


state_title_loop_flash_in:
  ld hl,gamestart_text
  ld de,NAMTBL2+32*17+(32 - (gamestart_text_end - gamestart_text))/2
  ld bc,gamestart_text_end - gamestart_text
  call LDIRVM
  ret
state_title_loop_flash_out:
  push af
  xor a
  ld hl,NAMTBL2+32*17+(32 - (gamestart_text_end - gamestart_text))/2
  ld bc,gamestart_text_end - gamestart_text
  call FILVRM
  pop af
  ret


;-----------------------------------------------
; copies values from ROM to RAM and zeroes all the variables before starting a new gmae
initGameMemory:
  ;; transfer variables to RAM:
  ld hl,ROMtoRAM_compressed
  ld de,RAM
  call pletter_unpack

  ld hl,RAM_to_zero_on_new_map
  ld de,RAM_to_zero_on_new_map+1
  xor a
  ld (hl),a
  ld bc,RAM_to_zero_on_new_map_end-RAM_to_zero_on_new_map
  ldir

  ret
