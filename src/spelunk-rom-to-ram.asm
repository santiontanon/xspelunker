    include "spelunk-constants.asm"
    org #0000   ; Start in the 2nd slot

;-----------------------------------------------
; Game variables to be copied to RAM
ROMtoRAM:
ROM_sprite_attributes:
    db 255,7*8,0,15 ; item selection
    db 200,0,4,15   ; player weapon
    db 200,0,8,9    ; player 
    db 200,0,12,10  
    db 200,0,PLAYER_BULLET_FIRST_SPRITE_PATTERN*4,15  ; player bullet 1
    db 200,0,(PLAYER_BULLET_FIRST_SPRITE_PATTERN+1)*4,15  ; player bullet 2
    REPT ENEMY_SPRITE_SLOTS
    db 200,0,0,0  
    ENDM
ROM_player_selected_item:
    db 0
;ROM_previous_trigger1:
;    db 0
ROM_game_cycle:
    db 0
ROM_player_input_buffer:
    db 0,0,0,0
ROM_player_input_double_click_state:
    db 0,0
ROM_player_jump_x_inertia:
    db 0
ROM_player_health:
    db 4
ROM_player_inventory:
    db ITEM_MACHETE,1
    db ITEM_BOMB,4
    db ITEM_ROPE,4
    db 0,0
    db 0,0
    db 0,0
    db 0,0
    db 0,0
ROM_current_level_section:
    db 0
ROM_current_level:
    db 0
ROM_accumulated_time:
    dw 0
ROM_HUD:
    db "HEALTH                  TIME LVL"
    db "------                  3:00 ---"
endROMtoRAM:

