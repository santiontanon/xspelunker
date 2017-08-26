;-----------------------------------------------
; Renders the hud to screen (including health, items, time and level)
renderHUD:
    ld hl,NAMTBL2
    call SETWRT

    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld b,32*2
    ld hl,HUD
renderHUD_loop:
    outi
    jp nz,renderHUD_loop
    ret


;-----------------------------------------------
; checks input for input selection
updateHUD:
    ld a,(player_input_buffer+2)
    bit INPUT_TRIGGER2_BIT,a
    jr nz,updateHUD_next_item_SFX
    ret

updateHUD_next_item_SFX:
    ld hl,SFX_weapon_switch
    call playSFX    
updateHUD_next_item:
    ld a,(player_selected_item)
    inc a
    and #07
    ld (player_selected_item),a
    ld hl,player_inventory
    ld b,0
    ld c,a
    add hl,bc
    add hl,bc
    ld a,(hl)
    or a
    jr z,updateHUD_next_item
    ld a,(player_selected_item)
    add a,a
    add a,a
    add a,a
    add a,a
    add a,7*8
    ld (sprite_attributes+ITEM_SELECTION_SPRITE*4+1),a
    ret


;-----------------------------------------------
; decreases by one the item count of the inventory itel pointed by HL,
; If we only have 1, then remove the item from the inventory
decreaseInventoryItemCountByOne:
    inc hl
    ld a,(hl)
    cp 1
    jr z,playerDropItem_lastItem
    dec (hl)    ; we have more, so, we just need to decrease the counter
    jp updateHUDItems
    
playerDropItem_lastItem:
    dec hl
    ld (hl),0
    ; if it's the last item we have, then move back to the machete
    call selectMachete
    jp updateHUDItems


;-----------------------------------------------
; selects the machete
selectMachete:
    ; if it's the last item we have, then move back to the machete
    xor a
    ld (player_selected_item),a
    ld a,7*8
    ld (sprite_attributes+ITEM_SELECTION_SPRITE*4+1),a
    ret
    

;-----------------------------------------------
; Updates the HUD with the current health
updateHUDhealth:
    ld hl,HUD+32
    ld a,(player_health)
    or a
    jr z,updateHUDhealth_dashes
    ld b,a
    ld a,TILE_HEART
updateHUDhealth_loop:
    ld (hl),a
    inc hl
    djnz updateHUDhealth_loop
updateHUDhealth_dashes:
    ld a,(player_health)
    sub PLAYER_MAX_HEALTH
    ret z
    neg
    ld b,a
    ld a,'-'
updateHUDhealth_loop2:
    ld (hl),a
    inc hl
    djnz updateHUDhealth_loop2
    ret


;-----------------------------------------------
; Updates the HUD with the current level
updateHUDLevel:
    ld a,(current_level_section)
    add a,'1'
    ld (HUD+32+29),a
    ld a,(current_level)
    add a,'1'
    ld (HUD+32+31),a
    ret


;-----------------------------------------------
; updates the game timer
updateTime:
    ld a,(game_cycle)
    and #3f
    ret nz  ; ech 64 game ticks we move the timer (this is not exactly a second, but close enough, and it's faster)

    ld hl,(accumulated_time)
    inc hl
    ld (accumulated_time),hl

    ; sound the alarm:
    ld a,(HUD+32+24)
    cp '0'
    jr nz,updateTime_no_alarm
    ld a,(HUD+32+26)
    cp '0'
    jr nz,updateTime_no_alarm

    ld hl,SFX_timer
    call playSFX

updateTime_no_alarm:
    ld a,(HUD+32+27)
    cp '0'
    jr z,updateTime_decrease_tenseconds
    dec a
    ld (HUD+32+27),a
    ret
updateTime_decrease_tenseconds:
    ld a,'9'
    ld (HUD+32+27),a
    ld a,(HUD+32+26)
    cp '0'
    jr z,updateTime_decrease_minutes
    dec a
    ld (HUD+32+26),a
    ret
updateTime_decrease_minutes:
    ld a,'5'
    ld (HUD+32+26),a
    ld a,(HUD+32+24)
    cp '0'
    jp z,state_gameover
    dec a
    ld (HUD+32+24),a
    ret


;-----------------------------------------------
; updates the items in the HUD according to the inventory variables
updateHUDItems:
    ld hl,player_inventory
    ld de,HUD+7
    ld b,INVENTORY_SIZE
updateHUDItems_loop:
    ld a,(hl)
    or a
    push hl
    push af
    jp z,updateHUDItems_draw_empty_item
    dec a
    jp z,updateHUDItems_draw_bomb
    dec a
    jp z,updateHUDItems_draw_rope
    dec a
    jp z,updateHUDItems_draw_arrows
    dec a
    jp z,updateHUDItems_draw_stone
    dec a
    jp z,updateHUDItems_draw_machete
    dec a
    jp z,updateHUDItems_draw_shield
    dec a
    jp z,updateHUDItems_draw_bow
    dec a
    jp z,updateHUDItems_draw_boots
    dec a
    jp z,updateHUDItems_draw_belt
    dec a
    jp z,updateHUDItems_draw_scubamask
    dec a
    jp z,updateHUDItems_draw_idol
    dec a
    jp z,updateHUDItems_draw_phaser
;    dec a
;    jp z,updateHUDItems_draw_boulder   ; boulders cannot be picked up so...
updateHUDItems_next:
    pop af
    pop hl
    inc hl
    ld a,(hl)
    cp 2
    call p,updateHUDItems_draw_item_counts
    inc hl
    inc de
    inc de
    djnz updateHUDItems_loop
    ret

updateHUDItems_draw_item_counts:
    add a,'0'
    push de
    push bc
    ex de,hl
    ld bc,33
    add hl,bc
    ld (hl),a
    ex de,hl
    pop bc
    pop de
    ret

; first pattern is in 'a', and then it's 'a+1', 'a+2' and 'a+3'
updateHUDItems_draw_generic_item:
    push bc
    push de
    ld (de),a
    inc a
    inc de
    ld (de),a
    inc a
    ld bc,31
    ex de,hl
    add hl,bc
    ex de,hl
    ld (de),a
    inc a
    inc de
    ld (de),a
    pop de
    pop bc
    ret

; array pointed to by 'hl':
updateHUDItems_draw_generic_item_from_array:
    push bc
    push de
    ldi
    ldi
    ld bc,30
    ex de,hl
    add hl,bc
    ex de,hl
    ldi
    ldi
    pop de
    pop bc
    ret


updateHUDItems_draw_empty_item:
    ld hl,empty_item_patterns
    call updateHUDItems_draw_generic_item_from_array
    jp updateHUDItems_next

updateHUDItems_draw_machete:
    ld hl,machete_patterns
    call updateHUDItems_draw_generic_item_from_array
    jp updateHUDItems_next

updateHUDItems_draw_bomb:
    ld a,116
    call updateHUDItems_draw_generic_item
    jp updateHUDItems_next

updateHUDItems_draw_rope:
    ld a,28
    call updateHUDItems_draw_generic_item
    jp updateHUDItems_next

updateHUDItems_draw_shield:
    ld a,108
    call updateHUDItems_draw_generic_item
    jp updateHUDItems_next

updateHUDItems_draw_bow:
    ld hl,bow_patterns
    call updateHUDItems_draw_generic_item_from_array
    jp updateHUDItems_next

updateHUDItems_draw_arrows:
    ld hl,arrow_patterns_gui
    call updateHUDItems_draw_generic_item_from_array
    jp updateHUDItems_next

updateHUDItems_draw_stone:
    ld hl,stone_patterns_gui
    call updateHUDItems_draw_generic_item_from_array
    jp updateHUDItems_next

updateHUDItems_draw_boots:
    ld hl,boots_patterns
    call updateHUDItems_draw_generic_item_from_array
    jp updateHUDItems_next

updateHUDItems_draw_belt:
    ld a,100
    call updateHUDItems_draw_generic_item
    jp updateHUDItems_next

updateHUDItems_draw_scubamask:
    ld a,112
    call updateHUDItems_draw_generic_item
    jp updateHUDItems_next

updateHUDItems_draw_idol:
    ld a,104
    call updateHUDItems_draw_generic_item
    jp updateHUDItems_next

updateHUDItems_draw_phaser:
    ld a,1
    call updateHUDItems_draw_generic_item
    jp updateHUDItems_next
