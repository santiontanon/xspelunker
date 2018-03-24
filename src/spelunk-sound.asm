;-----------------------------------------------
; Uncompresses and starts playing a song 
; arguments: 
; - hl: pointer to the compressed data
; - a: Music_tempo
PlayCompressedSong:
    ld (Music_tempo),a

    push de
    push bc
    push af

    ld de,music_buffer
    call pletter_unpack

    ; if we are in a 60Hz computer, slow the music down a bit:
    ld a,(isComputer50HzOr60Hz)
    or a
    jr z,PlayCompressedSong50Hz
    ld hl,Music_tempo
    inc (hl)
PlayCompressedSong50Hz:

    di
    call StopPlayingMusic
    ld hl,music_buffer
    ld a,1
    ld (MUSIC_play),a
    ld (MUSIC_pointer),hl
    ld (MUSIC_start_pointer),hl
    ld hl,MUSIC_repeat_stack
    ld (MUSIC_repeat_stack_ptr),hl
    ei
    pop af
    pop bc
    pop de
    ret


;-----------------------------------------------
; Starts playing an SFX
; arguments: 
; - hl: pointer to the SFX to play
playSFX:
    ld a,1
    ld (SFX_priority),a
playSFX_lowPriority:
    di
    ld (SFX_pointer),hl
    ld a,1
    ld (SFX_play),a
    xor a
    ld (MUSIC_instruments+2),a  ;; reset the instrument in channel 3 to Square wave, so it does not interfere with the SFX
    ei
    ret


;-----------------------------------------------
; Loads the interrupt hook for playing music:
SETUP_MUSIC_INTERRUPT:
    call StopPlayingMusic
    ld  a,JPCODE    ;NEW HOOK SET
    di
    ld  (TIMI),a
    ld  hl,MUSIC_INT
    ld  (TIMI+1),hl
    ei
    ret

;-----------------------------------------------
; Music player interrupt routine
MUSIC_INT:     ; This routine is called 50 or 60 times / sec 
    push af  

    call randomSeedUpdate ; we first update the random seed to remove cycles on random number generation

    ld a,(MUSIC_play)
    or a
    jp z,MUSIC_INT_NO_MUSIC_NO_POP

    push de
    ;; handle instruments currently playing
    call MUSIC_INT_HANDLE_INSTRUMENTS

    ld a,(MUSIC_tempo_counter)
    or a
    jp nz,MUSIC_INT_skip

    push ix
    push hl
    ld ix,(MUSIC_repeat_stack_ptr)
    ld hl,(MUSIC_pointer)
    call MUSIC_INT_INTERNAL
    ld (MUSIC_pointer),hl
    ld (MUSIC_repeat_stack_ptr),ix
    pop hl
    pop ix
    ld a,(Music_tempo)
    ld (MUSIC_tempo_counter),a
    jr MUSIC_INT_NO_MUSIC

MUSIC_INT_skip:
    dec a
    ld (MUSIC_tempo_counter),a

MUSIC_INT_NO_MUSIC:
    pop de
MUSIC_INT_NO_MUSIC_NO_POP:
    ld a,(SFX_play)
    or a
    jp z,MUSIC_INT_NO_SFX

    push hl
    ; no need to load the MUSIC_repeat_stack_ptr for SFX, since we never have a repeat there
;    ld ix,(MUSIC_repeat_stack_ptr)
    ld hl,(SFX_pointer)
    call MUSIC_INT_INTERNAL
    ld (SFX_pointer),hl
;    ld (MUSIC_repeat_stack_ptr),ix
    pop hl

MUSIC_INT_NO_SFX:
    pop af
    ret

    

CLEAR_PSG_VOLUME:
    ld a,8
    ld e,0
    call WRTPSG
    ld a,9
    ld e,0
    call WRTPSG
    ld a,10
    ld e,0
    jp WRTPSG


MUSIC_INT_INTERNAL:
MUSIC_INT_LOOP:
    ld a,(hl)
    inc hl 

    ; check if it's a special command:
    bit 7,a
    jp z,MUSIC_INT_WRTPSG

;    cp MUSIC_CMD_SKIP
    inc a
    ret z

;    cp MUSIC_CMD_SET_INSTRUMENT
    inc a
    jr z,MUSIC_INT_SET_INSTRUMENT

;    cp MUSIC_CMD_PLAY_INSTRUMENT_CH1
    inc a
    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH1

;    cp MUSIC_CMD_PLAY_INSTRUMENT_CH2
    inc a
    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH2

;    cp MUSIC_CMD_PLAY_INSTRUMENT_CH3
    inc a
    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH3

    inc a
    jp z,MUSIC_INT_PLAY_SFX

;    cp MUSIC_CMD_GOTO
    inc a
    jp z,MUSIC_INT_GOTO

;    cp MUSIC_CMD_END                 
    inc a
    jr z,MUSIC_INT_END         ;; if the music sound is over, we are done

;    cp MUSIC_CMD_REPEAT
    inc a
    jp z,MUSIC_INT_REPEAT

;    cp MUSIC_CMD_END_REPEAT
    inc a
    jp z,MUSIC_INT_END_REPEAT

;    cp SFX_CMD_END                 
;    inc a
;    jp z,SFX_INT_END         ;; if the SFX sound is over, we are done
    jp SFX_INT_END


MUSIC_INT_WRTPSG:
    ld e,(hl)             
    inc hl
    call WRTPSG                ;; send command to PSG
    jr MUSIC_INT_LOOP     

MUSIC_INT_END:
    xor a
    ld (MUSIC_play),a
    ret

SFX_INT_END:
    xor a
    ld (SFX_play),a
    ld (SFX_priority),a
    ld a,7
    ld e,#b8  ;; SFX should reset all channels to tone
    jp WRTPSG

MUSIC_INT_SET_INSTRUMENT:
    ld d,(hl)   ; instrument
    inc hl
    ld a,(hl)   ; channel
    inc hl
    or a
    jp z,MUSIC_INT_SET_INSTRUMENT_CHANNEL0
    dec a
    jp z,MUSIC_INT_SET_INSTRUMENT_CHANNEL1
MUSIC_INT_SET_INSTRUMENT_CHANNEL2:
    ld a,d
    ld (MUSIC_instruments+2),a
    ld (MUSIC_channel3_instrument_buffer),a
    jp MUSIC_INT_LOOP
MUSIC_INT_SET_INSTRUMENT_CHANNEL1:
    ld a,d
    ld (MUSIC_instruments+1),a
    jp MUSIC_INT_LOOP
MUSIC_INT_SET_INSTRUMENT_CHANNEL0:
    ld a,d
    ld (MUSIC_instruments),a
    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH1:
    ld e,(hl)   ; MSB of frequency
    inc hl
    ld a,1
    call WRTPSG
    ld e,(hl)   ; LSB of frequency
    inc hl
    xor a
    call WRTPSG
    ld a,(MUSIC_instruments)
    or a  ; since MUSIC_INSTRUMENT_SQUARE_WAVE = 0
    ; cp MUSIC_INSTRUMENT_SQUARE_WAVE
    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH1_SW
    dec a ; since MUSIC_INSTRUMENT_PIANO = 1
    ;cp MUSIC_INSTRUMENT_PIANO
    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH1_PIANO
MUSIC_INT_PLAY_INSTRUMENT_CH1_WIND:
    ld de,Wind_instrument_profile+1
    ld (MUSIC_instrument_envelope_ptr),de
    ld a,(Wind_instrument_profile)
    ld e,a
    ld a,8
    call WRTPSG 
    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH1_PIANO:
    ld de,Piano_instrument_profile+1
    ld (MUSIC_instrument_envelope_ptr),de
    ld a,(Piano_instrument_profile)
    ld e,a
    ld a,8
    call WRTPSG 
    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH1_SW:
    ld a,8
    ld e,SquareWave_instrument_volume
    call WRTPSG 
    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH2:
    ld e,(hl)   ; MSB of frequency
    inc hl
    ld a,3
    call WRTPSG
    ld e,(hl)   ; LSB of frequency
    inc hl
    ld a,2
    call WRTPSG
    ld a,(MUSIC_instruments+1)
    or a  ; since MUSIC_INSTRUMENT_SQUARE_WAVE = 0
    ;cp MUSIC_INSTRUMENT_SQUARE_WAVE
    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH2_SW
    dec a ; since MUSIC_INSTRUMENT_PIANO = 1
    ;cp MUSIC_INSTRUMENT_PIANO
    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH2_PIANO
MUSIC_INT_PLAY_INSTRUMENT_CH2_WIND:
    ld de,Wind_instrument_profile+1
    ld (MUSIC_instrument_envelope_ptr+2),de
    ld a,(Wind_instrument_profile)
    ld e,a
    ld a,9
    call WRTPSG 
    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH2_PIANO:
    ld de,Piano_instrument_profile+1
    ld (MUSIC_instrument_envelope_ptr+2),de
    ld a,(Piano_instrument_profile)
    ld e,a
    ld a,9
    call WRTPSG 
    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH2_SW:
    ld a,9
    ld e,SquareWave_instrument_volume
    call WRTPSG 
    jp MUSIC_INT_LOOP


MUSIC_INT_PLAY_INSTRUMENT_CH3:
    ld a,(SFX_play)
    or a
    jp nz,MUSIC_INT_PLAY_INSTRUMENT_CH3_IGNORE
    ld e,(hl)   ; MSB of frequency
    inc hl
    ld a,5
    call WRTPSG
    ld e,(hl)   ; LSB of frequency
    inc hl
    ld a,4
    call WRTPSG
    ld a,(MUSIC_channel3_instrument_buffer)
    ld (MUSIC_instruments+2),a
    or a  ; since MUSIC_INSTRUMENT_SQUARE_WAVE = 0
    ;cp MUSIC_INSTRUMENT_SQUARE_WAVE
    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH3_SW
    ;; none of the songs use WIND in channel 3, so, I commented the code out to save space

;    dec a ; since MUSIC_INSTRUMENT_PIANO = 1
;    jp MUSIC_INT_PLAY_INSTRUMENT_CH3_PIANO  
    ;cp MUSIC_INSTRUMENT_PIANO
;    jp z,MUSIC_INT_PLAY_INSTRUMENT_CH3_PIANO
;MUSIC_INT_PLAY_INSTRUMENT_CH3_WIND:
;    ld de,Wind_instrument_profile+1
;    ld (MUSIC_instrument_envelope_ptr+4),de
;    ld a,(Wind_instrument_profile)
;    ld e,a
;    ld a,10
;    call WRTPSG 
;    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH3_PIANO:
    ld de,Piano_instrument_profile+1
    ld (MUSIC_instrument_envelope_ptr+4),de
    ld a,(Piano_instrument_profile)
    ld e,a
    ld a,10
    call WRTPSG 
    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH3_SW:
    ld a,10
    ld e,SquareWave_instrument_volume
    call WRTPSG 
    jp MUSIC_INT_LOOP

MUSIC_INT_PLAY_INSTRUMENT_CH3_IGNORE:
    inc hl
MUSIC_INT_INC_HL_AND_CONTINUE:
    inc hl
    jp MUSIC_INT_LOOP

MUSIC_INT_HANDLE_INSTRUMENTS:
    ld a,(MUSIC_instruments)
    or a  ; since MUSIC_INSTRUMENT_SQUARE_WAVE = 0
;    cp MUSIC_INSTRUMENT_SQUARE_WAVE
    jp z,MUSIC_INT_HANDLE_INSTRUMENTS_CH2

    ld de,(MUSIC_instrument_envelope_ptr)
    ld a,(de)
    cp #ff
    jp z,MUSIC_INT_HANDLE_INSTRUMENTS_CH2
    inc de
    ld (MUSIC_instrument_envelope_ptr),de
    ld e,a
    ld a,8
    call WRTPSG

MUSIC_INT_HANDLE_INSTRUMENTS_CH2:
    ld a,(MUSIC_instruments+1)
    or a  ; since MUSIC_INSTRUMENT_SQUARE_WAVE = 0
    ; cp MUSIC_INSTRUMENT_SQUARE_WAVE
    jp z,MUSIC_INT_HANDLE_INSTRUMENTS_CH3

    ld de,(MUSIC_instrument_envelope_ptr+2)
    ld a,(de)
    cp #ff
    jp z,MUSIC_INT_HANDLE_INSTRUMENTS_CH3
    inc de
    ld (MUSIC_instrument_envelope_ptr+2),de
    ld e,a
    ld a,9
    call WRTPSG

MUSIC_INT_HANDLE_INSTRUMENTS_CH3:
    ld a,(SFX_play)
    or a
    ret nz  ; if there is an SFX playing, then do not update the instruments in channel 3!
    ld a,(MUSIC_instruments+2)
    or a  ; since MUSIC_INSTRUMENT_SQUARE_WAVE = 0
    ; cp MUSIC_INSTRUMENT_SQUARE_WAVE
    ret z

    ld de,(MUSIC_instrument_envelope_ptr+4)
    ld a,(de)
    cp #ff
    ret z
    inc de
    ld (MUSIC_instrument_envelope_ptr+4),de
    ld e,a
    ld a,10
    jp WRTPSG


MUSIC_INT_PLAY_SFX:
    ld a,(SFX_priority)
    or a
    jp nz,MUSIC_INT_INC_HL_AND_CONTINUE
    ld a,(hl)
    inc hl
    push hl
    cp SFX_OPEN_HIHAT
    jp z,MUSIC_INT_PLAY_SFX_OPEN_HIHAT
    cp SFX_PEDAL_HIHAT
    jp z,MUSIC_INT_PLAY_SFX_PEDAL_HIHAT
    pop hl
    jp MUSIC_INT_LOOP
MUSIC_INT_PLAY_SFX_OPEN_HIHAT:
    ld hl,decompressed_sfx + SFX_open_hi_hat
    call playSFX_lowPriority
    pop hl
    jp MUSIC_INT_LOOP
MUSIC_INT_PLAY_SFX_PEDAL_HIHAT:
    ld hl,decompressed_sfx + SFX_pedal_hi_hat
    call playSFX_lowPriority
    pop hl
    jp MUSIC_INT_LOOP

MUSIC_INT_GOTO:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld hl,(MUSIC_start_pointer)
    add hl,de
    jp MUSIC_INT_LOOP

MUSIC_INT_REPEAT:
    ld a,(hl)
    inc hl
    ld (ix),a
    ld (ix+1),l
    ld (ix+2),h
    inc ix
    inc ix
    inc ix
    jp MUSIC_INT_LOOP

MUSIC_INT_END_REPEAT:
    ;; decrease the top value of the repeat stack
    ;; if it is 0, pop
    ;; if it is not 0, goto the repeat point
    ld a,(ix-3)
    dec a
    or a
    jp z,MUSIC_INT_END_REPEAT_POP
    ld (ix-3),a
    ld l,(ix-2)
    ld h,(ix-1)
    jp MUSIC_INT_LOOP

MUSIC_INT_END_REPEAT_POP:
    dec ix
    dec ix
    dec ix
    jp MUSIC_INT_LOOP


StopPlayingMusic:
    ld hl,SFX_play
    ld b,music_buffer - SFX_play
    xor a
StopPlayingMusic_loop:
    ld (hl),a
    inc hl
    djnz StopPlayingMusic_loop
    ld hl,MUSIC_repeat_stack
    ld (MUSIC_repeat_stack_ptr),hl    
    jp CLEAR_PSG_VOLUME


pauseMusic:
  xor a
  ld (MUSIC_play),a
  jp CLEAR_PSG_VOLUME


resumeMusic:
  ld a,1
  ld (MUSIC_play),a
  ret
