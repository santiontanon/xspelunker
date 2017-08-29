;-----------------------------------------------
; Displays one of the letter of M.S.Xavier to Elaine, waits for space, clears the screen, and returns
; The letter to display is passed in as a parameter in "HL"
display_letter:
  push hl

  ; overwrite the attributes of the letters:
  ld a,#0a
  ld hl,CLRTBL2+32*8
  ld bc,64*8
  push bc
  call FILVRM
  ld a,#0a
  ld hl,CLRTBL2+32*8+256*8
  pop bc
  push bc
  call FILVRM
  ld a,#0a
  ld hl,CLRTBL2+32*8+512*8
  pop bc
  call FILVRM

  ; decompress the letter:
  pop hl
  ld de,buffer+64*8 ; we decompress it with some offset, for not overwritting the attributes we saved above
  call pletter_unpack

  ld a,4
  ld hl,music_letter
  call PlayCompressedSong

  ; display the letter:
  ld hl,buffer+64*8
  ld de,NAMTBL2
  ld bc,768
  call LDIRVM

  ; wait for space to be pressed:
display_letter_loop:
  halt
  call checkInput
  ld a,(player_input_buffer+2)
  bit INPUT_TRIGGER1_BIT,a
  jr z,display_letter_loop
  jp clearScreenLeftToRight
