;-----------------------------------------------
; Copies the two sprite patterns that make up the player to the VDP
loadSecondPlayerSpriteToVDP:
    ld hl,SPRTBL2+(PLAYER_SPRITE+2)*32
    jp loadPlayerSpriteToVDP
loadFirstPlayerSpriteToVDP:
    ld hl,SPRTBL2+PLAYER_SPRITE*32
loadPlayerSpriteToVDP:
    push de
    call SETWRT
    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld b,32*2
    pop hl
setupPlayerSprites_loop2:
    outi
    jp nz,setupPlayerSprites_loop2
    ret


;-----------------------------------------------
; calculates the coordinates of the player and 
; updates the scroll target if it gets too close to the edge of the screen:
calculatePlayerSpriteCoordinates:
    ld a,(scroll_map_y)
    ld b,a
    ld a,(player_y)
    sub b
    add a,a
    add a,a
    add a,a
    ld b,a
    ld a,(player_y+1)
    add a,b
    add a,15  ; we add (16-1) to skip the scoreboard and the -1 is because since sprites are rendered at (y+1) by the VDP (oh well...)
    ld (sprite_attributes+PLAYER_SPRITE*4),a
    ld (sprite_attributes+(PLAYER_SPRITE+1)*4),a
    ; check if the player has gotten too close to the edge of the screen
    cp 32+16
    jp c,calculatePlayerSpriteCoordinates_updateTargetScrollY
    cp 192-(32+16)
    jp nc,calculatePlayerSpriteCoordinates_updateTargetScrollY

calculatePlayerSpriteCoordinatesX:
    ld a,(scroll_map_x)
    ld b,a
    ld a,(player_x)
    sub b
    add a,a
    add a,a
    add a,a
    ld b,a
    ld a,(player_x+1)
    add a,b    
    ld (sprite_attributes+PLAYER_SPRITE*4+1),a
    ld (sprite_attributes+(PLAYER_SPRITE+1)*4+1),a
    ; check if the player has gotten too close to the edge of the screen
    cp 32
    jp c,calculatePlayerSpriteCoordinates_updateTargetScrollX
    cp 256-(32+16)
    jp nc,calculatePlayerSpriteCoordinates_updateTargetScrollX

calculatePlayerSpriteCoordinates_Machete:
    ld a,(player_machete_timer)
    or a
    jp nz,playerUpdate_setMacheteSpriteProperties
    ret

calculatePlayerSpriteCoordinates_updateTargetScrollY:
    call centerScrollOnCharacterY
    jp calculatePlayerSpriteCoordinatesX
calculatePlayerSpriteCoordinates_updateTargetScrollX:
    call centerScrollOnCharacterX
    jp calculatePlayerSpriteCoordinates_Machete


;-----------------------------------------------
; checks for collision downwards
; c: x, b: y in cell coordinates
isPlayerOverGround:
    ld a,(player_y)
    add a,2
    ld b,a
    ld a,(player_x)
    ld c,a
    ld a,(player_x+1)
    cp COLLISION_BOX_MIN_PIXELS
    jp m,isPlayerOverGround2
    inc c
isPlayerOverGround2:
    ld a,(player_y+1)
    or a
    jp nz,isPlayerOverGround_consider_only_walls
    ld d,TILE_PLATFORM_START    ; if we are to check also for platforms
    jp isPlayerOverGround_continue
isPlayerOverGround_consider_only_walls:
    ld d,TILE_WALL_START    ; do not consider platforms, only walls 
isThereAWallOnTopOfPlayer_noDecY:
isPlayerOverGround_continue:
    call getMapCell
    jp nz,isPlayerOverGround_last_check ; if "nz", if means that getMapCell returned "outofbounds", and thus the rest of calls will also
                                        ; return out of bounds. So, we directly skip the other calls
    cp d
    jp nc,isPlayerOverGround_Ground

    ld a,(player_x+1)
    cp 9-COLLISION_BOX_MIN_PIXELS
    jp p,isPlayerOverGround_double_check
    cp COLLISION_BOX_MIN_PIXELS
    jp p,isPlayerOverGround_done
isPlayerOverGround_double_check:
    inc hl  ; "hl" has a pointer to the position in the map
    ld a,(hl)
isPlayerOverGround_last_check:
    cp d
    jp nc,isPlayerOverGround_Ground
isPlayerOverGround_done:
    xor a
    ret 


isPlayerOverGround_ignoringPlatforms:
    ld a,(player_y)
    add a,2
    ld b,a
    ld a,(player_x)
    ld c,a

    ld a,(player_x+1)
    cp COLLISION_BOX_MIN_PIXELS
    jp m,isPlayerOverGround_ignoringPlatforms2
    inc c
isPlayerOverGround_ignoringPlatforms2:

    ld a,(player_y+1)
    jp isPlayerOverGround_consider_only_walls


;-----------------------------------------------
; checks for collision upwards
; c: x, b: y in cell coordinates
isThereAWallOnTopOfPlayer:
    ld a,(player_y)
    ld b,a
    ld a,(player_x)
    ld c,a
    ld a,(player_x+1)
    cp COLLISION_BOX_MIN_PIXELS
    jp m,isThereAWallOnTopOfPlayer2
    inc c
isThereAWallOnTopOfPlayer2:
    ld a,(player_y+1)
    or a
    ld d,TILE_WALL_START
    jp nz,isThereAWallOnTopOfPlayer_noDecY
    dec b
    jp isThereAWallOnTopOfPlayer_noDecY


;-----------------------------------------------
; checks for collision to the right
isThereAWallToTheRightOfPlayer:
    ld a,(player_x+1)
    cp 8-COLLISION_BOX_MIN_PIXELS
    jp nz,isThereAWallToTheLeftOfPlayer_done    ; only when changing tile we need to do collision

    ld a,(player_y)
    ld b,a
    ld a,(player_x)
    add a,2
    ld c,a

    ; Check if the player is walking to the right of the exit sign
    ld a,(pcg_exit_y_coordinate)
    cp b
    jp nz,isThereAWallToTheRightOfPlayer_not_at_exit
    ld a,(pcg_exit_x_coordinate)
    cp c
    jp p,isThereAWallToTheRightOfPlayer_not_at_exit
    ; player is on the exit, so, it should be able to go to the right:
    xor a
    ret


;-----------------------------------------------
; checks for collision to the left
isThereAWallToTheLeftOfPlayer:
    ld a,(player_x+1)
    cp COLLISION_BOX_MIN_PIXELS
    jp nz,isThereAWallToTheLeftOfPlayer_done    ; only when changing tile we need to do collision

    ld a,(player_y)
    ld b,a
    ld a,(player_x)
    ld c,a
isThereAWallToTheRightOfPlayer_not_at_exit:
isThereAWallToTheLeftOfPlayer_noDecX:
    call getMapCell
    jp nz,isThereAWallToTheLeftOfPlayer_last_check
    cp TILE_WALL_START
    jp nc,isThereAWallToTheLeftOfPlayer_Wall
    ld b,0
    ld a,(map_width)
    ld c,a
    add hl,bc
    ld a,(hl)
    cp TILE_WALL_START
    jp nc,isThereAWallToTheLeftOfPlayer_Wall
    ld a,(player_y+1)
    or a
    jp z,isThereAWallToTheLeftOfPlayer_done
    add hl,bc
    ld a,(hl)
isThereAWallToTheLeftOfPlayer_last_check:
    cp TILE_WALL_START
    jp nc,isThereAWallToTheLeftOfPlayer_Wall
isThereAWallToTheLeftOfPlayer_done:
    xor a
    ret


;-----------------------------------------------
; checks it the player can grab on to a vine
wouldPlayerBeOnVineIfGoingDown:
    ld a,(player_y)
    ld b,a
    inc b
    inc b
    jp isPlayerOverVine_x
isPlayerOverVine:
    ld a,(player_y)
    ld b,a
    inc b
isPlayerOverVine_x:
    ld a,(player_x)
    ld c,a
    ld a,(player_y+1)
    or a
    jp z,isPlayerOverVine_continue
    inc b   ; when the pixel offset on the y axis is >= 1, check one tile lower
isPlayerOverVine_continue:
    ld a,(player_x+1)
    cp 4
    jp p,isPlayerOverVine_check_second_tile
    ; check (x,y+2)
    push bc
    call getMapCell
    pop bc
    call isVine
    jp nz,isPlayerOverVine_isVine
isPlayerOverVine_check_second_tile:
    inc c
    ; check (x+1,y+2)
    push bc
    call getMapCell
    pop bc
    call isVine
    jp nz,isPlayerOverVine_isVine
    xor a
    ret 
isPlayerOverVine_isVine:
    ld hl,player_vine_x_coordinate
    ld (hl),c ; the "x" coordinate that matched with the vine
    ret


;-----------------------------------------------
; checks it the player is touching a hazard
isPlayerOnHazard:
    ld a,(player_y)
    ld b,a
    inc b
isPlayerOnHazard_x:
    ld a,(player_x)
    ld c,a
    ld a,(player_y+1)
    cp 4
    jp m,isPlayerOnHazard_continue
    inc b   ; when the pixel offset on the y axis is >= 4, check one tile lower
isPlayerOnHazard_continue:
    ld a,(player_x+1)
    cp COLLISION_BOX_MIN_PIXELS
    jp m,isPlayerOnHazard_continue2
    inc c
isPlayerOnHazard_continue2:
    call getMapCell
    jp nz,isPlayerOnHazard_last_check ; if "nz", if means that getMapCell returned "outofbounds", and thus the rest of calls will also
                                     ; return out of bounds. So, we directly skip the other calls
    call isHazard
    ret nz
    ld a,(player_x+1)
    cp 9-COLLISION_BOX_MIN_PIXELS
    jp p,isPlayerOnHazard_double_check
    cp COLLISION_BOX_MIN_PIXELS
    jp p,isPlayerOnHazard_done
isPlayerOnHazard_double_check:
    inc hl
    ld a,(hl)
isPlayerOnHazard_last_check:
    call isHazard
    ret nz
isPlayerOnHazard_done:
    xor a
    ret 


;-----------------------------------------------
; checks it the player is under water completely (isPlayerUnderWater),
; or just in water, but with its head out (isPlayerOnWater)
isPlayerUnderWater:
    ld a,(player_y)
    ld b,a
    dec b
    jp isPlayerOnWater_x
isPlayerOnWater:
    ld a,(player_y)
    ld b,a
isPlayerOnWater_x:
    ld a,(player_x)
    ld c,a
    ld a,(player_y+1)
    cp 4
    jp m,isPlayerOnWater_continue
    inc b   ; when the pixel offset on the y axis is >= 4, check one tile lower
isPlayerOnWater_continue:
;    ld a,(player_x+1)
;    cp 4
;    jp m,isPlayerOnWater_continue2
;    inc c
;isPlayerOnWater_continue2:
    ; check (x,y+2)
    call getMapCell
;    jp nz,isPlayerOnWater_last_check ; if "nz", if means that getMapCell returned "outofbounds", and thus the rest of calls will also
;                                     ; return out of bounds. So, we directly skip the other calls
    call isWater
    ret nz
isPlayerOnWater_check_second_tile:
    inc hl
    ld a,(hl)
isPlayerOnWater_last_check:
    call isWater
    ret nz
    xor a
    ret 


;-----------------------------------------------
; Checks whether the player has item "a" in the inventory
playerHasItem:
    ld hl,player_inventory
    ld b,8
playerHasItem_loop:
    cp (hl)
    jp z,playerHasItem_item_found
    inc hl
    inc hl
    djnz playerHasItem_loop
    xor a
    ret
playerHasItem_item_found:
isThereAWallToTheLeftOfPlayer_Wall:
isPlayerOverGround_Ground:
    or 1
    ret


;-----------------------------------------------
; Returns the item the player has selected in "a"
playerSelectedItem:
    ld a,(player_selected_item)
    add a,a
    ld b,0
    ld c,a
    ld hl,player_inventory
    add hl,bc
    ld a,(hl)
    ret


;-----------------------------------------------
; picks up the item pointed up by "hl" and puts it in the player inventory
playerPickupItem:
    ; we remember the type of item:
    ld a,(hl)
    cp ITEM_BUTTON
    ret z   ; we cannot pick up buttons
    cp ITEM_DOOR
    ret z   ; we cannot pick up doors
    ld c,a

    ; clear the items from the map:
    push hl
    push bc
    call removeAllItems
    pop bc

    ; add item to player inventory (if we have space)
    ; loop1: try to find an item stack of the same type:
    ld hl,player_inventory
    ld b,INVENTORY_SIZE
playerPickupItem_loop1:
    ld a,(hl)
    cp c
    jp nz,playerPickupItem_loop1_continue
    ; we have found an item on the inventory of the same type:
    cp ITEM_MACHETE
    jp p,playerPickupItem_loop1_continue ; if it's an item type that cannot be stacked, ignore    
    inc hl
    ld a,(hl)
    cp 9
    jp m,playerPickupItem_found_same_type_inventory_spot
    dec hl
playerPickupItem_loop1_continue:
    inc hl
    inc hl
    djnz playerPickupItem_loop1

    ; loop2: otherwise, try to find an empty spot in the inventory:
    ld hl,player_inventory
    ld b,INVENTORY_SIZE
playerPickupItem_loop2:
    ld a,(hl)
    or a
    jp z,playerPickupItem_found_empty_inventory_spot
    inc hl
    inc hl
    djnz playerPickupItem_loop2
    pop hl  ; we restore the stack
    jp playerPickupItem_no_space_on_inventory

playerPickupItem_found_empty_inventory_spot:
    ld (hl),c
    inc hl
    ld (hl),1
    jp playerPickupItem_remove_from_map

playerPickupItem_found_same_type_inventory_spot:
    inc (hl)

playerPickupItem_remove_from_map:
    ; remove the item from the map:
    pop hl
    ld (hl),0

    call updateHUDItems

    ld hl,decompressed_sfx + SFX_item_pickup
    call playSFX

playerPickupItem_no_space_on_inventory:
    ; re-add all the items to the map:
    call drawAllItems
    or 1    ; we signal that we successfully picked up an item
    ret


;-----------------------------------------------
; Drops one unit of the item currently selected
playerDropItem:
    ld hl,player_inventory
    ld a,(player_selected_item)
    add a,a
    ld b,0
    ld c,a
    add hl,bc
    ld a,(hl)
    or a
    ret z   ; If we don't have anything selected, then we are done
    cp ITEM_MACHETE
    ret z   ; we don't want to drep the machete!
    cp ITEM_BOMB
    jp z,playerDropBomb

    push hl
    ld a,(player_x)
    ld c,a
    ld a,(player_y)
    ld b,a
    ld a,(hl)
    call spawnItemInMap
    pop hl

    ; remove item from inventory:
    jp decreaseInventoryItemCountByOne

playerDropBomb:
    ld ix,player_bullets
    ld a,(ix)
    or a
    jp z,playerDropBomb_found_spot
    ld ix,player_bullets+PLAYER_BULLET_STRUCT_SIZE
    ld a,(ix)
    or a
    ret nz
playerDropBomb_found_spot:
    ; decrease the number of bombs in one (HL still points to the item):
    call decreaseInventoryItemCountByOne
    push ix
    pop hl
    ld (hl),ITEM_BOMB
    inc hl
    ld (hl),0   ; timer (state 1)
    inc hl
    ld (hl),5   ; state 2 = direction "none"
    inc hl
    ld (hl),0   ; state 3
    inc hl
    ld de,player_y
    ex de,hl
    ldi
    ldi ; copy y
    ldi
    ldi ; copy x
    ; offset the bullet to the proper starting position:
    ld a,(player_state)
    and #01
    jp nz,playerDropBomb_found_spot_left
    ld a,(player_bullet_initial_x_offset+6)
    ld c,a
    ld a,(player_bullet_initial_y_offset+6)
    ld b,a
    call moveSprite
    jp selectMachete_if_configured
playerDropBomb_found_spot_left:
    ld a,(player_bullet_initial_x_offset+7)
    ld c,a
    ld a,(player_bullet_initial_y_offset+7)
    ld b,a
    call moveSprite
    jp selectMachete_if_configured


;-----------------------------------------------
; Check if we hit an enemy with the machete
checkIfWeHitAnEnemyWithTheMachete:
    ; check to see if the machete is being used and hit something:
    ld a,(player_y)
    inc a
    ld d,a
    ld h,a

    ld a,(player_state)
    and #01
    jp z,checkIfWeHitAnEnemyWithTheMachete_right
checkIfWeHitAnEnemyWithTheMachete_left:
    ld a,(player_x)
    inc a
    ld l,a
    sub 3
    ld e,a
    jp checkIfWeHitAnEnemyWithTheMachete_continue
checkIfWeHitAnEnemyWithTheMachete_right:
    ld a,(player_x)
    inc a
    ld e,a
    add a,3
    ld l,a
checkIfWeHitAnEnemyWithTheMachete_continue
    call areaCollisionWithEnemies
    ret z

    push iy
    pop ix
    jp enemyHit


;-----------------------------------------------
; updates the player character depending on the state it is on (idle, jumping, etc.)
playerUpdate:
    ld hl,player_state_timer
    inc (hl)
    ld hl,player_no_climb_timer
    call decreaseHLIfNotZero
    call playerFSMUpdate

    ; check for out of bounds
    ld a,(player_y)
    ld b,a
    ld a,(map_height)
    cp b
    jp m,playerUpdate_requestgameover

    ; check for touching hazards, enemies, or explosions:
    ld hl,player_inmune_timer
    ld a,(hl)
    or a
    jp nz,playerUpdate_inmune_flash
    ld a,(player_state)
    and #fe ; the last bit of the player state is always whether facing right/left
    cp PLAYER_STATE_DEAD_RIGHT
    ret z
    call isPlayerOnHazard
    jp nz,playerHit
    call isPlayerOnExplosion
    jp nz,playerHit
    call playerCollisionWithEnemies
    ret z
playerHit:
    ; player touched a hazard:
    ld hl,player_health
    call decreaseHLIfNotZero
    call updateHUDhealth
    ld hl,decompressed_sfx + SFX_playerhit
    call playSFX

    ld a,PLAYER_INMUNITY_TIME
    ld (player_inmune_timer),a
    ld a,(player_state)
    and #01
    jp z,playerStateChange_hurtRight
    jp playerStateChange_hurtLeft

playerUpdate_inmune_flash:
    dec (hl)    ; hl is pointing to player_inmune_timer
    and #04
    jp nz,playerUpdate_inmune_flash_red
    ld a,10
    ld (sprite_attributes+(PLAYER_SPRITE+1)*4+3),a
    ret
playerUpdate_inmune_flash_red:
    ld a,9
    ld (sprite_attributes+(PLAYER_SPRITE+1)*4+3),a
    ret

playerFSMUpdate:
    ld a,(player_state)
    sra a
    jp z,playerUpdate_idle_right
    dec a
    jp z,playerUpdate_crouch_right
    dec a
    jp z,playerUpdate_falling_right
    dec a
    jp z,playerUpdate_walking_right
    dec a
    jp z,playerUpdate_jumping_right
    dec a
    jp z,playerUpdate_climbing_right
    dec a
    jp z,playerUpdate_swimming_right
    dec a
    jp z,playerUpdate_machete_right
    dec a
    jp z,playerUpdate_shield_right
    dec a
    jp z,playerUpdate_directional_weapon_right
    dec a
    jp z,playerUpdate_hurt_right
    dec a
    jp z,playerUpdate_dead_right
    ret

;-----------------------------------------------
; Idle player state
playerUpdate_idle_right:
playerUpdate_idle_left:
    call isPlayerOverGround
    jp z,playerStateChange_fall
    ld a,(player_state_timer)
    and #10
    call z,playerUpdate_set_sprite1
    call nz,playerUpdate_set_sprite2
    ; input:
    ld a,(player_input_buffer+2)
    bit INPUT_UP_BIT,a
    jp nz,playerUpdate_idle_up_pressed
    bit INPUT_TRIGGER1_BIT,a
    jp nz,playerUpdate_idle_trigger1_pressed
    ld a,(player_input_buffer)
    bit INPUT_DOWN_BIT,a
    jp nz,playerStateChange_crouch
    bit INPUT_RIGHT_BIT,a
    jp z,playerUpdate_idle_rightNotPressed
playerUpdate_idle_rightPressed:
    bit INPUT_LEFT_BIT,a
    jp z,playerStateChange_walkRight
    ret
playerUpdate_idle_rightNotPressed:
    bit INPUT_LEFT_BIT,a
    jp nz,playerStateChange_walkLeft
    ret
playerUpdate_idle_up_pressed:
    call isPlayerOverVine
    jp nz,playerStateChange_climbing_accounting_for_timer
    ld a,(player_input_buffer)
    bit INPUT_RIGHT_BIT,a
    jp nz,playerStateChange_jumpRight_withInertia
    bit INPUT_LEFT_BIT,a
    jp nz,playerStateChange_jumpLeft_withInertia
    jp playerStateChange_jump
playerUpdate_idle_trigger1_pressed:
playerUpdate_walking_trigger1_pressed:
    call playerSelectedItem
    cp ITEM_MACHETE
    jp z,playerStateChange_machete
;    cp ITEM_SHIELD
;    jp z,playerStateChange_shield
    cp ITEM_PHASER
    jp z,playerStateChange_dWeapon
    cp ITEM_BOW
    jp z,playerStateChange_dWeapon
    cp ITEM_STONE
    jp z,playerStateChange_dWeapon
    cp ITEM_ARROW
    jp z,playerStateChange_dWeapon
    cp ITEM_BOMB
    jp z,playerStateChange_dWeapon
    cp ITEM_ROPE
    jp z,playerStateChange_dWeapon
    ret


;-----------------------------------------------
; Crouch player state
playerUpdate_crouch_right:
playerUpdate_crouch_left:
    call isPlayerOverGround
    jp z,playerStateChange_fall
    ld a,(player_state_timer)
    ; input:
    ld a,(player_input_buffer)
    bit INPUT_DOWN_BIT,a
    jp z,playerStateChange_idle
    ld a,(player_input_buffer+2)
    bit INPUT_TRIGGER1_BIT,a
    call nz,trigger1_while_crouching
    call wouldPlayerBeOnVineIfGoingDown
    ret z
    call playerUpdate_safe_incrementY_ignoringPlatforms
    jp z,playerStateChange_climbing_accounting_for_timer
    ret
trigger1_while_crouching:
    call collisionWithItems
    call nz,playerPickupItem
    ret nz  ; if we picked up an item, then we are done, otherwise, we drop an item
    jp playerDropItem


;-----------------------------------------------
; Falling player state
playerUpdate_falling_right:
playerUpdate_falling_left:
    ld a,ITEM_BELT
    call playerHasItem
    jp z,playerUpdate_falling_no_belt
    ld hl,fallYOffsetTable_belt
    ld a,(player_state_timer)
    dec a
    cp fallYOffsetTable_beltEnd-fallYOffsetTable_belt
    jp m,playerUpdate_falling_continue
    ld a,(fallYOffsetTable_beltEnd-fallYOffsetTable_belt)-1
    jp playerUpdate_falling_continue
playerUpdate_falling_no_belt:
    ld hl,fallYOffsetTable
    ld a,(player_state_timer)
    dec a
    cp fallYOffsetTableEnd-fallYOffsetTable
    jp m,playerUpdate_falling_continue
;    ld a,(fallYOffsetTableEnd-fallYOffsetTable)-1
    ld b,4  ; we just hardcode the value
    jp playerUpdate_falling_loop
playerUpdate_falling_continue:
    ADD_HL_A
    ld b,(hl)
playerUpdate_falling_loop:
    push bc
    call playerUpdate_safe_incrementY
    call isPlayerOverGround
    pop bc
    jp nz,playerUpdate_falling_reached_ground
    push bc
    call isPlayerOnWater
    pop bc
    jp nz,playerStateChange_swimming
    djnz playerUpdate_falling_loop
playerUpdate_falling_no_decrement:
    ld a,(player_jump_x_inertia)
    cp 1
    push af
    call z,playerUpdate_safe_incrementX
    pop af
    inc a
    call z,playerUpdate_safe_decrementX
    ld a,(player_state_timer)
    and 1
    jp z,playerUpdate_falling_no_x_control
    ld a,(player_input_buffer)
    bit INPUT_RIGHT_BIT,a
    call nz,playerUpdate_safe_incrementX
    ld a,(player_input_buffer)
    bit INPUT_LEFT_BIT,a
    call nz,playerUpdate_safe_decrementX
playerUpdate_falling_no_x_control:
    ; check if we are using the machete:
    ld a,(player_machete_timer)
    or a
    jp z,playerUpdate_falling_no_machete
    dec a
    ld (player_machete_timer),a
    jp nz,playerUpdate_falling_no_machete
    call playerSpriteChange_jump
    ld a,200
    ld (sprite_attributes+PLAYER_WEAPON_SPRITE*4),a ; remove the machete
playerUpdate_falling_no_machete:
    ld a,(player_input_buffer+2)
    bit INPUT_TRIGGER1_BIT,a
    call nz,playerUpdate_jumping_trigger1_press ; since we need to do the same during falling than during jumping
    ld a,(player_input_buffer)
    bit INPUT_UP_BIT,a
    jp z,playerUpdate_falling_up_not_pressed
    call isPlayerOverVine
    jp nz,playerStateChange_climbing_accounting_for_timer
playerUpdate_falling_up_not_pressed:
    ret
playerUpdate_falling_reached_ground:
    ld a,ITEM_BELT
    call playerHasItem
    jp nz,playerStateChange_idle    ; with belt, you can fall from arbitrarily high
    ld a,(player_state_timer)
    cp PLAYER_FALL_HURT_TIME
    ; player fell from too high:
    call p,playerUpdate_beinghurt_safe
    ld a,(player_health)
    or a    
    jp nz,playerStateChange_idle    ; if health = 0, we don't go, since we are dead!
    ret


;-----------------------------------------------
; Walking player state
playerUpdate_walking_right:
playerUpdate_walking_left:
    call isPlayerOverGround
    jp z,playerStateChange_fall
    ld a,(player_state_timer)
    and #08
    call z,playerUpdate_set_sprite1
    call nz,playerUpdate_set_sprite2
    ; input:
    ld a,(player_input_buffer+2)
    bit INPUT_UP_BIT,a
    jp nz,playerUpdate_walking_up_pressed
    bit INPUT_TRIGGER1_BIT,a
    jp nz,playerUpdate_walking_trigger1_pressed
    ld a,(player_input_buffer)
    bit INPUT_DOWN_BIT,a
    jp nz,playerStateChange_crouch
    bit INPUT_LEFT_BIT,a
    jp z,playerUpdate_walking_leftNotPressed
playerUpdate_walking_leftPressed:
    bit INPUT_RIGHT_BIT,a
    jp nz,playerStateChange_idle
    call playerUpdate_safe_decrementX
    ; check if we are pushing a block:
    jp z,playerUpdate_walking_leftPressed_no_collision
    ; we are walking against a wall:
    ld hl,player_push_timer
    inc (hl)
    ld a,(hl)
    cp PUSH_TIME
    jp m,playerUpdate_walking_leftPressed_after_collision
    call checkForBoulderPushLeft
    jp playerUpdate_walking_leftPressed_after_collision
playerUpdate_walking_leftPressed_no_collision:
    xor a
    ld (player_push_timer),a
playerUpdate_walking_leftPressed_after_collision:
    ld a,(player_state)
    and #01
    jp z,playerStateChange_walkLeft    ; if we were walking right, then walk left
    ret
playerUpdate_walking_leftNotPressed:
    bit INPUT_RIGHT_BIT,a
    jp z,playerStateChange_idle
    call playerUpdate_safe_incrementX    
    ; check if we are pushing a block:
    jp z,playerUpdate_walking_rightPressed_no_collision
    ; we are walking against a wall:
    ld hl,player_push_timer
    inc (hl)
    ld a,(hl)
    cp PUSH_TIME
    jp m,playerUpdate_walking_rightPressed_after_collision
    call checkForBoulderPushRight
    jp playerUpdate_walking_rightPressed_after_collision
playerUpdate_walking_rightPressed_no_collision
    xor a
    ld (player_push_timer),a
playerUpdate_walking_rightPressed_after_collision:
    ld a,(player_state)
    and #01
    jp nz,playerStateChange_walkRight    ; if we were walking left, then walk right
    ret
playerUpdate_walking_up_pressed:
    call isPlayerOverVine
    jp nz,playerStateChange_climbing_accounting_for_timer
    jp playerStateChange_jump_withInertia


;-----------------------------------------------
; Jumping player state
playerUpdate_jumping_right:
playerUpdate_jumping_left:
    ld a,ITEM_BOOTS
    call playerHasItem
    jp z,playerUpdate_jumping_no_boots
playerUpdate_jumping_boots:
    ld a,(player_state_timer)
    dec a
    cp jumpYOffsetTable_bootsEnd-jumpYOffsetTable_boots
    jp p,playerStateChange_fall
    ld hl,jumpYOffsetTable_boots

    cp (jumpYOffsetTable_bootsEnd-jumpYOffsetTable_boots)-10
    jp p,playerUpdate_jumping_continue
    ; check if jump has to end
    ld a,(player_input_buffer)
    bit INPUT_UP_BIT,a
    jp nz,playerUpdate_jumping_continue_pre
    ; end jump early
    ld a,(jumpYOffsetTable_bootsEnd-jumpYOffsetTable_boots)-10
    ld (player_state_timer),a
    jp playerUpdate_jumping_continue

playerUpdate_jumping_no_boots:
    ld a,(player_state_timer)
    dec a
    cp jumpYOffsetTableEnd-jumpYOffsetTable
    jp p,playerStateChange_fall
    ld hl,jumpYOffsetTable

    cp (jumpYOffsetTableEnd-jumpYOffsetTable)-10
    jp p,playerUpdate_jumping_continue
    ; check if jump has to end
    ld a,(player_input_buffer)
    bit INPUT_UP_BIT,a
    jp nz,playerUpdate_jumping_continue_pre
    ; end jump early
    ld a,(jumpYOffsetTableEnd-jumpYOffsetTable)-10
    ld (player_state_timer),a
playerUpdate_jumping_continue_pre:
    ld a,(player_state_timer)
    dec a

playerUpdate_jumping_continue:
    ADD_HL_A
    ld a,(hl)
    or a
    jp z,playerUpdate_jumping_no_decrement
    ld b,a
playerUpdate_jumping_loop:
    push bc
    call playerUpdate_safe_decrementY
    pop bc
    djnz playerUpdate_jumping_loop
playerUpdate_jumping_no_decrement:
    ld a,(player_jump_x_inertia)
    cp 1
    push af
    call z,playerUpdate_safe_incrementX
    pop af
    inc a
    call z,playerUpdate_safe_decrementX
    ld a,(player_state_timer)
    and 1
    jp z,playerUpdate_jumping_no_x_control  ;; air control is only 50% of the movement speed
    ld a,(player_input_buffer)
    bit INPUT_RIGHT_BIT,a
    call nz,playerUpdate_safe_incrementX
    ld a,(player_input_buffer)
    bit INPUT_LEFT_BIT,a
    call nz,playerUpdate_safe_decrementX
playerUpdate_jumping_no_x_control:
    ; check if we are using the machete:
    ld a,(player_machete_timer)
    or a
    jp z,playerUpdate_jumping_no_machete
    dec a
    ld (player_machete_timer),a
    jp nz,playerUpdate_jumping_no_machete
    call playerSpriteChange_jump
    ld a,200
    ld (sprite_attributes+PLAYER_WEAPON_SPRITE*4),a ; remove the machete
playerUpdate_jumping_no_machete:
    ld a,(player_input_buffer+2)
    bit INPUT_TRIGGER1_BIT,a
    call nz,playerUpdate_jumping_trigger1_press
    ld a,(player_input_buffer)
    bit INPUT_UP_BIT,a
    jp z,playerUpdate_jumping_up_not_pressed
    call isPlayerOverVine
    jp nz,playerStateChange_climbing_accounting_for_timer
playerUpdate_jumping_up_not_pressed:
    ret
playerUpdate_jumping_trigger1_press:
    call playerSelectedItem
    cp ITEM_MACHETE
    jp z,playerUpdate_jumping_trigger_machete
    ret
playerUpdate_jumping_trigger_machete:
    call playerSpriteChange_machete
    ld a,MACHETE_TIME
    ld (player_machete_timer),a
    ld hl,decompressed_sfx + SFX_sword_swing
    call playSFX
    jp checkIfWeHitAnEnemyWithTheMachete    


;-----------------------------------------------
; Climbing player state
playerUpdate_climbing_right:
playerUpdate_climbing_left:
    call isPlayerOverVine
    jp z,playerStateChange_fall
    ld hl,player_state_timer
    dec (hl) ; counter act the automatic increment of the timer (we should only increment when moving in this state)
    ld a,(hl)
    and #04
    call z,playerUpdate_set_sprite1
    call nz,playerUpdate_set_sprite2    
    ; input:
    ld a,(config_rope_jump)
    or a
    jr z,playerUpdate_climbing_right_jump_with_double_tap
    ld a,(player_input_buffer+2)    ; jump with trigger A
    bit INPUT_TRIGGER1_BIT,a
    jp nz,playerUpdate_climbing_jump
    ld a,(player_input_buffer+3)
    jr playerUpdate_climbing_right_jump_with_double_tap_continue
playerUpdate_climbing_right_jump_with_double_tap:
    ld a,(player_input_buffer+3)    ; double click buffer
    bit INPUT_UP_BIT,a
    jp nz,playerUpdate_climbing_jump
playerUpdate_climbing_right_jump_with_double_tap_continue:
;    bit INPUT_LEFT_BIT,a
;    jp nz,playerStateChange_fallLeft_withInertia_from_vine
;    bit INPUT_RIGHT_BIT,a
;    jp nz,playerStateChange_fallRight_withInertia_from_vine
    bit INPUT_DOWN_BIT,a
    jp nz,playerStateChange_fall
    ld a,(player_input_buffer)
    bit INPUT_LEFT_BIT,a
    jp nz,playerUpdate_climbing_try_to_switch_left
    bit INPUT_RIGHT_BIT,a
    jp nz,playerUpdate_climbing_try_to_switch_right
    bit INPUT_UP_BIT,a
    jp nz,playerUpdate_climbing_go_up
    bit INPUT_DOWN_BIT,a
    jp nz,playerUpdate_climbing_go_down
    ret
playerUpdate_climbing_go_up:
    ld hl,player_state_timer
    inc (hl)
    ld a,(hl)
    and #01
    ret z
    jp playerUpdate_safe_decrementY
playerUpdate_climbing_go_down:
    ld hl,player_state_timer
    dec (hl)
    ld a,(hl)
    and #01
    ret z
    call playerUpdate_safe_incrementY
    call isPlayerOverGround
    jp nz,playerStateChange_idle
    ret
playerUpdate_climbing_jump:
    ld a,(player_input_buffer)
    bit INPUT_RIGHT_BIT,a
    jp nz,playerStateChange_jumpRight_withInertia_from_vine
    bit INPUT_LEFT_BIT,a
    jp nz,playerStateChange_jumpLeft_withInertia_from_vine
    jp playerStateChange_jump_from_vine
playerUpdate_climbing_try_to_switch_left:
    ld a,(player_state)
    and #01
    ret nz  ; if we are already looking left, then no point
    call isThereAWallToTheRightOfPlayer
    ret nz
    jp playerStateChange_climbing_left_accounting_for_timer
playerUpdate_climbing_try_to_switch_right:
    ld a,(player_state)
    and #01
    ret z  ; if we are already looking right, then no point
    call isThereAWallToTheLeftOfPlayer
    ret nz
    jp playerStateChange_climbing_right_accounting_for_timer

;-----------------------------------------------
; Swimming player state
playerUpdate_swimming_right:
playerUpdate_swimming_left:
    ld a,(player_state_timer) 
    and #01
    ret z
    ld a,(player_state_timer) 
    and #10
    call z,playerUpdate_set_sprite1
    call nz,playerUpdate_set_sprite2    
    ld a,(player_state_timer)
    and #1f
    sra a
    ld hl,swimmingYOffsetTable
    ADD_HL_A
    ld a,(hl)
    or a
    jp z,playerUpdate_swimming_continue
    jp m,playerUpdate_swimming_go_down
    call playerUpdate_safe_incrementY
    jp playerUpdate_swimming_continue
playerUpdate_swimming_go_down:
    call playerUpdate_safe_decrementY
playerUpdate_swimming_continue:
    ld a,ITEM_SCUBAMASK
    call playerHasItem
    jp nz,playerUpdate_swimming_hasscubamask
    call isPlayerUnderWater
    call nz,playerUpdate_beinghurt_safe
playerUpdate_swimming_hasscubamask:
    ld a,(player_input_buffer)
    bit INPUT_RIGHT_BIT,a
    push af
    call nz,playerUpdate_swimming_right_pressed
    pop af
    bit INPUT_DOWN_BIT,a
    push af
    call nz,playerUpdate_safe_incrementY
    pop af
    bit INPUT_UP_BIT,a
    push af
    call nz,playerUpdate_swimming_up_pressed
    pop af
    bit INPUT_LEFT_BIT,a
    jp nz,playerUpdate_swimming_left_pressed
    ret
playerUpdate_swimming_right_pressed:
    call playerUpdate_safe_incrementX
    call isPlayerOnWater
    jp z,playerUpdate_swimming_change_to_idle_if_still_swimming
    ld a,(player_state)
    and #01
    jp nz,playerStateChange_swimming_right_noreset
    ret
playerUpdate_swimming_left_pressed:
    call playerUpdate_safe_decrementX
    call isPlayerOnWater
    jp z,playerUpdate_swimming_change_to_idle_if_still_swimming
    ld a,(player_state)
    and #01
    jp z,playerStateChange_swimming_left_noreset
    ret
playerUpdate_swimming_up_pressed:
    call playerUpdate_safe_decrementY
    call isPlayerOnWater
    ret nz
    call playerStateChange_jump
    ld hl,decompressed_sfx + SFX_watersplash
    jp playSFX   
playerUpdate_swimming_change_to_idle_if_still_swimming:
    ld a,(player_state)
    and #fe
    cp PLAYER_STATE_SWIMMING_RIGHT
    jp z,playerStateChange_idle
    ret


;-----------------------------------------------
; Machete player state
playerUpdate_machete_right:
playerUpdate_machete_left:
    ld hl,player_machete_timer
    ld a,(hl)
    or a
    jp z,playerUpdate_machete_done
    dec (hl)
    jp playerUpdate_setMacheteSpriteProperties
playerUpdate_machete_done:
    ; move the machete away
    ld a,200
    ld (sprite_attributes+PLAYER_WEAPON_SPRITE*4),a
    jp playerStateChange_idle

playerUpdate_setMacheteSpriteProperties:
    ; set the machete coordinates based on the player sprite coordiantes:
    ld hl,sprite_attributes+PLAYER_SPRITE*4
    ld de,sprite_attributes+PLAYER_WEAPON_SPRITE*4
    ldi
    ld a,(player_state)
    and #01
    ld a,(hl)
    jp nz,playerUpdate_setMacheteSpriteProperties_left
    add a,16
    ld (de),a
    inc de
    inc de
    ld a,14     ; set the machete to grey color
    ld (de),a   
    ret
playerUpdate_setMacheteSpriteProperties_left:
    sub 9
    cp 255-10
    jp nc,playerUpdate_setMacheteSpriteProperties_left_tooclose_to_border
    ld (de),a
    inc de
    inc de
    ld a,14     ; set the machete to grey color
    ld (de),a   
    ret
playerUpdate_setMacheteSpriteProperties_left_tooclose_to_border:
    ld a,200
    ld (sprite_attributes+PLAYER_WEAPON_SPRITE*4),a
    ret


;-----------------------------------------------
; Shield player state
playerUpdate_shield_right:
playerUpdate_shield_left:
    ld hl,player_state_timer
    inc (hl)
    ld a,(hl)
    cp 32
    jp z,playerStateChange_idle
    ret


;-----------------------------------------------
; Directional weapon (phaser, bow, etc.) player state
playerUpdate_directional_weapon_right:
playerUpdate_directional_weapon_left:
    ld a,(player_input_buffer)
    bit INPUT_TRIGGER1_BIT,a
    jp z,playerUpdate_directional_weapon_trigger_released
    bit INPUT_LEFT_BIT,a
    jp nz,playerUpdate_directional_weapon_left_pressed
playerUpdate_directional_weapon_left_not_pressed
    bit INPUT_RIGHT_BIT,a
    jp nz,playerUpdate_directional_weapon_only_right_pressed
    ; neither left nor right are pressed:
    bit INPUT_UP_BIT,a
    jp z,playerUpdate_directional_weapon_draw_weapon
    ; up is pressed:
    ld a,(player_state)
    and #01
    jp nz,playerUpdate_directional_weapon_up_facing_left
    ld de,player_sprites+17*64  ; up, facing right
    call loadFirstPlayerSpriteToVDP
    ld a,3
    ld (player_directional_weapon_direction),a
    jp playerUpdate_directional_weapon_draw_weapon
playerUpdate_directional_weapon_up_facing_left:
    ld de,player_sprites+21*64  ; up, facing left
    call loadFirstPlayerSpriteToVDP
    ld a,2
    ld (player_directional_weapon_direction),a
    jp playerUpdate_directional_weapon_draw_weapon

playerUpdate_directional_weapon_only_right_pressed:
    call playerStateChange_dWeaponRight
    ld a,(player_input_buffer)
    bit INPUT_UP_BIT,a
    ld a,5
    ld (player_directional_weapon_direction),a
    jp z,playerUpdate_directional_weapon_draw_weapon
    ; up-right are pressed:
    ld de,player_sprites+16*64  ; up-right, facing right
    call loadFirstPlayerSpriteToVDP
    ld a,4
    ld (player_directional_weapon_direction),a
    jp playerUpdate_directional_weapon_draw_weapon

playerUpdate_directional_weapon_left_pressed:
    bit INPUT_RIGHT_BIT,a
    call z,playerStateChange_dWeaponLeft
    ld a,(player_input_buffer)
    bit INPUT_UP_BIT,a
    ld a,0  ; cannot be "xor a", since that will mess up with the jp z below
    ld (player_directional_weapon_direction),a
    jp z,playerUpdate_directional_weapon_draw_weapon
    ; up-right are pressed:
    ld de,player_sprites+20*64  ; up-left, facing left
    call loadFirstPlayerSpriteToVDP
    ld a,1
    ld (player_directional_weapon_direction),a
    jp playerUpdate_directional_weapon_draw_weapon

playerUpdate_directional_weapon_draw_weapon:
    call playerSelectedItem
    cp ITEM_PHASER
    jp z,playerUpdate_directional_weapon_draw_phaser
    cp ITEM_BOW
    jp z,playerUpdate_directional_weapon_draw_bow
    ret

playerUpdate_directional_weapon_draw_phaser:
    ; select the proper sprite based on the directional
    ld a,(player_directional_weapon_direction)
    ld h,0
    ld l,a
    call HLTimes32
    ld de,item_sprites+8*32
    add hl,de
    ex de,hl
    ; load the sprite to the VDP:
    ld hl,SPRTBL2+PLAYER_WEAPON_SPRITE*32
    call loadSpriteToVDP
    ; set the sprite properties:
    ld hl,sprite_attributes+PLAYER_SPRITE*4
    ld b,(hl)
    inc hl
    ld c,(hl)
    ld hl,sprite_attributes+PLAYER_WEAPON_SPRITE*4
    ; apply the generic y offset
    ld de,phaser_sprite_y_offsets
    ld a,(player_directional_weapon_direction)
    ADD_DE_A
    ld a,(de)
    add a,b
    ld (hl),a
    inc hl
    ; apply the generic x offset
    ld de,phaser_sprite_x_offsets
    ld a,(player_directional_weapon_direction)
    ADD_DE_A
    ld a,(de)
    add a,c
    ld (hl),a
    inc hl
    inc hl
    ld (hl),4   ; set the gun to blue color
    ret

playerUpdate_directional_weapon_draw_bow:
    ; select the proper sprite based on the directional
    ld a,(player_directional_weapon_direction)
    ld h,0
    ld l,a
    call HLTimes32
    ld de,item_sprites+2*32
    add hl,de
    ex de,hl
    ; load the sprite to the VDP:
    ld hl,SPRTBL2+PLAYER_WEAPON_SPRITE*32
    call loadSpriteToVDP
    ; set the sprite properties:
    ld hl,sprite_attributes+PLAYER_SPRITE*4
    ld b,(hl)
    inc hl
    ld c,(hl)
    ld hl,sprite_attributes+PLAYER_WEAPON_SPRITE*4
    ; apply the generic y offset
;    ld de,bow_sprite_y_offsets
;    ld a,(player_directional_weapon_direction)
;    ADD_DE_A
;    ld a,(de)
;    add a,b
    ld (hl),b
    inc hl
    ; apply the generic x offset
    ld de,bow_sprite_x_offsets
    ld a,(player_directional_weapon_direction)
    ADD_DE_A
    ld a,(de)
    add a,c
    ld (hl),a
    inc hl
    inc hl
    ld (hl),15   ; set the bow to white color
    ret

playerUpdate_directional_weapon_trigger_released:
    ; use the item:
    call playerSelectedItem
    cp ITEM_BOMB
    jr z,playerUpdate_directional_weapon_fire_bullet
    cp ITEM_ROPE
    jr z,playerUpdate_directional_weapon_fire_bullet
    cp ITEM_STONE
    jr z,playerUpdate_directional_weapon_fire_bullet
    cp ITEM_ARROW
    jr z,playerUpdate_directional_weapon_fire_bullet
    cp ITEM_BOW
    jr z,playerUpdate_directional_weapon_fire_bullet
    cp ITEM_PHASER
    jr z,playerUpdate_directional_weapon_fire_bullet
    jp playerStateChange_idle

playerUpdate_directional_weapon_fire_bullet:
    ld b,a  ; we save the weapon type
    ld ix,player_bullets
    ld a,(ix)
    or a
    jr z,playerUpdate_directional_weapon_fire_bullet_found_spot
    ld ix,player_bullets+PLAYER_BULLET_STRUCT_SIZE
    ld a,(ix)
    or a
    jp nz,playerStateChange_idle
playerUpdate_directional_weapon_fire_bullet_found_spot:
    ld a,b
    cp ITEM_PHASER
    jr z,playerUpdate_directional_weapon_fire_bullet_no_bullet_decrease
    cp ITEM_BOW
    jr z,playerUpdate_directional_weapon_fire_bullet_check_for_arrows

    ; decrease the number of bombs/stones/arrows/ropes in one (HL still points to the item):
    push bc ; this is to remember the item type below
    call decreaseInventoryItemCountByOne
    pop bc  
    call selectMachete_if_configured  ; for stones, bombs and ropes, we reset to machete to prevent accidentally throwing all kind of things!

playerUpdate_directional_weapon_fire_bullet_no_bullet_decrease:    
    push ix
    pop hl
    ld (hl),b   ; bullet type
    inc hl
    xor a
    ld (hl),a   ; timer (state 1)
    inc hl
    ld a,(player_directional_weapon_direction)
    cp 3
    jp m,playerUpdate_directional_weapon_fire_bullet_found_spot_continue
    dec a   ; since there are 2 separate states for pointing up, here, we remove one of them
playerUpdate_directional_weapon_fire_bullet_found_spot_continue:
    ld (hl),a   ; state 2
    inc hl
    xor a
    ld (hl),a   ; state 3
    inc hl
    push hl
    ld de,player_y
    ex de,hl
    ldi
    ldi ; copy y
    ldi
    ldi ; copy x
    ; offset the bullet to the proper starting position:
    ld hl,player_bullet_initial_x_offset
    ld a,(player_directional_weapon_direction)
    ADD_HL_A_VIA_BC
    ld c,(hl)
    ld de,player_bullet_initial_y_offset-player_bullet_initial_x_offset
    add hl,de
    ld b,(hl)
    pop hl
    call moveSprite
    jp playerStateChange_idle

playerUpdate_directional_weapon_fire_bullet_check_for_arrows:
    ld a,ITEM_ARROW
    push bc
    call playerHasItem
    pop bc
    jp z,playerStateChange_idle
    push bc
    call decreaseInventoryItemCountByOne
    pop bc
    jp playerUpdate_directional_weapon_fire_bullet_no_bullet_decrease


;-----------------------------------------------
; Being hurt player state
playerUpdate_hurt_right:
playerUpdate_hurt_left:
    ld a,(player_state_timer)
    dec a
    cp hurtYOffsetTableEnd-hurtYOffsetTable
    jp m,playerUpdate_hurt_speedIncreasing
    ld a,(hurtYOffsetTableEnd-hurtYOffsetTable)-1
playerUpdate_hurt_speedIncreasing:
    ld hl,hurtYOffsetTable
    ADD_HL_A
    ld a,(hl)
    or a
    jp z,playerUpdate_hurt_no_decrement
    ld b,a
playerUpdate_hurt_loop:
    push bc
    call playerUpdate_safe_incrementY
    call isPlayerOverGround
    pop bc
    jp nz,playerUpdate_hurt_hit_ground
    push bc
    call isPlayerOnWater
    pop bc
    jp nz,playerUpdate_hurt_hit_ground
    djnz playerUpdate_hurt_loop
playerUpdate_hurt_no_decrement:
    ld a,(player_jump_x_inertia)
    cp 1
    push af
    call z,playerUpdate_safe_double_incrementX
    pop af
    inc a
    call z,playerUpdate_safe_double_decrementX
    ret
playerUpdate_hurt_hit_ground:
    ld a,(player_health)
    or a
    jp z,playerStateChange_dead
    jp playerStateChange_idle


;-----------------------------------------------
; Dead player state
playerUpdate_dead_right:
playerUpdate_dead_left:
    ld a,(player_state_timer)
    cp 80
    jp p,playerUpdate_requestgameover
    ret


;-----------------------------------------------
; Auxiliary functions used in some of the playerUpdate states
playerUpdate_beinghurt_safe:
    ld a,(player_inmune_timer)
    or a
    ret nz
    ld hl,player_health
    dec (hl)
    call updateHUDhealth
    ld a,(player_health)
    or a
    jp z,playerStateChange_dead
    ld a,PLAYER_INMUNITY_TIME
    ld (player_inmune_timer),a
    ld hl,decompressed_sfx + SFX_playerhit
    jp playSFX


playerUpdate_set_sprite1:
    ld a,PLAYER_SPRITE*4
    ld (sprite_attributes+PLAYER_SPRITE*4+2),a    
    ld a,(PLAYER_SPRITE+1)*4
    ld (sprite_attributes+(PLAYER_SPRITE+1)*4+2),a
    ret

playerUpdate_set_sprite2:
    ld a,(PLAYER_SPRITE+2)*4
    ld (sprite_attributes+PLAYER_SPRITE*4+2),a    
    ld a,(PLAYER_SPRITE+3)*4
    ld (sprite_attributes+(PLAYER_SPRITE+1)*4+2),a
    ret


; This version returns Z is it could move, and NZ if it could not move
playerUpdate_safe_incrementY_ignoringPlatforms:
    call isPlayerOverGround_ignoringPlatforms
    ret nz
    call playerUpdate_incrementY
    xor a
    ret

playerUpdate_safe_incrementY:
    call isPlayerOverGround
    ret nz
playerUpdate_incrementY:
    ld hl,player_y+1
    ld a,(hl)
    inc a
    cp 8
    jp p,playerUpdate_incrementY_tileChange
    ld (hl),a
    ret
playerUpdate_incrementY_tileChange:
    ld (hl),0
    dec hl
    inc (hl)
    ret


playerUpdate_safe_decrementY:
    call isThereAWallOnTopOfPlayer
    ret nz
playerUpdate_decrementY:
    ld hl,player_y+1
    ld a,(hl)
    dec a
    jp m,playerUpdate_decrementY_tileChange
    ld (hl),a
    ret
playerUpdate_decrementY_tileChange:
    ld (hl),7
    dec hl
    dec (hl)
    ret


playerUpdate_safe_double_incrementX:
    call playerUpdate_safe_incrementX
; after this function, z is reset if we could move and set if we couldn't move:
playerUpdate_safe_incrementX:
    call isThereAWallToTheRightOfPlayer
    ret nz
playerUpdate_incrementX:
    ld hl,player_x+1
    ld a,(hl)
    inc a
    cp 8
    jp p,playerUpdate_incrementX_tileChange
    ld (hl),a
    xor a
    ret
playerUpdate_incrementX_tileChange:
    ld (hl),0
    dec hl
    inc (hl)
    xor a
    ret


; after this function, z is reset if we could move and set if we couldn't move
playerUpdate_safe_double_decrementX:
    call playerUpdate_safe_decrementX
playerUpdate_safe_decrementX:
    call isThereAWallToTheLeftOfPlayer
    ret nz
playerUpdate_decrementX:
    ld hl,player_x+1
    ld a,(hl)
    dec a
    jp m,playerUpdate_decrementX_tileChange
    ld (hl),a
    xor a
    ret
playerUpdate_decrementX_tileChange:
    ld (hl),7
    dec hl
    ld a,(hl)
    or a
    jr z,playerUpdate_decrementX_left_border
    dec (hl)
    xor a
    ret
playerUpdate_decrementX_left_border:
    inc hl
    ld (hl),0
    or 1
    ret


playerUpdate_requestgameover:
    ld a,GAME_STATE_GAMEOVER
    ld (game_state),a
    ret

;-----------------------------------------------
; functions to change player state

playerStateChange_idle:
    xor a
    ld (player_jump_x_inertia),a
    call playerStateChange_clearTimerAndMachete
    ld a,(player_state)
    and #01
    jr nz,playerStateChange_idleLeft

playerStateChange_idleRight:
    ld a,PLAYER_STATE_IDLE_RIGHT
    ld (player_state),a
    ld de,player_sprites
    call loadFirstPlayerSpriteToVDP
    ld de,player_sprites+4*64
    call loadSecondPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_idleLeft:
    ld a,PLAYER_STATE_IDLE_LEFT
    ld (player_state),a
    ld de,player_sprites+7*64
    call loadFirstPlayerSpriteToVDP
    ld de,player_sprites+11*64
    call loadSecondPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_crouch:
    ld a,(player_state)
    and #01
    jr nz,playerStateChange_crouchLeft

playerStateChange_crouchRight:
    call centerScrollOnCharacterX
    call centerScrollOnCharacterY
    ld a,PLAYER_STATE_CROUCHING_RIGHT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld de,player_sprites+1*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_crouchLeft:
    call centerScrollOnCharacterX
    call centerScrollOnCharacterY
    ld a,PLAYER_STATE_CROUCHING_LEFT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld de,player_sprites+8*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_fall:
    ld a,(player_state)
    and #01
    jr z,playerStateChange_fallRight
    jr playerStateChange_fallLeft

;playerStateChange_fallRight_withInertia_from_vine:
;    ld a,TIME_TO_GRAB_ROPE_AGAIN
;    ld (player_no_climb_timer),a
playerStateChange_fallRight_withInertia:
    ld a,1
    ld (player_jump_x_inertia),a
playerStateChange_fallRight:
    ld a,PLAYER_STATE_FALLING_RIGHT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld a,(player_machete_timer) ;; if we are using the machete, do not change sprite
    or a
    ret nz
    ld de,player_sprites+5*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

;playerStateChange_fallLeft_withInertia_from_vine:
;    ld a,TIME_TO_GRAB_ROPE_AGAIN
;    ld (player_no_climb_timer),a
playerStateChange_fallLeft_withInertia:
    ld a,-1
    ld (player_jump_x_inertia),a
playerStateChange_fallLeft:
    ld a,PLAYER_STATE_FALLING_LEFT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld a,(player_machete_timer) ;; if we are using the machete, do not change sprite
    or a
    ret nz
    ld de,player_sprites+12*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_walkRight:
    ld a,PLAYER_STATE_WALKING_RIGHT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld (player_push_timer),a
    ld de,player_sprites+5*64
    call loadFirstPlayerSpriteToVDP
    ld de,player_sprites+3*64
    call loadSecondPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_walkLeft:
    ld a,PLAYER_STATE_WALKING_LEFT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld (player_push_timer),a
    ld de,player_sprites+12*64
    call loadFirstPlayerSpriteToVDP
    ld de,player_sprites+10*64
    call loadSecondPlayerSpriteToVDP
    jp playerUpdate_set_sprite1


playerSpriteChange_jump:
playerSpriteChange_fall:
    ld a,(player_state)
    and #01
    jr nz,playerSpriteChange_jumpLeft
    jr playerSpriteChange_jumpRight

playerStateChange_jump:
    ld a,(player_state)
    and #01
    jp nz,playerStateChange_jumpLeft
    jp playerStateChange_jumpRight

playerStateChange_jump_withInertia:
    ld a,(player_state)
    and #01
    jr nz,playerStateChange_jumpLeft_withInertia

playerStateChange_jumpRight_withInertia:
    ld a,1
    ld (player_jump_x_inertia),a
playerStateChange_jumpRight:
    ld hl,decompressed_sfx + SFX_jump
    call playSFX
    ld a,PLAYER_STATE_JUMPING_RIGHT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
playerSpriteChange_jumpRight:
    ld de,player_sprites+5*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_jumpLeft_withInertia:
    ld a,-1
    ld (player_jump_x_inertia),a
playerStateChange_jumpLeft:
    ld hl,decompressed_sfx + SFX_jump
    call playSFX
    ld a,PLAYER_STATE_JUMPING_LEFT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
playerSpriteChange_jumpLeft:
    ld de,player_sprites+12*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1


playerStateChange_jump_from_vine:
    ld a,(player_state)
    and #01
    jr nz,playerStateChange_jumpLeft_from_vine
    jr playerStateChange_jumpRight_from_vine

playerStateChange_jumpRight_withInertia_from_vine:
    ld a,1
    ld (player_jump_x_inertia),a
playerStateChange_jumpRight_from_vine:
    ld a,TIME_TO_GRAB_ROPE_AGAIN
    ld (player_no_climb_timer),a
    ld a,PLAYER_STATE_JUMPING_RIGHT
    ld (player_state),a
    ld a,3 ; jump from vine is shorter
    ld (player_state_timer),a
    ld de,player_sprites+5*64
    call loadFirstPlayerSpriteToVDP
    call playerUpdate_set_sprite1
    ld hl,decompressed_sfx + SFX_jump
    jp playSFX

playerStateChange_jumpLeft_withInertia_from_vine:
    ld a,-1
    ld (player_jump_x_inertia),a
playerStateChange_jumpLeft_from_vine:
    ld a,TIME_TO_GRAB_ROPE_AGAIN
    ld (player_no_climb_timer),a
    ld a,PLAYER_STATE_JUMPING_LEFT
    ld (player_state),a
    ld a,4  ; jump from vine is shorter
    ld (player_state_timer),a
    ld de,player_sprites+12*64
    call loadFirstPlayerSpriteToVDP
    call playerUpdate_set_sprite1
    ld hl,decompressed_sfx + SFX_jump
    jp playSFX


playerStateChange_climbing_accounting_for_timer:
    call playerStateChange_clearMachete
    ld a,(player_state)
    and #01
    jr nz,playerStateChange_climbing_left_accounting_for_timer

playerStateChange_climbing_right_accounting_for_timer:
    ld a,(player_no_climb_timer)
    or a
    ret nz
playerStateChange_climbing_right:
    ld a,(player_vine_x_coordinate)
    dec a
    ld (player_x),a
    xor a
    ld (player_x+1),a
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_CLIMBING_RIGHT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld de,player_sprites+2*64
    call loadFirstPlayerSpriteToVDP
    ld de,player_sprites+6*64
    call loadSecondPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_climbing_left_accounting_for_timer:
    ld a,(player_no_climb_timer)
    or a
    ret nz
playerStateChange_climbing_left:
    ld a,(player_vine_x_coordinate)
    ld (player_x),a
    xor a
    ld (player_x+1),a
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_CLIMBING_LEFT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld de,player_sprites+9*64
    call loadFirstPlayerSpriteToVDP
    ld de,player_sprites+13*64
    call loadSecondPlayerSpriteToVDP
    jp playerUpdate_set_sprite1


playerStateChange_swimming:
    call spawnNewEnemy
    jr z,playerStateChange_swimming_no_splash
    ld (iy),ENEMY_EXPLOSION
    ld (iy+1),1
    ld (iy+2),0
    ld (iy+3),1 ; splash sprite
    ld a,(player_y)
    dec a
    ld (iy+4),a
    ld (iy+5),0
    ld a,(player_x)
    ld (iy+6),a
    ld a,(player_x+1)
    ld (iy+7),a
playerStateChange_swimming_no_splash:
    ld a,(player_state)
    and #01
    jr nz,playerStateChange_swimming_left

playerStateChange_swimming_right:
    call playerStateChange_clearMachete
    ld hl,decompressed_sfx + SFX_watersplash
    call playSFX    
    xor a
    ld (player_jump_x_inertia),a
    ld (player_state_timer),a
playerStateChange_swimming_right_noreset:
    ld a,PLAYER_STATE_SWIMMING_RIGHT
    ld (player_state),a
    ld de,player_sprites+5*64
    call loadFirstPlayerSpriteToVDP
    ld de,player_sprites+4*64
    call loadSecondPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_swimming_left:
    call playerStateChange_clearMachete
    ld hl,decompressed_sfx + SFX_watersplash
    call playSFX    
    xor a
    ld (player_jump_x_inertia),a
    ld (player_state_timer),a
playerStateChange_swimming_left_noreset:
    ld a,PLAYER_STATE_SWIMMING_LEFT
    ld (player_state),a
    ld de,player_sprites+12*64
    call loadFirstPlayerSpriteToVDP
    ld de,player_sprites+11*64
    call loadSecondPlayerSpriteToVDP    
    jp playerUpdate_set_sprite1


playerSpriteChange_machete:
    ld a,(player_state)
    and #01
    jp nz,playerSpritehange_macheteLeft
    jp playerSpritehange_macheteRight

playerStateChange_machete:
    ld hl,decompressed_sfx + SFX_sword_swing
    call playSFX

    call checkIfWeHitAnEnemyWithTheMachete

    ld a,(player_state)
    and #01
    jr nz,playerStateChange_macheteLeft

playerStateChange_macheteRight:
    ld a,MACHETE_TIME
    ld (player_machete_timer),a
    xor a
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_MACHETE_RIGHT
    ld (player_state),a
playerSpritehange_macheteRight
    ld de,player_sprites+14*64
    call loadFirstPlayerSpriteToVDP
    ld hl,SPRTBL2+PLAYER_WEAPON_SPRITE*32
    ld de,item_sprites
    call loadSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_macheteLeft:
    ld a,MACHETE_TIME
    ld (player_machete_timer),a
    xor a
;    ld (player_state_timer),a
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_MACHETE_LEFT
    ld (player_state),a
playerSpritehange_macheteLeft
    ld de,player_sprites+18*64
    call loadFirstPlayerSpriteToVDP
    ld hl,SPRTBL2+PLAYER_WEAPON_SPRITE*32
    ld de,item_sprites+1*32
    call loadSpriteToVDP
    jp playerUpdate_set_sprite1


;playerStateChange_shield:
;    ld a,(player_state)
;    and #01
;    jp nz,playerStateChange_shieldLeft
;
playerStateChange_shieldRight:
    ld a,5
    ld (player_directional_weapon_direction),a
    xor a
    ld (player_state_timer),a
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_SHIELD_RIGHT
    ld (player_state),a
playerSpritehange_shieldRight
    ld de,player_sprites+22*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_shieldLeft:
    xor a
    ld (player_directional_weapon_direction),a
    ld (player_state_timer),a
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_SHIELD_LEFT
    ld (player_state),a
playerSpritehange_shieldLeft
    ld de,player_sprites+24*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1


playerStateChange_dWeapon:
    ld a,(player_state)
    and #01
    jr nz,playerStateChange_dWeaponLeft

playerStateChange_dWeaponRight:
    xor a
    ld (player_state_timer),a
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_D_WEAPON_RIGHT
    ld (player_state),a
    ld a,5
    ld (player_directional_weapon_direction),a
playerSpritehange_dWeaponRight
    ld de,player_sprites+15*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_dWeaponLeft:
    xor a
    ld (player_state_timer),a
    ld (player_jump_x_inertia),a
    ld (player_directional_weapon_direction),a
    ld a,PLAYER_STATE_D_WEAPON_LEFT
    ld (player_state),a
playerSpritehange_dWeaponLeft
    ld de,player_sprites+19*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_hurtRight:
    call playerUpdate_safe_decrementY   ; lift the character a bit, so it's not over the ground
    ld a,-1
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_HURT_RIGHT
    ld (player_state),a
    call playerStateChange_clearTimerAndMachete
    ld de,player_sprites+26*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_hurtLeft:
    call playerUpdate_safe_decrementY   ; lift the character a bit, so it's not over the ground
    ld a,1
    ld (player_jump_x_inertia),a
    ld a,PLAYER_STATE_HURT_LEFT
    ld (player_state),a
    xor a
    call playerStateChange_clearTimerAndMachete
    ld de,player_sprites+27*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1


playerStateChange_dead:
    ld a,(player_state)
    and #01
    jr nz,playerStateChange_dead_left

playerStateChange_dead_right:
    ld a,PLAYER_STATE_DEAD_RIGHT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld de,player_sprites+28*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1

playerStateChange_dead_left:
    ld a,PLAYER_STATE_DEAD_LEFT
    ld (player_state),a
    xor a
    ld (player_state_timer),a
    ld de,player_sprites+29*64
    call loadFirstPlayerSpriteToVDP
    jp playerUpdate_set_sprite1


playerStateChange_clearTimerAndMachete:
    xor a
    ld (player_state_timer),a
playerStateChange_clearMachete:
    xor a
    ld (player_machete_timer),a
    ld a,200
    ld (sprite_attributes+PLAYER_WEAPON_SPRITE*4),a ; remove the machete    
    ret


;-----------------------------------------------
; Checks whether the player is colliding with any enemy.
; - If there is collision, NZ is set, and the enemy is returned in "IY"
; - If there is no collision, Z will be true
playerCollisionWithEnemies:
    ; calculate the collision box of the player:
    ld a,(player_y)
    ld d,a
    inc a
    ld h,a
    ld a,(player_y+1)
    cp 4
    jp m,playerCollisionWithEnemies_no_y_correction
    inc d
    inc h
playerCollisionWithEnemies_no_y_correction:
    ld a,(player_state)
    and #fe
    cp PLAYER_STATE_CROUCHING_RIGHT
    jp nz,playerCollisionWithEnemies_no_crouching
    inc d   ; if the player is crouching, we make the bounding box smaller
playerCollisionWithEnemies_no_crouching:
    ld a,(player_x)
    ld e,a
    ld l,a
    ld a,(player_x+1)
    cp COLLISION_BOX_MIN_PIXELS
    jp m,playerCollisionWithEnemies_x_case1
    cp 9-COLLISION_BOX_MIN_PIXELS
    jp m,playerCollisionWithEnemies_no_x_correction
playerCollisionWithEnemies_x_case3:
    inc e
    inc l
    inc l
    jp playerCollisionWithEnemies_no_x_correction
playerCollisionWithEnemies_x_case1:
    inc l

;    inc a
;    ld a,(player_x+1)
;    cp 4
;    jp m,playerCollisionWithEnemies_no_x_correction
;    inc e
;    inc l

playerCollisionWithEnemies_no_x_correction:
    ; iterate over all the enemies for collision (rather than using the "areaCollisionWithEnemies" function, I wrote a
    ; different routine here, since this is called at every game frame, and needs to be fast)
    ld a,(game_cycle)
    ld ixl,a
    ld a,(map_n_enemies)
    or a
    ret z
    ld iy,map_enemies
playerCollisionWithEnemies_loop:
    push af
    xor ixl
    and #03
    jp nz,playerCollisionWithEnemies_loop_continue2  ; only check 1/4 of the enemies at each cycle
    ; filter out those enemiestoo far in the y dimension:
    ld a,(iy+4)
    sub d
    cp 3
    jp p,playerCollisionWithEnemies_loop_continue2
    cp -3
    jp m,playerCollisionWithEnemies_loop_continue2
    ; filter out those enemiestoo far in the x dimension:
    ld a,(iy+6)
    sub e
    cp 3
    jp p,playerCollisionWithEnemies_loop_continue2
    cp -3
    jp m,playerCollisionWithEnemies_loop_continue2

    ; filter out enemies that cannot have any collision
    ld a,(iy)
    or a
    jp z,playerCollisionWithEnemies_loop_continue2
    cp ENEMY_EXPLOSION
    jp z,playerCollisionWithEnemies_loop_continue2
    cp ENEMY_PIRANHA
    jp z,playerCollisionWithEnemies_loop_check_if_hidden_piranha
playerCollisionWithEnemies_loop_before_collision_check:
    call areaCollisionWithEnemy
    jp nz,playerCollisionWithEnemies_collision
playerCollisionWithEnemies_loop_continue2:
    ld bc,ENEMY_STRUCT_SIZE
    add iy,bc
    pop af
    dec a
    jp nz,playerCollisionWithEnemies_loop
    xor a
    ret
playerCollisionWithEnemies_collision:
    ld a,(iy)
    cp ENEMY_PINECONE
    jr z,playerCollisionWithEnemies_collision_shieldable_enemy
    cp ENEMY_BULLET
    jr z,playerCollisionWithEnemies_collision_shieldable_enemy
    cp ENEMY_BULLET_LASERH
    jr z,playerCollisionWithEnemies_collision_shieldable_enemy
    cp ENEMY_BULLET_LASERV
    jr z,playerCollisionWithEnemies_collision_shieldable_enemy
playerCollisionWithEnemies_collision_definitively_collision:
    or 1    ; make NZ true
    pop bc
    ret

playerCollisionWithEnemies_loop_check_if_hidden_piranha:
    ld a,(iy+2)
    cp 128
    jp c,playerCollisionWithEnemies_loop_continue2
    jp playerCollisionWithEnemies_loop_before_collision_check

playerCollisionWithEnemies_collision_shieldable_enemy:
    ld a,(player_state)
    and #fe
    cp PLAYER_STATE_IDLE_RIGHT
    call z,playerCollisionWithEnemies_loop_shieldable_enemy_idle
    cp PLAYER_STATE_SHIELD_RIGHT
    jp nz,playerCollisionWithEnemies_collision_definitively_collision

    ; check if the bullet is colliding in the right side of the shield:
    push hl
    push de
    ld a,(player_directional_weapon_direction)
    or a
    jp z,playerCollisionWithEnemies_loop_shieldable_enemy_left  ; 0
    dec a
;    jp z,playerCollisionWithEnemies_loop_shieldable_enemy_left_up  ; 1
    dec a
    jp z,playerCollisionWithEnemies_loop_shieldable_enemy_up    ; 2
    dec a
    jp z,playerCollisionWithEnemies_loop_shieldable_enemy_up    ; 3
;    dec a
;    jp z,playerCollisionWithEnemies_loop_shieldable_enemy_right_up ; 4
;    jp playerCollisionWithEnemies_loop_shieldable_enemy_right  ; 5

playerCollisionWithEnemies_loop_shieldable_enemy_right:
    inc e
    call areaCollisionWithEnemy
    pop hl
    pop de
    jp nz,playerCollisionWithEnemies_loop_shieldable_enemy_shielded
    or 1
    pop bc
    ret

playerCollisionWithEnemies_loop_shieldable_enemy_shielded:
    ; bullet deflected:
    ld (iy),0
    push hl
    ld hl,decompressed_sfx + SFX_hit_deflected
    call playSFX
    pop hl
    jp playerCollisionWithEnemies_loop_continue2

playerCollisionWithEnemies_loop_shieldable_enemy_left:
    dec l
    call areaCollisionWithEnemy
    pop hl
    pop de
    jp nz,playerCollisionWithEnemies_loop_shieldable_enemy_shielded
    or 1
    pop bc
    ret

;playerCollisionWithEnemies_loop_shieldable_enemy_left_up:
;    inc d
;    inc e
;    call areaCollisionWithEnemy
;    pop hl
;    pop de
;    jp z,playerCollisionWithEnemies_loop_shieldable_enemy_shielded
;    pop bc
;    ret

playerCollisionWithEnemies_loop_shieldable_enemy_up:
    dec h
    call areaCollisionWithEnemy
    pop hl
    pop de
    jr nz,playerCollisionWithEnemies_loop_shieldable_enemy_shielded
    or 1
    pop bc
    ret

;playerCollisionWithEnemies_loop_shieldable_enemy_right_up:
;    inc d
;    dec l
;    call areaCollisionWithEnemy
;    pop hl
;    pop de
;    jp z,playerCollisionWithEnemies_loop_shieldable_enemy_shielded
;    pop bc
;    ret

playerCollisionWithEnemies_loop_shieldable_enemy_idle:
    push af
    push hl
    push de
    ; 1) check if we have shield
    ld a,ITEM_SHIELD
    call playerHasItem
    jr z,playerCollisionWithEnemies_loop_shieldable_enemy_idle_no_shield

    ; 2) check the direction in which we need to deflect, and switch to shield state    
    ld a,(player_x)
    ld b,a
    ld a,(player_x+1)
    cp 4
    jp m,playerCollisionWithEnemies_loop_shieldable_enemy_idle_no_x_correction        
    inc b
playerCollisionWithEnemies_loop_shieldable_enemy_idle_no_x_correction:
    ld c,(iy+6)
    ld a,(iy+7)
    cp 4
    jp m,playerCollisionWithEnemies_loop_shieldable_enemy_idle_no_x_correction2
    inc c
playerCollisionWithEnemies_loop_shieldable_enemy_idle_no_x_correction2:
    ld a,b
    cp c
    jp p,playerCollisionWithEnemies_loop_shieldable_enemy_idle_shield_left

    call playerStateChange_shieldRight
    ld a,(iy)
    cp ENEMY_PINECONE
    jr z,playerCollisionWithEnemies_loop_shieldable_enemy_idle_shield_up
    cp ENEMY_BULLET_LASERV
    jr z,playerCollisionWithEnemies_loop_shieldable_enemy_idle_shield_up
playerCollisionWithEnemies_loop_shieldable_enemy_idle_done:
    pop de
    pop hl
    pop af
    ld a,(player_state)
    and #fe                 ; we set 'a' to the value expected later on 
    ret
playerCollisionWithEnemies_loop_shieldable_enemy_idle_shield_up:
    ld a,3
    ld (player_directional_weapon_direction),a
    ld de,player_sprites+23*64  ; up, facing right
    call loadFirstPlayerSpriteToVDP
    jr playerCollisionWithEnemies_loop_shieldable_enemy_idle_done

playerCollisionWithEnemies_loop_shieldable_enemy_idle_shield_left:
    call playerStateChange_shieldLeft
    ld a,(iy)
    cp ENEMY_PINECONE
    jr z,playerCollisionWithEnemies_loop_shieldable_enemy_idle_shield_up
    cp ENEMY_BULLET_LASERV
    jr z,playerCollisionWithEnemies_loop_shieldable_enemy_idle_shield_up
    jr playerCollisionWithEnemies_loop_shieldable_enemy_idle_done

playerCollisionWithEnemies_loop_shieldable_enemy_idle_no_shield:
    pop de
    pop hl
    pop af
    ret
