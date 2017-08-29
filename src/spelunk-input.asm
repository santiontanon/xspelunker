;-----------------------------------------------
readJoystick1Status:
    ld a,15 ; read the joystick 1 status:
;    di      ; in XSpelunky I found that in one instance, the interrupt was comming WHILE inside of a RDPSG call, messing things up!
    call RDPSG
;    ei
    and #bf
    ld e,a
    ld a,15
    call WRTPSG
    dec a
;    di      ; in XSpelunky I found that in one instance, the interrupt was comming WHILE inside of a RDPSG call, messing things up!
    call RDPSG
;    ei
    cpl ; invert the bits (so that '1' means direction pressed)
    ret


;-----------------------------------------------
; Update the (player_input_buffer) variables with the key presses or joystick status
checkInput:
    ld a,(player_input_buffer)
    ld b,a
    push bc
    ld (player_input_buffer+1),a
    call checkNewInput
    pop bc
    ld c,a  ; b has the old input, and c the new input
    ld a,b
    cpl
    and c
    ld (player_input_buffer+2),a

    ; update the double click buffers:
    xor a
    ld (player_input_buffer+3),a
    ld a,(player_input_double_click_state)
    or a
    jp z,checkInput_state0
    dec a
    jp z,checkInput_state_l1
    dec a
    jp z,checkInput_state_r1

checkInput_state_u1:  ; up is pressed
    ld a,(player_input_buffer+2)
    bit INPUT_UP_BIT,a
    jp nz,checkInput_detected_up_double_click
    bit INPUT_RIGHT_BIT,a
    jp nz,checkInput_change_to_state_r1
    bit INPUT_UP_BIT,a
    jp nz,checkInput_change_to_state_u1
    ld hl,player_input_double_click_state+1
    dec (hl)
    jp z,checkInput_change_to_state0
    ret
checkInput_state0:  ; no double click detectex
    ld a,(player_input_buffer+2)
    bit INPUT_LEFT_BIT,a
    jp nz,checkInput_change_to_state_l1
    bit INPUT_RIGHT_BIT,a
    jp nz,checkInput_change_to_state_r1
    bit INPUT_UP_BIT,a
    jp nz,checkInput_change_to_state_u1
    ret
checkInput_state_l1:  ; left is pressed
    ld a,(player_input_buffer+2)
    bit INPUT_LEFT_BIT,a
    jp nz,checkInput_detected_left_double_click
    bit INPUT_RIGHT_BIT,a
    jp nz,checkInput_change_to_state_r1
    bit INPUT_UP_BIT,a
    jp nz,checkInput_change_to_state_u1
    ld hl,player_input_double_click_state+1
    dec (hl)
    jp z,checkInput_change_to_state0
    ret
checkInput_state_r1:  ; right is pressed and released
    ld a,(player_input_buffer+2)
    bit INPUT_RIGHT_BIT,a
    jp nz,checkInput_detected_right_double_click
    bit INPUT_RIGHT_BIT,a
    jp nz,checkInput_change_to_state_r1
    bit INPUT_UP_BIT,a
    jp nz,checkInput_change_to_state_u1
    ld hl,player_input_double_click_state+1
    dec (hl)
    jp z,checkInput_change_to_state0
    ret

checkInput_change_to_state0:
    xor a
    ld (player_input_double_click_state),a
    ret
checkInput_change_to_state_l1:
    ld a,1
checkInput_change_to_state_generic:
    ld hl,player_input_double_click_state
    ld (hl),a
    ld a,INPUT_DOUBLE_CLICK_TIMMER
    inc hl
    ld (hl),a
    ret
checkInput_change_to_state_r1:
    ld a,2
    jp checkInput_change_to_state_generic
checkInput_change_to_state_u1:
    ld a,3
    jp checkInput_change_to_state_generic

checkInput_detected_left_double_click:
    ld a,#04    ; left bit
    ld (player_input_buffer+3),a
    jp checkInput_change_to_state0
checkInput_detected_right_double_click:
    ld a,#08    ; right bit
    ld (player_input_buffer+3),a
    jp checkInput_change_to_state0
checkInput_detected_up_double_click:
    ld a,#01    ; up bit
    ld (player_input_buffer+3),a
    jp checkInput_change_to_state0

checkNewInput:
    ld a,#04    ;; get the status of the 4th keyboard row (to get the M, and P key)
    call SNSMAT 
    cpl
    bit 5,a ;; "P"
    call nz,checkInput_pause
    and #04     ;; we keep the status of M
    ld b,a
    ld a,#08    ;; get the status of the 8th keyboard row (to get SPACE and arrow keys)
    call SNSMAT 
    cpl
    and #f1     ;; keep only the arrow keys and space
    or b        ;; we bring the state of M from before
    jr z,Readjoystick   ;; if no key was pressed, then check the joystick
    ; translarte the keyboard input to the same exact way in which the joystick is read
    ld b,a
    xor a
    bit 0,b
    jr z,checkInputNotTrigger1
    or #10
checkInputNotTrigger1:
    bit 2,b
    jr z,checkInputNotTrigger2
    or #20
checkInputNotTrigger2:
    bit 7,b
    jr z,checkInputNotRight
    or #08
checkInputNotRight:
    bit 4,b
    jr z,checkInputNotLeft
    or #04
checkInputNotLeft:
    bit 5,b
    jr z,checkInputNotUp
    or #01
checkInputNotUp:
    bit 6,b
    jr z,checkInputNotDown
    or #02
checkInputNotDown:
    ld (player_input_buffer),a
    ret

Readjoystick:   
    call readJoystick1Status
    ld (player_input_buffer),a
    ret

checkInput_pause:
    push af
    ld a,(game_state)
    cp GAME_STATE_PLAYING
    jr nz,checkInput_pause_resume_game2
    ; pause music:
    xor a
    ld (MUSIC_play),a
    call CLEAR_PSG_VOLUME

checkInput_pause_loop:
    call chheckInput_get_P
    jr nz,checkInput_pause_p_released
    halt
    jr checkInput_pause_loop
checkInput_pause_p_released:
    call chheckInput_get_P
    jr z,checkInput_pause_p_pressed_again
    halt
    jr checkInput_pause_p_released
checkInput_pause_p_pressed_again:
    call chheckInput_get_P
    jr nz,checkInput_pause_resume_game
    halt
    jr checkInput_pause_p_pressed_again
checkInput_pause_resume_game:
    ; resume music:
    ld a,1
    ld (MUSIC_play),a
checkInput_pause_resume_game2:
    pop af
    ret

chheckInput_get_P:
    ld a,#04    ;; get the status of the 4th keyboard row (to get the P key)
    call SNSMAT 
    bit 5,a ;; "P"
    ret    


;-----------------------------------------------
; checks for the status of trigger 1, sets 'a' to 1 if trigger 1 was just pressed,
; and updates (previous_trigger1) with the latest state of trigger 1
; - modifies bc 
;checkTrigger1updatingPrevious:
;    call checkTrigger1
;    ld hl,previous_trigger1
;    ld b,(hl)
;    ld (hl),a
;    or a
;    ret z
;    xor b
;    ret

;-----------------------------------------------
; checks for the status of trigger 1
;checkTrigger1:
;    ld a,#08    ;; get the status of the 8th keyboard row (to get SPACE and arrow keys)
;    call SNSMAT
;    cpl 
;    and #01
;    ret nz
;    call readJoystick1Status
;    and #10
;    ret
