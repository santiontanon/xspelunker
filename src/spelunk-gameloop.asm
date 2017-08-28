;-----------------------------------------------
; Main game loop!
state_playing:
    ld a,GAME_STATE_PLAYING
    ld (game_state),a

    call clearScreenLeftToRight


    ; clear all the sprite data
    ld hl,ROMtoRAM_compressed
    ld de,buffer2
    call pletter_unpack

    ld hl,buffer2
    ld de,sprite_attributes
    ld bc,NUMBER_OF_SPRITES_USED*4 + 1  ; +1 so that we also reset the 'player_selected_item' variable
    ldir


    ld a,(current_level_section)
    or a
    jr nz,state_playing_music_ruins
    ld a,5
    ld hl,music_ingame2
    call PlayCompressedSong    
    jr state_playing_music_started
state_playing_music_ruins:
    ld a,4
    ld hl,music_ingame
    call PlayCompressedSong    
state_playing_music_started:


    ld a,(map_width)
    sub 32
    ld (scroll_x_limit),a
    ld a,(map_height)
    sub 22  ;; we are only rendering 22 rows of the map (since 2 are for the scoreboard)
    ld (scroll_y_limit),a

    ; reset time:
    ld hl,HUD+32+24
    ld (hl),'3'
    inc hl
    inc hl
    ld (hl),'0'
    inc hl
    ld (hl),'0'

    call centerScrollOnCharacterY
    call centerScrollOnCharacterX
    ld hl,target_scroll_map_y
    ld de,scroll_map_y
    ldi
    ldi

    ; copy the player sprite attributes to the VDP:
    ld hl,sprite_attributes+PLAYER_SPRITE*4
    ld de,SPRATR2+PLAYER_SPRITE*4
    ld bc,8
    call LDIRVM
    call playerStateChange_idleRight

    call updateHUDhealth
    call updateHUDLevel
    call updateHUDItems

    ; load HUD sprite:
    ld de,item_selection_sprite
    ld hl,SPRTBL2+ITEM_SELECTION_SPRITE*32
    call loadSpriteToVDP

    call renderHUD

    call drawAllItems

state_playing_loop:
    ; wait for vsync:
    halt

    ; render the current state of the game:
    call renderSprites
    call updateExplosionsBeforeMapRendering
    call renderHUD
;    out (#2c),a    
    call renderMap_no_swtwrt
;    out (#2d),a
    call updateExplosionsAfterMapRendering

    ; update the game:
    call checkInput
    call updateHUD
    call playerUpdate
    call updateMapScroll
    call itemUpdate
    call updatePlayerBullets
    call calculatePlayerSpriteCoordinates
    call updateEnemies
    call updateMapAnimations
    call updateTime
    ld hl,game_cycle
    inc (hl)

    ; check if the player has reached the exit sign
    ld a,(player_y)
    ld hl,pcg_exit_y_coordinate
    cp (hl)
    jr nz,state_playing_loop_level_not_completed
    ld a,(player_x)
;    dec a
    inc hl
    cp (hl)
    jp m,state_playing_loop_level_not_completed
    jr state_playing_level_completed
state_playing_loop_level_not_completed:

    ; check that we are still in the GAME_STATE_PLAYING state:
    ld a,(game_state)
    cp GAME_STATE_PLAYING
    jp nz,state_gameover
    jr state_playing_loop


state_playing_level_completed:
    call StopPlayingMusic
    ; increase health:
    ld a,(player_health)
    cp PLAYER_MAX_HEALTH
    jp p,state_playing_level_completed_max_health
    inc a
    ld (player_health),a

state_playing_level_completed_max_health:
    ; increase level count
    ld hl,current_level
    inc (hl)
    ld a,(hl)    
    cp 4
    jr nz,state_playing_level_completed_still_in_same_section
    xor a
    ld (current_level),a
    ld hl,current_level_section
    inc (hl)

state_playing_level_completed_still_in_same_section:
    jp state_interlevel

