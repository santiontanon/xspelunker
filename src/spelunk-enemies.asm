;-----------------------------------------------
; Updates enemies and adds all the enemy sprites to the sprite attributes table
updateEnemies:
    xor a
    ld (next_enemy_sprite_slot),a
    ld hl,sprite_attributes+FIRST_ENEMY_SPRITE_SLOT*4
    ld (next_enemy_sprite_slot_ptr),hl
    ld a,(map_n_enemies)
    or a
    jr z,updateEnemies_loop_done
    ld b,a
    ld ix,map_enemies
    ld de,ENEMY_STRUCT_SIZE
updateEnemies_loop:
    exx
    ld a,(ix)
    or a
    call nz,updateEnemy  ; only update actual enemies
    exx
    add ix,de
    djnz updateEnemies_loop

updateEnemies_loop_done:
    ; clear the rest of the sprites (only up to the number of sprites used last frame):
    ld a,(n_enemy_sprites_last_frame)
    ld e,a
    ld a,(next_enemy_sprite_slot)
    cp e
    jp p,updateEnemies_update_n_sprites
    ld hl,(next_enemy_sprite_slot_ptr)
    ld bc,4
    ld d,200
updateEnemies_loop2:
    ld (hl),d
    add hl,bc
    inc a
    cp e
    jp m,updateEnemies_loop2

updateEnemies_update_n_sprites:
    ld a,(next_enemy_sprite_slot)
    ld (n_enemy_sprites_last_frame),a

    ret


;-----------------------------------------------
; Adds the sprites corresponding to the enemy pointed to by "hl"
updateEnemy:
    ; if player is not near, do not update enemies:
    ld a,(player_y)
    ld b,(ix+4)
    sub b
    cp 20
    ret p
    cp -20
    ret m
    ld a,(player_x)
    ld c,(ix+6)
    sub c
    cp 28
    ret p
    cp -28
    ret m

    ; player is closeby, so update them:
    ld a,(ix)
    dec a
    jp z,updateEnemy_pinecone
    dec a
    jp z,updateEnemy_monkey
    dec a
    jp z,updateEnemy_piranha
    dec a
    jp z,updateEnemy_scorpion
    dec a
    jp z,updateEnemy_bee_nest
    dec a
    jp z,updateEnemy_bee
    dec a
    jp z,updateEnemy_explosion
    dec a
    jp z,updateEnemy_bullet
    dec a
    jp z,updateEnemy_snake
    dec a
    jp z,updateEnemy_maya
    dec a
    jp z,updateEnemy_alien
    dec a
    jp z,updateEnemy_sentinel
    jp updateEnemy_bullet


;-----------------------------------------------
; Update cycle for Pinecones
updateEnemy_pinecone:    
    ; 1) update the enemy:
    ld a,(ix+2)
    or a
    jr nz,updateEnemy_pinecone_dropping

    ld a,(player_y)
    sub b
    cp 8
    jp p,updateEnemy_pinecone_player_not_near
    cp -1
    jp m,updateEnemy_pinecone_player_not_near

    ld a,(player_x)
    sub c
    cp 2
    jp p,updateEnemy_pinecone_player_not_near
    cp -2
    jp m,updateEnemy_pinecone_player_not_near

    ; drop!!!
    ld (ix+2),1 ; mark the state as dropping!

updateEnemy_pinecone_dropping:
    push bc
    ld bc,#0200
    call moveSprite
    pop bc
    call getMapCell
    cp TILE_PLATFORM_START
    jp c,updateEnemy_pinecone_player_not_near

    ; pine cone reached the floor, kill it:
    ld (ix),0
    ret

updateEnemy_pinecone_player_not_near:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_PINECONE
    ld iyl,COLOR_RED
    jp enemyDrawSingleSpriteEnemy


;-----------------------------------------------
; Update cycle for Monkeys
updateEnemy_monkey:
    ; 1) update the enemy:
    inc b ; what we are interested is on the bottom tiles of the monkey

    ; move up/down
    ld a,(ix+3)
    and #01
    jp z,updateEnemy_monkey_done_with_movement     ; move only once every two frames

    ld a,(ix+2)
    and #01
    jp nz,updateEnemy_monkey_left
updateEnemy_monkey_right:
    inc c   ; if we are looking to the right, then we want the bottom-right tile
    push bc    
    call getMapCell
    pop bc
    jp nz,enemyHit   ; if we are out of bounds, die!
    call updateEnemy_monkey_is_tree_left
    jp nz,enemyHit  ; if we are not on a tree, die!

    ld a,(player_x)
    dec c
    sub c
    cp -2
    jp m,updateEnemy_monkey_right_turn_left

    ld a,(ix+2)
    cp 4    ; firing
    jp z,updateEnemy_monkey_done_with_movement   ; if it's fire time, just skip

    cp 2    ; going down
    jp z,updateEnemy_monkey_right_go_down
updateEnemy_monkey_right_go_up:
    ld a,(map_width)
    ld b,0
    ld c,a
    xor a
    sbc hl,bc
    ld a,(hl)
    call updateEnemy_monkey_is_tree_left
    jp nz,updateEnemy_monkey_done_with_movement
    ld bc,#ff00
    call moveSprite
    jp updateEnemy_monkey_done_with_movement

updateEnemy_monkey_right_go_down:
    ld a,(map_width)
    ld b,0
    ld c,a
    add hl,bc
    ld a,(hl)
    call updateEnemy_monkey_is_tree_left
    jp nz,updateEnemy_monkey_done_with_movement
    ld bc,#0100
    call moveSprite
    jp updateEnemy_monkey_done_with_movement

updateEnemy_monkey_left:
    push bc
    call getMapCell
    pop bc
    jp nz,enemyHit   ; if we are out of bounds, die!
    call updateEnemy_monkey_is_tree_right
    jp nz,enemyHit  ; if we are not on a tree, die!

    ld a,(player_x)
    sub c
    cp 2
    jp p,updateEnemy_monkey_left_turn_right

    ; move up/down
    ld a,(ix+2)
    cp 5    ; firing
    jp z,updateEnemy_monkey_done_with_movement   ; if it's fire time, just skip

    cp 3    ; going down
    jp z,updateEnemy_monkey_left_go_down
updateEnemy_monkey_left_go_up:
    ld a,(map_width)
    ld b,0
    ld c,a
    xor a
    sbc hl,bc
    ld a,(hl)
    call updateEnemy_monkey_is_tree_right
    jp nz,updateEnemy_monkey_done_with_movement
    ld bc,#ff00
    call moveSprite
    jp updateEnemy_monkey_done_with_movement

updateEnemy_monkey_left_go_down:
    ld a,(map_width)
    ld b,0
    ld c,a
    add hl,bc
    ld a,(hl)
    call updateEnemy_monkey_is_tree_right
    jp nz,updateEnemy_monkey_done_with_movement
    ld bc,#0100
    call moveSprite
    jp updateEnemy_monkey_done_with_movement

updateEnemy_monkey_change_state:
    ld a,(ix+2)
    and #04
    jp z,updateEnemy_monkey_change_state_continue
    call random
    and #01
    call z,updateEnemy_monkey_maya_fire_bullet
updateEnemy_monkey_change_state_continue:
    ld a,(ix+2)
    add a,#02
    cp 6
    jp m,updateEnemy_monkey_change_state_no_overflow
    sub 6
updateEnemy_monkey_change_state_no_overflow:
    ld (ix+2),a
    call random
    and #03f
    ld (ix+3),a
    jp updateEnemy_monkey_choose_sprites

updateEnemy_monkey_done_with_movement:
    ld a,(ix+3)
    or a
    jp z,updateEnemy_monkey_change_state
    dec (ix+3)

updateEnemy_monkey_choose_sprites:
    ; 2) draw the sprites:
    ld a,(ix+2) ; state (to see if the monkey is left or right)
    bit 0,a
    jp nz,updateEnemy_monkey_choose_sprites_left
updateEnemy_monkey_choose_sprites_right:
    cp 4
    jp z,updateEnemy_monkey_choose_sprites_right_fire
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MONKEY+3*64
    jp updateEnemy_monkey_choose_sprites_animation
updateEnemy_monkey_choose_sprites_right_fire:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MONKEY+5*64
    jp updateEnemy_monkey_draw_sprites
updateEnemy_monkey_choose_sprites_left:
    cp 5
    jp z,updateEnemy_monkey_choose_sprites_left_fire
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MONKEY
    jp updateEnemy_monkey_choose_sprites_animation
updateEnemy_monkey_choose_sprites_left_fire:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MONKEY+2*64
    jp updateEnemy_monkey_draw_sprites
updateEnemy_monkey_choose_sprites_animation:
    ld a,(ix+3)
    and #08
    jp z,updateEnemy_monkey_draw_sprites
    push bc
    ex de,hl
    ld bc,64
    add hl,bc
    ex de,hl
    pop bc
updateEnemy_monkey_draw_sprites:
    ld iyl,COLOR_DARK_BLUE
    ld iyh,COLOR_YELLOW
    jp enemyDrawDoubleSpriteEnemy


updateEnemy_monkey_is_tree_left:
    cp 12
    ret z
    cp 16
    ret z
    cp 22
    ret

updateEnemy_monkey_is_tree_right:
    cp 13
    ret z
    cp 23
    ret z
    cp 24
    ret

updateEnemy_monkey_right_turn_left:
    ld (ix+2),1
    inc (ix+6)
    inc (ix+6)
    jp updateEnemy_monkey_choose_sprites

updateEnemy_monkey_left_turn_right:
    ld (ix+2),0
    dec (ix+6)
    dec (ix+6)
    jp updateEnemy_monkey_choose_sprites

updateEnemy_monkey_maya_fire_bullet:
    ; fire a bullet:
    call spawnNewEnemy
    ret z   ;; if no more enemy spots exist
    ld (iy),ENEMY_BULLET
    ld (iy+1),0
    ; for speed x, and y we just set the differences in x,y between the monkey and the player
    ld a,(player_y)
    sub (ix+4)
    ld (iy+2),a
    ld b,a
    ld a,(player_x)
    sub (ix+6)
    ld (iy+3),a
    or b
    jp z,updateEnemy_monkey_fire_bullet_zero_speed
    ld a,(ix+4)
    ld (iy+4),a
    ld a,(ix+5)
    ld (iy+5),a
    ld a,(ix+6)
    ld (iy+6),a
    ld a,(ix+7)
    ld (iy+7),a
    ret
updateEnemy_monkey_fire_bullet_zero_speed:
    ld (iy),0
    ret


;-----------------------------------------------
; Update cycle for Piranhas
updateEnemy_piranha:
    ; 1) update the enemy:
    inc (ix+2)
    ld a,(ix+2)
    cp 128+64
    jp z,updateEnemy_piranha_reset
    cp 128+42
    jp nc,updateEnemy_piranha_going_down
    cp 128+36
    jp nc,updateEnemy_piranha_going_down_slow
    cp 128+32
    jp nc,updateEnemy_piranha_going_down_very_slow
    cp 128+28
    jp nc,updateEnemy_piranha_going_up_very_slow
    cp 128+22
    jp nc,updateEnemy_piranha_going_up_slow
    cp 128
    call z,updateEnemy_piranha_splash
    cp 128
    jp nc,updateEnemy_piranha_going_up

    ; piranha in hiding:
    ret

updateEnemy_piranha_reset:
    ld (ix+2),0

updateEnemy_piranha_splash:
    push af

    ; if Piranhas are far, play softwre effect:
    ld a,(player_y)
    ld b,(ix+4)
    sub b
    jp p,updateEnemy_piranha_splash_positive1
    neg
updateEnemy_piranha_splash_positive1:
    ld b,a
    ld a,(player_x)
    ld c,(ix+6)
    sub c
    jp p,updateEnemy_piranha_splash_positive2
    neg
updateEnemy_piranha_splash_positive2:
    add a,b
    cp 16
    jp m,updateEnemy_piranha_splash_loud

    ld hl,SFX_watersplash_soft
    jr updateEnemy_piranha_splash_after_sfx
updateEnemy_piranha_splash_loud:
    ld hl,SFX_watersplash
updateEnemy_piranha_splash_after_sfx:
    call playSFX

    call spawnNewEnemy
    jp z,updateEnemy_piranha_no_splash   ;; if no more enemy spots exist
    push iy
    pop hl
    ld (hl),ENEMY_EXPLOSION
    inc hl
    ld (hl),1
    inc hl
    ld (hl),0
    inc hl
    ld (hl),1 ; splash sprite
    inc hl
    ld a,(ix+4)
    dec a
    dec a
    ld (hl),a
    inc hl
    ld (hl),0
    inc hl
    ld a,(ix+6)
    ld (hl),a
    inc hl
    ld (hl),0

updateEnemy_piranha_no_splash:
    pop af
    ret

updateEnemy_piranha_going_up:
    ld bc,#fe00
    call moveSprite
    jp updateEnemy_piranha_going_up_very_slow

updateEnemy_piranha_going_up_slow:
    ld bc,#ff00
    call moveSprite
updateEnemy_piranha_going_up_very_slow:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_PIRANHA
    jp updateEnemy_piranha_draw_sprite

updateEnemy_piranha_going_down_slow:
    ld bc,#0100
    call moveSprite
    jp updateEnemy_piranha_going_down_very_slow

updateEnemy_piranha_going_down:
    ld bc,#0200
    call moveSprite
updateEnemy_piranha_going_down_very_slow:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_PIRANHA+32

updateEnemy_piranha_draw_sprite:
    ld iyl,COLOR_PURPLE
    jp enemyDrawSingleSpriteEnemy


;-----------------------------------------------
; Update cycle for Scorpions
updateEnemy_scorpion:
    ; 1) update the enemy:
    inc (ix+2)  ; timer (for animation)

    call getSpriteMapCoordinates_no_increase_in_y   ; we only call the second part of the function, since we don't want correction in y (otherwise, scorpions hover a few pixels over ground)
    inc b
    inc b
    call enemyOverGround
    jr nz,updateEnemy_scorpion_over_ground

    push bc
    ld bc,#0100
    call moveSprite ; fall
    pop bc
    jp updateEnemy_scorpion_choose_sprite

updateEnemy_scorpion_over_ground:
    ld a,(ix+2)
    and #01
    jp nz,updateEnemy_scorpion_choose_sprite ; only move them once every 2 frames

    dec b
    call enemyLeftAndRightMovement

updateEnemy_scorpion_choose_sprite:
    ld a,(ix+3) ; state (left/right)
    and #01
    jp nz,updateEnemy_scorpion_left_sprite
updateEnemy_scorpion_right_sprite:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_scorpion_right_frame1
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SCORPION+32*3
    jp updateEnemy_scorpion_draw
updateEnemy_scorpion_right_frame1:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SCORPION+32*2
    jp updateEnemy_scorpion_draw
updateEnemy_scorpion_left_sprite:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_scorpion_left_frame1
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SCORPION+32
    jp updateEnemy_scorpion_draw
updateEnemy_scorpion_left_frame1:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SCORPION
    jp updateEnemy_scorpion_draw

updateEnemy_scorpion_draw:
    ld iyl,COLOR_BLUE
    jp enemyDrawSingleSpriteEnemy


;-----------------------------------------------
; Update cycle for Bee nests
updateEnemy_bee_nest:
    ; 1) update the enemy:
    inc (ix+2)
    jp nz,updateEnemy_bee_nest_player_not_near  ; every few seconds spawn a new bee

    ld a,(player_y)
    sub b
    cp 10
    jp p,updateEnemy_bee_nest_player_not_near
    cp -10
    jp m,updateEnemy_bee_nest_player_not_near

    ld a,(player_x)
    sub c
    cp 12
    jp p,updateEnemy_bee_nest_player_not_near
    cp -12
    jp m,updateEnemy_bee_nest_player_not_near

    ; spawn a bee!!
    call spawnNewEnemy
    jp z,updateEnemy_bee_nest_player_not_near   ;; if no more enemy spots exist
    ld (iy),ENEMY_BEE
    ld (iy+1),1
    ld (iy+2),2
    ld a,(ix+4)
    ld (iy+4),a
    ld (iy+5),0
    ld a,(ix+6)
    ld (iy+6),a
    ld (iy+7),0

updateEnemy_bee_nest_player_not_near:
    ld iyl,COLOR_DARK_YELLOW
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_BEE_NEST
    jp enemyDrawSingleSpriteEnemy


;-----------------------------------------------
; Update cycle for Bees
updateEnemy_bee:
    ; 1) update the enemy:
    inc (ix+2)
    ld a,(ix+2)
    and #01
    jp z,updateEnemy_bee_draw

    ld a,(player_y)
    cp b
    jp m,updateEnemy_bee_move_up
    dec a
    cp b
    jp p,updateEnemy_bee_move_down
    jp updateEnemy_bee_x

updateEnemy_bee_move_up:
    ld bc,#ff00
    call moveSprite
    jp updateEnemy_bee_x

updateEnemy_bee_move_down:
    ld bc,#0100
    call moveSprite

updateEnemy_bee_x:
    ld a,(player_x)
    ld c,(ix+6)
    cp c
    jp m,updateEnemy_bee_move_left
    dec a
    cp c
    jp p,updateEnemy_bee_move_right
    jp updateEnemy_bee_draw

updateEnemy_bee_move_left:
    ld bc,#00ff
    call moveSprite
    jp updateEnemy_bee_draw

updateEnemy_bee_move_right:
    ld bc,#0001
    call moveSprite

updateEnemy_bee_draw:
    ld a,(player_x)
    ld b,(ix+6)
    cp b
    jp m,updateEnemy_bee_draw_left

    ; 2) draw the sprites:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_bee_draw_sprite2
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_BEE+32*2
    jp updateEnemy_bee_draw_sprite
updateEnemy_bee_draw_sprite2:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_BEE+32*3
    jp updateEnemy_bee_draw_sprite

updateEnemy_bee_draw_left:
    ; 2) draw the sprites:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_bee_draw_sprite2_left
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_BEE
    jp updateEnemy_bee_draw_sprite
updateEnemy_bee_draw_sprite2_left:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_BEE+32

updateEnemy_bee_draw_sprite:
    ld iyl,COLOR_DARK_YELLOW
    jp enemyDrawSingleSpriteEnemy


;-----------------------------------------------
; Update cycle for Enemy Explosions
updateEnemy_explosion:
    ; 1) update the enemy:
    inc (ix+2)
    ld a,(ix+2)
    cp 24
    jp m,updateEnemy_explosion_continue
    ld (ix),0   ; explosion is done
    ret

updateEnemy_explosion_continue:
    ld a,(ix+3)
    or a
    jp nz,updateEnemy_explosion_splash
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_EXPLOSION
    jp updateEnemy_explosion_after_choosing_sprite
updateEnemy_explosion_splash:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_PIRANHA+2*32
updateEnemy_explosion_after_choosing_sprite:
    ld iyl,COLOR_WHITE
    jp enemyDrawSingleSpriteEnemy


;-----------------------------------------------
; Update cycle for Enemy bullets
; (ix+1) contains the error term for the Bresenham-style movement
; (ix+2) contains the y difference between the bullet starting position and the target destination
; (ix+3) contains the x difference between the bullet starting position and the target destination
updateEnemy_bullet:
    ; 1) update the enemy:
    ld a,(ix+2)
    or a
    jp p,updateEnemy_bullet_no_yspeed_flip
    neg
updateEnemy_bullet_no_yspeed_flip:
    ld b,a
    ld a,(ix+3)
    or a
    jp p,updateEnemy_bullet_no_xspeed_flip
    neg
updateEnemy_bullet_no_xspeed_flip:
    ld c,a
    cp b
    jp c,updateEnemy_bullet_y_is_bigger

    ; Bresenham for when the XDIFF > YDIFF
updateEnemy_bullet_x_is_bigger:
    ld a,(ix+1)
    sub b       ; we subtract y difference from the error term 
    ld (ix+1),a
    ld b,0
    jp p,updateEnemy_bullet_x_is_bigger_no_error_overflow
    ld b,1
    add a,c
    ld (ix+1),a
updateEnemy_bullet_x_is_bigger_no_error_overflow:
    ld c,1
    jp updateEnemy_bullet_choose_quadrant

    ; Bresenham for when the XDIFF < YDIFF
updateEnemy_bullet_y_is_bigger:
    ld a,(ix+1)
    sub c       ; we subtract y difference from the error term 
    ld (ix+1),a
    ld c,0
    jp p,updateEnemy_bullet_y_is_bigger_no_error_overflow
    ld c,1
    add a,b
    ld (ix+1),a
updateEnemy_bullet_y_is_bigger_no_error_overflow:
    ld b,1

updateEnemy_bullet_choose_quadrant:
    ld a,(ix+2)
    or a
    jp p,updateEnemy_bullet_no_yspeed_flip2
    ld a,b
    neg
    ld b,a
updateEnemy_bullet_no_yspeed_flip2:
    ld a,(ix+3)
    or a
    jp p,updateEnemy_bullet_no_xspeed_flip2
    ld a,c
    neg
    ld c,a
updateEnemy_bullet_no_xspeed_flip2:

    ld a,(ix)
    cp ENEMY_BULLET_LASERH
    call z,moveSprite   ; if it's a ENEMY_BULLET_LASERH, move it at twice the speed
    call moveSprite
    call getSpriteMapCoordinates
    call getMapCell
    cp TILE_WALL_START
    jp c,updateEnemy_bullet_continue

    ld (ix),0   ; bullet is gone
    ret

updateEnemy_bullet_continue:
    ld a,(ix)
    cp ENEMY_BULLET
    jp z,updateEnemy_bullet_rock
    cp ENEMY_BULLET_LASERH
    jp z,updateEnemy_bullet_laserh
updateEnemy_bullet_laserv:
    ld iyl,COLOR_WHITE
    ld de,item_sprites+23*32
    jp enemyDrawSingleSpriteEnemy
updateEnemy_bullet_laserh:
    ld iyl,COLOR_WHITE
    ld de,item_sprites+21*32
    jp enemyDrawSingleSpriteEnemy
updateEnemy_bullet_rock:
    ld iyl,COLOR_LIGHT_RED
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_BULLET
    jp enemyDrawSingleSpriteEnemy


;-----------------------------------------------
; Update cycle for Snakes
updateEnemy_snake:
    ; 1) update the enemy:
    inc (ix+2)  ; timer (for animation)

    call getSpriteMapCoordinates_no_increase_in_y   ; we only call the second part of the function, since we don't want correction in y (otherwise, snakes hover a few pixels over ground)
    inc b
    inc b
    call enemyOverGround
    jp nz,updateEnemy_snake_over_ground

    push bc
    ld bc,#0100
    call moveSprite ; fall
    pop bc
    jp updateEnemy_snake_choose_sprite

updateEnemy_snake_over_ground:
    push bc
    ld a,(player_y)
    ld b,(ix+4)
    sub b
    cp 6
    jp p,updateEnemy_snake_over_ground_slow
    cp -6
    jp m,updateEnemy_snake_over_ground_slow
    ld a,(player_x)
    ld c,(ix+6)
    sub c
    cp 8
    jp p,updateEnemy_snake_over_ground_slow
    cp -8
    jp m,updateEnemy_snake_over_ground_slow
    pop bc
    jp updateEnemy_snake_over_ground_fast

updateEnemy_snake_over_ground_slow:
    pop bc
    ld a,(ix+2)
    and #03
    jp nz,updateEnemy_snake_choose_sprite ; only move them once every 4 frames

updateEnemy_snake_over_ground_fast:
    dec b
    call enemyLeftAndRightMovement

updateEnemy_snake_choose_sprite:
    ld a,(ix+3) ; state (left/right)
    and #01
    jp nz,updateEnemy_snake_left_sprite
updateEnemy_snake_right_sprite:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_snake_right_frame1
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SNAKE+32*3
    jp updateEnemy_snake_draw
updateEnemy_snake_right_frame1:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SNAKE+32*2
    jp updateEnemy_snake_draw
updateEnemy_snake_left_sprite:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_snake_left_frame1
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SNAKE+32
    jp updateEnemy_snake_draw
updateEnemy_snake_left_frame1:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SNAKE
    jp updateEnemy_snake_draw

updateEnemy_snake_draw:
    ld iyl,COLOR_DARK_GREEN
    jp enemyDrawSingleSpriteEnemy


;-----------------------------------------------
; Update cycle for Mayas
updateEnemy_maya:
    ; 1) update the enemy:
    inc (ix+2)  ; timer (for animation)

    ld a,(ix+3)
    cp 4
    jp p,updateEnemy_maya_firing_bullet

    call getSpriteMapCoordinates_no_increase_in_y   ; we only call the second part of the function, since we don't want correction in y (otherwise, mayas hover a few pixels over ground)
    inc b
    inc b
    call enemyOverGround
    jr nz,updateEnemy_maya_over_ground

    push bc
    ld bc,#0100
    call moveSprite ; fall
    pop bc
    jp updateEnemy_maya_choose_sprite

updateEnemy_maya_over_ground:

    push bc
    ld a,(player_y)
    ld b,(ix+4)
    sub b
    cp 10
    jp p,updateEnemy_maya_over_ground_noplayer
    cp -10
    jp m,updateEnemy_maya_over_ground_noplayer
    ld a,(player_x)
    ld c,(ix+6)
    sub c
    cp 14
    jp p,updateEnemy_maya_over_ground_noplayer
    cp -14
    jp m,updateEnemy_maya_over_ground_noplayer

updateEnemy_maya_over_ground_player_spotted:
    ld a,(ix+2)
    or a
    jp nz,updateEnemy_maya_over_ground_noplayer
    ld a,(player_x)
    ld c,(ix+6)
    sub c
    jp m,updateEnemy_maya_over_ground_player_spotted_left
updateEnemy_maya_over_ground_player_spotted_right:
    ld (ix+3),4
    jr updateEnemy_maya_over_ground_player_spotted_continue
updateEnemy_maya_over_ground_player_spotted_left:
    ld (ix+3),5
updateEnemy_maya_over_ground_player_spotted_continue:
    ; switch to the "firing bullet state"
    ld (ix+2),256-64    ; timer
    pop bc
    jp updateEnemy_maya_firing_bullet

updateEnemy_maya_over_ground_noplayer:
    pop bc

    ld a,(ix+2)
    and #01
    jp nz,updateEnemy_maya_choose_sprite ; only move them once every 2 frames

    dec b
    call enemyLeftAndRightMovement

updateEnemy_maya_choose_sprite:
    ld a,(ix+3) ; state (left/right)
    and #01
    jp nz,updateEnemy_maya_left_sprite
updateEnemy_maya_right_sprite:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_maya_right_frame1
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MAYA+64*4
    jp updateEnemy_maya_draw
updateEnemy_maya_right_frame1:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MAYA+64*3
    jp updateEnemy_maya_draw
updateEnemy_maya_left_sprite:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_maya_left_frame1
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MAYA+64
    jp updateEnemy_maya_draw
updateEnemy_maya_left_frame1:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MAYA
    jp updateEnemy_maya_draw

updateEnemy_maya_choose_sprite_bullet:
    ld a,(ix+3)
    and #01
    jp z,updateEnemy_maya_choose_sprite_bullet_right
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MAYA+64*2
    jp updateEnemy_maya_draw
updateEnemy_maya_choose_sprite_bullet_right:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_MAYA+64*5

updateEnemy_maya_draw:
    ld iyl,COLOR_BLUE
    ld iyh,COLOR_DARK_YELLOW
    jp enemyDrawDoubleSpriteEnemy

updateEnemy_maya_firing_bullet:
    ld a,(ix+2)
    or a
    jp nz,updateEnemy_maya_choose_sprite_bullet
    call updateEnemy_monkey_maya_fire_bullet
    ld a,(ix+3)
    sub 4
    ld (ix+3),a
    ld (ix+2),1
    jp updateEnemy_maya_choose_sprite


;-----------------------------------------------
; Update cycle for Aliens
updateEnemy_alien:
    ; 1) update the enemy:
    inc (ix+2)  ; timer (for animation)

    ld a,(ix+3)
    cp 4
    jp p,updateEnemy_alien_firing_bullet

    call getSpriteMapCoordinates_no_increase_in_y   ; we only call the second part of the function, since we don't want correction in y (otherwise, aliens hover a few pixels over ground)
    inc b
    inc b
    call enemyOverGround
    jr nz,updateEnemy_alien_over_ground

    push bc
    ld bc,#0100
    call moveSprite ; fall
    pop bc
    jp updateEnemy_alien_choose_sprite

updateEnemy_alien_over_ground:

    push bc
    ld a,(player_y)
    ld b,(ix+4)
    sub b
    cp 2
    jp p,updateEnemy_alien_over_ground_noplayer
    cp -2
    jp m,updateEnemy_alien_over_ground_noplayer
    ld a,(player_x)
    ld c,(ix+6)
    sub c
    cp 10
    jp p,updateEnemy_alien_over_ground_noplayer
    cp -10
    jp m,updateEnemy_alien_over_ground_noplayer

updateEnemy_alien_over_ground_player_spotted:
    ld a,(ix+2)
    or a
    jp nz,updateEnemy_alien_over_ground_noplayer
    ld a,(player_x)
    ld c,(ix+6)
    sub c
    jp m,updateEnemy_alien_over_ground_player_spotted_left
updateEnemy_alien_over_ground_player_spotted_right:
    ld (ix+3),4
    jr updateEnemy_alien_over_ground_player_spotted_continue
updateEnemy_alien_over_ground_player_spotted_left:
    ld (ix+3),5
updateEnemy_alien_over_ground_player_spotted_continue:
    ; switch to the "firing bullet state"
    ld (ix+2),256-64    ; timer
    pop bc
    jp updateEnemy_alien_firing_bullet

updateEnemy_alien_over_ground_noplayer:
    pop bc

    ld a,(ix+2)
    and #01
    jp nz,updateEnemy_alien_choose_sprite ; only move them once every 2 frames

    dec b
    call enemyLeftAndRightMovement

updateEnemy_alien_choose_sprite:
    ld a,(ix+3) ; state (left/right)
    and #01
    jp nz,updateEnemy_alien_left_sprite
updateEnemy_alien_right_sprite:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_alien_right_frame1
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_ALIEN+64*4
    jp updateEnemy_alien_draw
updateEnemy_alien_right_frame1:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_ALIEN+64*3
    jp updateEnemy_alien_draw
updateEnemy_alien_left_sprite:
    ld a,(ix+2)
    and #08
    jp z,updateEnemy_alien_left_frame1
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_ALIEN+64
    jp updateEnemy_alien_draw
updateEnemy_alien_left_frame1:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_ALIEN
    jp updateEnemy_alien_draw

updateEnemy_alien_choose_sprite_bullet:
    ld a,(ix+3)
    and #01
    jp z,updateEnemy_alien_choose_sprite_bullet_right
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_ALIEN+64*2
    jp updateEnemy_alien_draw
updateEnemy_alien_choose_sprite_bullet_right:
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_ALIEN+64*5
;    jp updateEnemy_alien_draw

updateEnemy_alien_draw:
    ld iyl,COLOR_GREEN
    ld iyh,COLOR_PURPLE
    jp enemyDrawDoubleSpriteEnemy

updateEnemy_alien_firing_bullet:
    ld a,(ix+2)
    or a
    jp nz,updateEnemy_alien_choose_sprite_bullet

    ; fire bullet:
    call spawnNewEnemy
    jp z,updateEnemy_alien_firing_bullet_continue   ;; if no more enemy spots exist
    ld (iy),ENEMY_BULLET_LASERH
    ld (iy+1),0
;    ; for speed x, and y we just set the differences in x,y between the monkey and the player
    ld (iy+2),0
    ld a,(player_x)
    sub (ix+6)
    ld (iy+3),a
    jp z,updateEnemy_alien_fire_bullet_zero_speed
    ld a,(ix+4)
    inc a
    ld (iy+4),a
    ld a,(ix+5)
    dec a
    dec a
    ld (iy+5),a
    ld a,(ix+6)
    ld (iy+6),a
    ld a,(ix+7)
    ld (iy+7),a
    ld hl,SFX_fire_phaser
    call playSFX
    jp updateEnemy_alien_firing_bullet_continue
updateEnemy_alien_fire_bullet_zero_speed:
    ld (iy),0
updateEnemy_alien_firing_bullet_continue:
    ld a,(ix+3)
    sub 4
    ld (ix+3),a
    ld (ix+2),1
    jp updateEnemy_alien_choose_sprite


;-----------------------------------------------
; Update cycle for Sentinels
updateEnemy_sentinel:
    ; 1) update the enemy:
    inc (ix+2)  ; timer (for animation)
    ld a,(ix+2)
    and #01
    jp nz,updateEnemy_sentinel_choose_sprite ; only move them once every 2 frames
    call getSpriteMapCoordinates
    call enemyLeftAndRightMovement

    ld a,(ix+2)
    and #3f
    jp nz,updateEnemy_sentinel_choose_sprite    ; only try to fire once every 64 frames
    ld a,(player_y)
    ld b,(ix+4)
    sub b
    cp 10
    jp p,updateEnemy_sentinel_choose_sprite
    or a
    jp m,updateEnemy_sentinel_choose_sprite
    ld a,(player_x)
    ld c,(ix+6)
    sub c
    cp 2
    jp p,updateEnemy_sentinel_choose_sprite
    cp -2
    jp m,updateEnemy_sentinel_choose_sprite
    ; fire bullet:
    call updateEnemy_sentinel_fire_bullet

updateEnemy_sentinel_choose_sprite:
    ld a,(ix+2)
    sra a
    sra a
    and #03
    ld de,enemy_sprites+ENEMYSPRITE_OFFSET_SENTINEL
    add a,a
    add a,a
    add a,a
    add a,a
    add a,a
    ADD_DE_A
    ld iyl,COLOR_LIGHT_BLUE
    jp enemyDrawSingleSpriteEnemy

updateEnemy_sentinel_fire_bullet:
    call spawnNewEnemy
    ret z   ;; if no more enemy spots exist
    ld (iy),ENEMY_BULLET_LASERV
    ld (iy+1),0
    ld (iy+2),1 ; bullet going down
    ld (iy+3),0
    jp z,updateEnemy_sentinel_fire_bullet_zero_speed
    ld a,(ix+4)
    inc a
    ld (iy+4),a
    ld a,(ix+5)
    ld (iy+5),a
    ld a,(ix+6)
    ld (iy+6),a
    ld a,(ix+7)
    add a,4
    cp 8
    jp m,updateEnemy_sentinel_fire_bullet_continue
    inc (iy+6)
    sub 8
updateEnemy_sentinel_fire_bullet_continue:
    ld (iy+7),a
    ld hl,SFX_fire_phaser
    call playSFX
    ret
updateEnemy_sentinel_fire_bullet_zero_speed:
    ld (iy),0
    ret


;-----------------------------------------------
; Reduces the hp of an enemy by 1, and if it reaches 0, it kills it
enemyHit:
    ld a,(ix)
    cp ENEMY_BULLET
    ret z   ; bullets cannot be hit
    cp ENEMY_BULLET_LASERH
    ret z   ; bullets cannot be hit
    cp ENEMY_BULLET_LASERV
    ret z   ; bullets cannot be hit
    ld hl,SFX_hit_enemy
    call playSFX    
    dec (ix+1)
    ret nz
enemyHit_kill:
    ld (ix),ENEMY_EXPLOSION
    ld (ix+2),0 ; timer
    ld (ix+3),0 ; explosion sprite
    ld hl,SFX_enemy_kill
    jp playSFX    

enemyDoubleHit:
    ld a,(ix)
    cp ENEMY_BULLET
    ret z   ; bullets cannot be hit
    cp ENEMY_BULLET_LASERH
    ret z   ; bullets cannot be hit
    cp ENEMY_BULLET_LASERV
    ret z   ; bullets cannot be hit
    ld hl,SFX_hit_enemy
    call playSFX    
    dec (ix+1)
    jr z,enemyHit_kill
    dec (ix+1)
    jr z,enemyHit_kill
    ret
    

;-----------------------------------------------
; Find the next available enemy sprite slot, and returns it in "hl"
; The found slot is loaded witht he sprite pattern pointed to by "de" (if that sprite pattern was already in the VDP cache, it is reused)
findEnemySpriteSlot:
    ld hl,next_enemy_sprite_slot
    ld a,(hl)
    cp ENEMY_SPRITE_SLOTS
    ret z   ; mo more slots!

    ; 1) check to see if the sprite pattern is already in the VDP:
    ld b,0
    ld hl,enemy_sprite_patterns_cache
findEnemySpriteSlot_loop:
    ld a,(hl)
    cp d
    jp nz,findEnemySpriteSlot_next
    inc hl
    ld a,(hl)
    cp e
    jp nz,findEnemySpriteSlot_next2

    ; found the sprite in the VDP!
    ld a,b
    add a,ENEMY_FIRST_SPRITE_PATTERN
    add a,a
    add a,a ; we multiply a by 4 to turn it into what the VDP expects
    jp findEnemySpriteSlot_set_attributes

findEnemySpriteSlot_next:
    inc hl   
findEnemySpriteSlot_next2:
    inc hl
    inc b
    ld a,b
    cp ENEMY_SPRITE_SLOTS
    jp nz,findEnemySpriteSlot_loop

    ; 2) Otherwise, load the sprite pattern to VDP:
findEnemySpriteSlot_pattern_not_found_in_cache:
    ld hl,enemy_sprite_patterns_cache_next
    ld a,(hl)
    ld b,a
    inc a
    and ENEMY_SPRITE_SLOTS-1    ; this assumes ENEMY_SPRITE_SLOTS is a power of 2
    ld (hl),a
    ld a,b
    ld h,0
    ld l,a
    call HLTimes32
    ld bc,SPRTBL2+ENEMY_FIRST_SPRITE_PATTERN*32
    add hl,bc
    push af
    call loadSpriteToVDP    ;   de -> hl
    pop af

    ; store "de" in enemy_sprite_patterns_cache:
    ld hl,enemy_sprite_patterns_cache
    ld b,0
    ld c,a
    add hl,bc
    add hl,bc
    ld (hl),d
    inc hl
    ld (hl),e
    
    ; calculate the reference to be added to the attributes:
    add a,ENEMY_FIRST_SPRITE_PATTERN
    add a,a
    add a,a ; we multiply a by 4 to turn it into what the VDP expects

    ; 3) Set the sprite pattern number in the sprite attributes
findEnemySpriteSlot_set_attributes:
    ld hl,next_enemy_sprite_slot
    inc (hl)
    ld hl,(next_enemy_sprite_slot_ptr)
    push hl
    inc hl
    inc hl
    ; Set the sprite pattern number in the sprite attributes
    ld (hl),a
    inc hl
    inc hl
    ld (next_enemy_sprite_slot_ptr),hl
    pop hl
;    or 1    ; indicate we found a slot (not necessary, since the "inc (hl)" instruction will always result in NZ)
    ret


;-----------------------------------------------
; Checks whether any enemy is colliding with a given rectangular area, specified in "DE" to "HL"
; - If there is collision, NZ is set, and the enemy is returned in "IY"
; - If there is no collision, Z will be true
areaCollisionWithEnemies:
    ld a,(map_n_enemies)
    or a
    ret z
    ld b,a
    ld iy,map_enemies
areaCollisionWithEnemies_loop:
    push bc
    ld a,(iy)
    or a
    jp z,areaCollisionWithEnemies_loop_continue
    cp ENEMY_EXPLOSION
    jp z,areaCollisionWithEnemies_loop_continue
    cp ENEMY_PIRANHA
    jp z,areaCollisionWithEnemies_loop_check_if_hidden_piranha
areaCollisionWithEnemies_loop_before_collision_check:
    call areaCollisionWithEnemy
areaCollisionWithEnemies_loop_continue:
    jp nz,areaCollisionWithEnemies_collision
areaCollisionWithEnemies_loop_continue2:
    ld bc,ENEMY_STRUCT_SIZE
    add iy,bc
    pop bc
    djnz areaCollisionWithEnemies_loop
    xor a
    ret
areaCollisionWithEnemies_collision:
    pop bc
    ret

areaCollisionWithEnemies_loop_check_if_hidden_piranha:
    ld a,(iy+2)
    cp 128
    jp c,areaCollisionWithEnemies_loop_continue2
    jp areaCollisionWithEnemies_loop_before_collision_check


;-----------------------------------------------
; There is a collision if:
;   - enemy.y2 >= area.y1 && enemy.y1 <= area.y2 
;   - enemy.x2 >= area.x1 && enemy.x2 <= area.x1
; Enemy pointed to by IY
; Area specified in "DE" to "HL"
; return:
; - Z no collision
; - NZ collision
areaCollisionWithEnemy:
    ld b,(iy+4)
    ld a,(iy+5)
    cp 4
    jp m,areaCollisionWithEnemy_no_y_correction
    inc b
areaCollisionWithEnemy_no_y_correction:
    ld a,(iy)
    cp ENEMY_PINECONE
    jp z,areaCollisionWithEnemy_shortYCollision
    cp ENEMY_BULLET
    jp z,areaCollisionWithEnemy_shortYCollision
    cp ENEMY_BULLET_LASERH
    jp z,areaCollisionWithEnemy_shortYCollision
    cp ENEMY_BULLET_LASERV
    jp z,areaCollisionWithEnemy_shortYCollision
    inc b
    ld a,b
    cp d
    jp m,areaCollisionWithEnemy_no_collision
    dec a
    dec a
    cp h
    jp p,areaCollisionWithEnemy_no_collision

areaCollisionWithEnemy_x:
    ld b,(iy+6)
    ld a,(iy+7)
    cp 4
    jp m,areaCollisionWithEnemy_no_x_correction
    inc b
areaCollisionWithEnemy_no_x_correction:
    ld a,(iy)
    cp ENEMY_PINECONE
    jp z,areaCollisionWithEnemy_narrowXCollision
    cp ENEMY_BULLET
    jp z,areaCollisionWithEnemy_narrowXCollision
    cp ENEMY_BULLET_LASERH
    jp z,areaCollisionWithEnemy_narrowXCollision
    cp ENEMY_BULLET_LASERV
    jp z,areaCollisionWithEnemy_narrowXCollision
    inc b
    ld a,b
    cp e
    jp m,areaCollisionWithEnemy_no_collision
    dec a
    dec a
    cp l
    jp p,areaCollisionWithEnemy_no_collision
    or 1    ; collision!
    ret

areaCollisionWithEnemy_shortYCollision:
    ld a,b
    cp d
    jp m,areaCollisionWithEnemy_no_collision
    dec a
    cp h
    jp p,areaCollisionWithEnemy_no_collision
    jp areaCollisionWithEnemy_x

areaCollisionWithEnemy_narrowXCollision:
    ld a,b
    cp e
    jp m,areaCollisionWithEnemy_no_collision
    dec a
    cp l
    jp p,areaCollisionWithEnemy_no_collision
    or 1    ; collision!
    ret

areaCollisionWithEnemy_no_collision:
    xor a   ; no collision
    ret


;-----------------------------------------------
; input: b,c, position of the enemy
; output:
;   - z: if enemy is not over ground
;   - nz: if enemy is over ground
enemyOverGround:
    push bc
    call getMapCell
    pop bc
    jp nz,updateEnemy_snake_secondGetMapCell
    cp TILE_PLATFORM_START
    jp nc,enemyOverGround_overGround
    inc hl
    ld a,(hl)
updateEnemy_snake_secondGetMapCell:
    cp TILE_PLATFORM_START
    jp nc,enemyOverGround_overGround
    xor a
    ret
enemyOverGround_overGround:
    or 1
    ret


;-----------------------------------------------
; behavior for enemies (like scorpions, nakes or mayas) that move left and right
enemyLeftAndRightMovement:
    ld a,(ix+3) ; state (right/left/pauseright/pauseleft)
    or a
    jp z,enemyLeftAndRightMovement_right
    dec a
    jp z,enemyLeftAndRightMovement_left
    dec a
    jp z,enemyLeftAndRightMovement_pause_right

enemyLeftAndRightMovement_pause_left:
    ld a,(ix+2)
    or a
    ret nz
    ld (ix+3),0
    ret

enemyLeftAndRightMovement_right:
    inc c
    inc c
    call getMapCell
    cp TILE_WALL_START
    jp nc,enemyLeftAndRightMovement_right_change_to_left

    ld a,(ix)
    cp ENEMY_SENTINEL
    jp z,enemyLeftAndRightMovement_right_move     ; sentinels float, so, no need to check if we are over a platform
    ld a,(map_width)
    ld b,0
    ld c,a
    add hl,bc
    ld a,(hl)
    cp TILE_WALL_START
    jp c,enemyLeftAndRightMovement_right_change_to_left
enemyLeftAndRightMovement_right_move:
    ld bc,#0001
    jp moveSprite
    ;ret
enemyLeftAndRightMovement_right_change_to_left:
    ld (ix+2),256-32
    ld (ix+3),2 ; pause right
    ret

enemyLeftAndRightMovement_left:
    dec c
    call getMapCell
    cp TILE_WALL_START
    jp nc,enemyLeftAndRightMovement_right_change_to_right
    ld a,(ix)
    cp ENEMY_SENTINEL
    jp z,enemyLeftAndRightMovement_left_move     ; sentinels float, so, no need to check if we are over a platform
    ld a,(map_width)
    ld b,0
    ld c,a
    add hl,bc
    ld a,(hl)
    cp TILE_WALL_START
    jp c,enemyLeftAndRightMovement_right_change_to_right
enemyLeftAndRightMovement_left_move:
    ld bc,#00ff
    jp moveSprite
    ;ret
enemyLeftAndRightMovement_right_change_to_right:
    ld (ix+2),256-32
    ld (ix+3),3 ; pause left
    ret

enemyLeftAndRightMovement_pause_right:
    ld a,(ix+2)
    or a
    ret nz
    ld (ix+3),1
    ret


;-----------------------------------------------
; Finds a sprite slot for an enemy sprite, and sets its coordiantes
; input:
; - ix: pointer to the enemy
; - iyl: color of the sprite
; - de: the sprite patter to use
enemyDrawSingleSpriteEnemy:
    ; 2) draw the sprites:
    ; 2.1) Calculate the coordinates of the sprite:
    call calculateSpriteScreenCoordinates
    ret z

    ; 2.2) If it's inside of the screen, find a sprite slot:
    push bc
    call findEnemySpriteSlot
    pop bc
    ret z   ; if we found no slot, return

    ; 2.3) set the sprite attributes:
    ld (hl),b
    inc hl
    ld (hl),c
    inc hl
    ; the sprite is already set by findEnemySpriteSlot
    inc hl
    ld a,iyl
    ld (hl),a
    ret


;-----------------------------------------------
; Finds a sprite slot for both enemy sprite, and sets their coordiantes
; input:
; - ix: pointer to the enemy
; - iyl, iyh: color of the two sprites
; - de: the first sprite pattern to use (the second will be de+32)
enemyDrawDoubleSpriteEnemy:
    call calculateSpriteScreenCoordinates
    ret z

    push bc
    push de
    call findEnemySpriteSlot
    pop de
    pop bc
    ret z   ; if we found no slot, return

    ld (hl),b
    inc hl
    ld (hl),c
    inc hl
    inc hl ; the sprite is already set by findEnemySpriteSlot
    ld a,iyl
    ld (hl),a

    push bc
    ex de,hl
    ld bc,32
    add hl,bc
    ex de,hl
    call findEnemySpriteSlot
    pop bc
    ret z   ; if we found no slot, return

    ld (hl),b
    inc hl
    ld (hl),c
    inc hl
    inc hl ; the sprite is already set by findEnemySpriteSlot
    ld a,iyh
    ld (hl),a
    ret


;-----------------------------------------------
; Finds an empty spot to spawn a new enemy
; if one is found, NZ is true, and the enemy slot is returned in "IY"
spawnNewEnemy:
    ld iy,map_enemies
    ld a,(map_n_enemies)
    or a
    jp z,spawnNewEnemy_newSlot_at_the_end
    ld b,a
spawnNewEnemy_loop:
    push bc
    ld a,(iy)
    or a
    jp z,spawnNewEnemy_foundSlot_pop
    ld bc,ENEMY_STRUCT_SIZE
    add iy,bc
    pop bc
    djnz spawnNewEnemy_loop
    ld a,(map_n_enemies)
    cp MAX_MAP_ENEMIES
    jp m,spawnNewEnemy_newSlot_at_the_end  ; if there are less enemies than we can support, then we just add a new one:
    xor a
    ret

spawnNewEnemy_newSlot_at_the_end:
    ld hl,map_n_enemies
    inc (hl)
spawnNewEnemy_foundSlot:
    or 1
    ret

spawnNewEnemy_foundSlot_pop:
    pop bc
    or 1
    ret
