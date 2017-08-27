;-----------------------------------------------
; updates the player bullets, renderiing and moving them if necessary
updatePlayerBullets:
    ld b,0  ; mark that we are checking the first sprite
    ld de,sprite_attributes+PLAYER_BULLET_FIRST_SPRITE*4
    ld hl,player_bullets
    ld a,(hl)
    or a
    call nz,updatePlayerBullet
    ld b,1  ; mark that we are checking the second sprite
    ld de,sprite_attributes+(PLAYER_BULLET_FIRST_SPRITE+1)*4
    ld hl,player_bullets+PLAYER_BULLET_STRUCT_SIZE
    ld a,(hl)
    or a
    call nz,updatePlayerBullet
    ret

; this function assumes "hl" points to the bullet, and "de" to the sprite
updatePlayerBullet:
    push hl
    pop ix
    cp ITEM_BOMB
    jp z,updatePlayerBullet_bomb
    cp ITEM_ROPE
    jp z,updatePlayerBullet_rope
    cp ITEM_STONE
    jp z,updatePlayerBullet_stone
    cp ITEM_BOW
    jp z,updatePlayerBullet_arrow
    cp ITEM_ARROW
    jp z,updatePlayerBullet_arrow_by_hand
;    cp ITEM_PHASER
;    jp z,updatePlayerBullet_phaser
;    ret
    jp updatePlayerBullet_phaser

; sprite to change specified in "de":
updatePlayerBullet_change_sprite:
    ld hl,SPRTBL2+PLAYER_BULLET_FIRST_SPRITE_PATTERN*32
    ld a,b
    or a
    jp z,updatePlayerBullet_change_sprite_first_sprite
    ld hl,SPRTBL2+(PLAYER_BULLET_FIRST_SPRITE_PATTERN+1)*32
updatePlayerBullet_change_sprite_first_sprite:
    jp loadSpriteToVDP

updatePlayerBullet_bomb:
    ld a,(ix+1)
    or a
    jp nz,updatePlayerBullet_bomb_handle_physics

    ; load the bomb sprite, and set the initial x,y speed:
    push de
    push hl
    ld de,item_sprites+14*32
    call updatePlayerBullet_change_sprite
    pop hl

    ld hl,thrown_stone_bomb_speed
    ld c,(ix+2)
    ld b,0
    add hl,bc
    add hl,bc
    ld a,(hl)
    ld (ix+2),a
    inc hl
    ld a,(hl)
    ld (ix+3),a
    pop de

updatePlayerBullet_bomb_handle_physics:
    call updatePlayerBullet_parabolic_physics

    ; increase the bomb timer:
    ld a,(ix+1)
    cp BOMB_TIMER
    jp z,updatePlayerBullet_bomb_explosion

    ; set the sprite attributes:
    call calculatePlayerBulletSpriteCoordinates
    ret z   ; if it's out of bounds, we can return

    ld a,(ix+1)
    cp BOMB_TIMER/2
    jp c,updatePlayerBullet_bomb_blue
    and #08
    jp z,updatePlayerBullet_bomb_blue
    ld a,COLOR_RED
    jp updatePlayerBullet_bomb_set_color
updatePlayerBullet_bomb_blue:
    ld a,COLOR_DARK_BLUE
updatePlayerBullet_bomb_set_color:
    ld (de),a    
    ret

updatePlayerBullet_bomb_explosion:
    ld (ix),0
    ld a,200
    ld (de),a   ; move the sprite away

    ; properly reposition the explosion basedon the pixel offset of the bomb:
    ld a,(ix+5)
    cp 4
    jp m,updatePlayerBullet_bomb_explosion_slot_found_no_y_increase
    inc (ix+4)
updatePlayerBullet_bomb_explosion_slot_found_no_y_increase:
    ld a,(ix+7)
    cp 4
    jp m,updatePlayerBullet_bomb_explosion_slot_found_no_x_increase
    inc (ix+6)
updatePlayerBullet_bomb_explosion_slot_found_no_x_increase:

    ; destroy the tiles around the bomb
    call bombExplosion

    ; create an explosion struct:
    ld hl,bomb_explosions
    ld a,(hl)
    or a
    jp z,updatePlayerBullet_bomb_explosion_slot_found
    ld hl,bomb_explosions+EXPLOSION_STRUCT_SIZE
    ld a,(hl)
    or a
    ret nz  ; no explosino slot found! (this should never happen though)
updatePlayerBullet_bomb_explosion_slot_found:
    ld (hl),32   ; set timer (when timer reaches 0, explosion ends)
    inc hl
    ld a,(ix+4)  ; y
    ld (hl),a
    inc hl
    ld a,(ix+6)  ; x
    ld (hl),a
    ret


updatePlayerBullet_rope:
    inc hl
    ld a,(hl)
    or a
    jp nz,updatePlayerBullet_rope_handle_physics

    ; load the rope sprite, and set the initial x,y speed:
    push de
    push hl
    ld de,item_sprites+15*32
    call updatePlayerBullet_change_sprite
    pop hl

    inc hl  ; hl now points to state 2
    ld a,(hl)
    ex de,hl
    ld hl,thrown_rope_speed
    ld c,a
    ld b,0
    add hl,bc
    add hl,bc
    ldi ; x speed
    ldi ; y speed
    pop de

updatePlayerBullet_rope_handle_physics:
    call updatePlayerBullet_parabolic_physics
    cp 2
    jp z,updatePlayerBullet_rope_lands
    cp 1
    jp z,updatePlayerBullet_rope_hooked

    ; set the sprite attributes:
    call calculatePlayerBulletSpriteCoordinates
    ret z

    ld a,11  ; yellow
    ld (de),a    
    ret

updatePlayerBullet_rope_lands:
    ld (ix),0
    ld a,200
    ld (de),a   ; move the sprite away

    ; spawn a new rope item:
    call getSpriteMapCoordinates
    dec b   ; since items are 2x2, we need to raise it 1 tile
    ld a,ITEM_ROPE
    jp spawnItemInMap

updatePlayerBullet_rope_hooked:
    ld (ix),0
    ld a,200
    ld (de),a   ; move the sprite away

    call removeAllItems
    call getSpriteMapCoordinates

    push bc
    call getMapCell
    pop bc
    cp TILE_PLATFORM_START
    jp c,updatePlayerBullet_rope_hooked_no_correction
    inc b
updatePlayerBullet_rope_hooked_no_correction:
    ld d,MAX_ROPE_LENGTH
updatePlayerBullet_rope_hooked_loop:
    push bc
    call getMapCell
    pop bc
    cp TILE_BG_END
    jp nc,updatePlayerBullet_rope_hooked_done
    ld (hl),TILE_ROPE   ; hl points at the right tile in the map

    call removeMapAnimation ; see if the rope goes through any animation

    inc b
    dec d
    jp nz,updatePlayerBullet_rope_hooked_loop

updatePlayerBullet_rope_hooked_done:
    jp drawAllItems


updatePlayerBullet_stone:
    inc hl
    ld a,(hl)
    or a
    jp nz,updatePlayerBullet_stone_handle_physics

    ; load the stone sprite, and set the initial x,y speed:
    push de
    push hl
    ld de,item_sprites+15*32
    call updatePlayerBullet_change_sprite
    pop hl

    inc hl  ; hl now points to state 2
    ld a,(hl)
    ex de,hl
    ld hl,thrown_stone_bomb_speed
    ld c,a
    ld b,0
    add hl,bc
    add hl,bc
    ldi ; x speed
    ldi ; y speed
    pop de

updatePlayerBullet_stone_handle_physics:
    call updatePlayerBullet_parabolic_physics
    cp 2
    jp z,updatePlayerBullet_stone_stopped

    ; set the sprite attributes:
    call calculatePlayerBulletSpriteCoordinates
    ret z

    ld a,14  ; grey
    ld (de),a    

    ; collision with enemies:
    push de
    call bulletCollisionWithEnemies
    pop de
    ret z
    push ix
    push iy
    pop ix
    call enemyHit
    pop ix
    dec de
    dec de
    dec de

updatePlayerBullet_stone_stopped:
    ld (ix),0
    ld a,200
    ld (de),a   ; move the sprite away

    ; spawn a new stone item:
    call getSpriteMapCoordinates
    dec b   ; since items are 2x2, we need to raise it 1 tile
    ld a,ITEM_STONE
    jp spawnItemInMap


updatePlayerBullet_arrow_by_hand:
    inc hl
    ld a,(hl)
    or a
    jp nz,updatePlayerBullet_arrow_handle_physics

    ; set the initial x,y speed:
    push hl
    push de
    push bc
    inc hl  ; hl now points to state 2
    ld a,(hl)
    ex de,hl
    ld hl,thrown_stone_bomb_speed
    jp updatePlayerBullet_arrow_initial_speed_continue

updatePlayerBullet_arrow:
    inc hl
    ld a,(hl)
    or a
    jp nz,updatePlayerBullet_arrow_handle_physics

    push hl
    ld hl,decompressed_sfx + SFX_fire_arrow
    call playSFX
    pop hl

    ; set the initial x,y speed:
    push hl
    push de
    push bc
    inc hl  ; hl now points to state 2
    ld a,(hl)
    ex de,hl
    ld hl,arrow_bullet_speed
updatePlayerBullet_arrow_initial_speed_continue:
    ld c,a
    ld b,0
    add hl,bc
    add hl,bc
    ldi ; x speed
    ldi ; y speed

    pop bc
    pop de
    pop hl

updatePlayerBullet_arrow_handle_physics:
    ; determine the arrow sprite:
    push de
    inc hl
    inc hl
    ld a,(hl)   ; y speed
    or a
    jp z,updatePlayerBullet_arrow_zero_y_speed
    jp m,updatePlayerBullet_arrow_negative_y_speed
updatePlayerBullet_arrow_positive_y_speed
    dec hl
    ld a,(hl)   ; x speed
    or a
    jp z,updatePlayerBullet_arrow_positive_y_speed_zero_x_speed
    jp m,updatePlayerBullet_arrow_positive_y_speed_negative_x_speed
updatePlayerBullet_arrow_positive_y_speed_positive_x_speed
    ld de,item_sprites+22*32
    jp updatePlayerBullet_arrow_set_sprite

updatePlayerBullet_arrow_positive_y_speed_zero_x_speed:
    ld de,item_sprites+23*32
    jp updatePlayerBullet_arrow_set_sprite

updatePlayerBullet_arrow_positive_y_speed_negative_x_speed
    ld de,item_sprites+24*32
    jp updatePlayerBullet_arrow_set_sprite

updatePlayerBullet_arrow_zero_y_speed:
    ld de,item_sprites+21*32
    jp updatePlayerBullet_arrow_set_sprite

updatePlayerBullet_arrow_negative_y_speed:
    dec hl
    ld a,(hl)   ; x speed
    or a
    jp z,updatePlayerBullet_arrow_negative_y_speed_zero_x_speed
    jp m,updatePlayerBullet_arrow_negative_y_speed_negative_x_speed
updatePlayerBullet_arrow_negative_y_speed_positive_x_speed
    ld de,item_sprites+24*32
    jp updatePlayerBullet_arrow_set_sprite

updatePlayerBullet_arrow_negative_y_speed_zero_x_speed:
    ld de,item_sprites+23*32
    jp updatePlayerBullet_arrow_set_sprite

updatePlayerBullet_arrow_negative_y_speed_negative_x_speed
    ld de,item_sprites+22*32
;    jp updatePlayerBullet_arrow_set_sprite

updatePlayerBullet_arrow_set_sprite:
    call updatePlayerBullet_change_sprite
    pop de

    call updatePlayerBullet_parabolic_physics
    cp 2
    jp z,updatePlayerBullet_arrow_stopped

    ; set the sprite attributes:
    call calculatePlayerBulletSpriteCoordinates
    ret z

    ld a,14  ; grey
    ld (de),a  

    ; collision with enemies:
    push de
    call bulletCollisionWithEnemies
    pop de
    ret z
    push ix
    push iy
    pop ix
    call enemyHit
    pop ix
    dec de
    dec de
    dec de

updatePlayerBullet_arrow_stopped:
    ld (ix),0
    ld a,200
    ld (de),a   ; move the sprite away

    ; spawn a new arrow item:
    call getSpriteMapCoordinates
    dec b   ; since items are 2x2, we need to raise it 1 tile
    ld a,ITEM_ARROW
    jp spawnItemInMap


updatePlayerBullet_phaser:
    ld a,(ix+1) ; timer
    or a
    jp nz,updatePlayerBullet_phaser_sprite_loaded
    inc (ix+1)

    ; load the phaser bullet sprite:    
    push de
    ld de,item_sprites+16*32
    ld a,(ix+2)
    ld l,a
    ld h,0
    call HLTimes32
    add hl,de   ; get the proper sprite, based on the state
    ex de,hl
    call updatePlayerBullet_change_sprite

    ld hl,decompressed_sfx + SFX_fire_phaser
    call playSFX

    pop de
updatePlayerBullet_phaser_sprite_loaded:
    ; get the bullet speed:
    push de
    ld a,(ix+2)
    add a,a
    ld c,a
    ld b,0
    ld hl,phaser_bullet_speed
    add hl,bc
    ld c,(hl)
    inc hl
    ld b,(hl)

    ; move the bullet:
    call moveSprite
    pop de

    call getBulletMapCell
    cp TILE_WALL_START
    jp nc,updatePlayerBullet_phaser_collision

    ; set the sprite attributes:
    call calculatePlayerBulletSpriteCoordinates
    ret z

    ld a,15  ; white
    ld (de),a    

    ; collision with enemies:
    push de
    call bulletCollisionWithEnemies
    pop de
    ret z
    push ix
    push iy
    pop ix
    call enemyHit
    pop ix
    dec de
    dec de
    dec de

updatePlayerBullet_phaser_collision:
    ld (ix),0
    ld a,200
    ld (de),a   ; move the sprite away
    ret


;-----------------------------------------------
; Moves a bullet in a parabolic trajectory
; assumes IX points at the bullet
; "A" contains:
; - 0 if there was no collision, 
; - 1 if there was a collision above (for ropes, so, it includes platforms)
; - 2 if the bullet stopped
updatePlayerBullet_parabolic_physics:
    inc (ix+1)
    ld a,(ix+1)
    and #07
    jp nz,updatePlayerBullet_parabolic_physics_no_change_in_y_speed
;    ld (ix+1),1
    inc (ix+3)
updatePlayerBullet_parabolic_physics_no_change_in_y_speed:
    ; first, move the bullet along the x axis:
    ld c,(ix+2)
    ld b,0
    ; save x position
    ld a,(ix+6)
    ld (tmp_position_buffer),a
    ld a,(ix+7)
    ld (tmp_position_buffer+1),a
    call moveSprite
    call getBulletMapCell
;    call isWall
;    jp z,updatePlayerBullet_parabolic_physics_no_x_collision
    cp TILE_WALL_START    
    jp c,updatePlayerBullet_parabolic_physics_no_x_collision

    ; restore x position:
    ld a,(tmp_position_buffer)
    ld (ix+6),a
    ld a,(tmp_position_buffer+1)
    ld (ix+7),a

    ld a,(ix+2)
    or a
    jr z,updatePlayerBullet_parabolic_physics_no_x_collision    ; if there was no x speed, then no need to do any reversing
    ld hl,decompressed_sfx + SFX_bullet_bounce
    call playSFX   

    ; reverse and half x speed:
    ld a,(ix+2)
    or a
    jp p,updatePlayerBullet_parabolic_physics_collision_with_positive_x_speed
    neg
    sra a
    jp updatePlayerBullet_parabolic_physics_reverse_x_speed
updatePlayerBullet_parabolic_physics_collision_with_positive_x_speed:
    sra a
    neg
updatePlayerBullet_parabolic_physics_reverse_x_speed:
    ld (ix+2),a

updatePlayerBullet_parabolic_physics_no_x_collision:
    ld c,0
    ld b,(ix+3)
    ; save y position
    ld a,(ix+4)
    ld (tmp_position_buffer),a
    ld a,(ix+5)
    ld (tmp_position_buffer+1),a    
    call moveSprite
    call getBulletMapCell
    cp TILE_WALL_START
    jp nc,updatePlayerBullet_parabolic_physics_y_collision
    cp TILE_PLATFORM_START
    jp c,updatePlayerBullet_parabolic_physics_no_y_collision
    ld a,(ix+3)
    cp 0    ; platforms are collisions only when going down, but we mark them for ropes:
    jp m,updatePlayerBullet_parabolic_physics_up_collision_with_platform

updatePlayerBullet_parabolic_physics_y_collision:
    ; restore y position:
    ld a,(tmp_position_buffer)
    ld (ix+4),a
    ld a,(tmp_position_buffer+1)
    ld (ix+5),a

    ; reverse and half the y speed:
    ld a,(ix+3)
    or a
    jr z,updatePlayerBullet_parabolic_physics_zero_speed    ; if there was no x speed, then no need to do any reversing
    ld hl,decompressed_sfx + SFX_bullet_bounce
    call nz,playSFX ; only make sound if the bullet is moving a bit faster 

    ld a,(ix+3)
    or a
    jp p,updatePlayerBullet_parabolic_physics_collision_with_positive_y_speed
    neg
    sra a
    ld (ix+3),a
    ld a,1  ; collision from above (a = 1)
    ret
updatePlayerBullet_parabolic_physics_collision_with_positive_y_speed:
    sra a
    neg
updatePlayerBullet_parabolic_physics_reverse_y_speed:
    ld (ix+3),a
    or a
    jp z,updatePlayerBullet_parabolic_physics_zero_speed    

updatePlayerBullet_parabolic_physics_no_y_collision:
    xor a   ; no special collision (a = 0)
    ret
updatePlayerBullet_parabolic_physics_zero_speed:
    ld (ix+2),0 ; we zero the x speed (since the only thing we can ensure here is that y speed is zero)
    ld a,2  ; bullet stopped (a = 0)
    ret
updatePlayerBullet_parabolic_physics_up_collision_with_platform:
    ld a,1
    ret


;-----------------------------------------------
; calculates the coordinates a player bullet sprite
; bullet coordinates pointed by 'hl', and corresponding sprite attributes pointed by 'de'
calculatePlayerBulletSpriteCoordinates:
    call calculateSpriteScreenCoordinates
    ld a,b
    ld (de),a
    inc de
    ld a,c
    ld (de),a
    inc de
    inc de
    ret


;-----------------------------------------------
; gets the contents of the map cell behind the bullet
; "IX" is assumed to point at the bullet
getBulletMapCell:
    ld b,(ix+4)
    ld a,(ix+5)
    cp 4
    jp m,getBulletMapCell_no_increase_in_y
    inc b
getBulletMapCell_no_increase_in_y:
    ld c,(ix+6)
    ld a,(ix+7)
    cp 4
    jp m,getMapCell
    inc c
    jp getMapCell


;-----------------------------------------------
; Checks whether a given player weapon (ix) is colliding with any enemy.
; - If there is collision, NZ is set, and the enemy is returned in "IY"
; - If there is no collision, Z will be true
bulletCollisionWithEnemies:
    ld a,(ix+4)
    ld d,a
    inc a
    ld h,a
    ld a,(ix+5)
    cp 4
    jp m,bulletCollisionWithEnemies_no_y_correction
    inc d
    inc h
bulletCollisionWithEnemies_no_y_correction:
    ld a,(ix+6)
    ld e,a
    inc a
    ld l,a
    ld a,(ix+7)
    cp 4
    jp m,bulletCollisionWithEnemies_no_x_correction
    inc e
    inc l
bulletCollisionWithEnemies_no_x_correction:
;    jp areaCollisionWithEnemies
    call areaCollisionWithEnemies
    ret z
    ld a,(iy)
    cp ENEMY_BULLET
    ret             ; now, if it's not a bullet, NZ will be true (collision), but it if's a bullet, Z will be true (so that player bullets go through enemy bullets)


