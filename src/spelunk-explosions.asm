;-----------------------------------------------
; updates all the explosions currently going on
updateExplosionsBeforeMapRendering:
    ld hl,bomb_explosions
    ld a,(hl)
    or a
    call nz,updateExplosion ; first bomb
    ld hl,bomb_explosions+EXPLOSION_STRUCT_SIZE
    ld a,(hl)
    or a
    ret z                   ; second bomb

updateExplosion:
    inc hl

    push hl
    ; save the background:
    ld a,(hl)
    inc hl
    sub BOMB_EXPLOSION_HEIGHT/2
    ld b,a
    ld a,(hl)
    inc hl
    sub BOMB_EXPLOSION_WIDTH/2
    ld c,a      ; "bc" now has the top-left coordinate of the explosion
    ld iyl,a    ; we save the left coordinate for later
    ex de,hl    ; pointer to the buffer to store the background is now in DE
    push bc
    call getMapCellPointerEvenIfOutOfBounds
    pop bc
    ld ix,BOMB_EXPLOSION_WIDTH + BOMB_EXPLOSION_HEIGHT*256
updateExplosion_loop:
    call checkCoordinatesOutOfBounds
    jp z,updateExplosion_insideOfBounds
updateExplosion_outOfBounds:
    inc de
    inc hl
    jp updateExplosion_continue    
updateExplosion_insideOfBounds:
    ldi
updateExplosion_continue:
    inc c
    dec ixl
    jp nz,updateExplosion_loop
    ld ixl,BOMB_EXPLOSION_WIDTH
    ld c,iyl
    push bc
    ld a,(map_width)
    sub BOMB_EXPLOSION_WIDTH
    ld b,0
    ld c,a
    add hl,bc
    pop bc
    inc b
    dec ixh
    jp nz,updateExplosion_loop
    pop hl

    ; draw the explosion:
    dec hl
    ld a,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld c,(hl)
    dec c
    cp 24
    jp p,updateExplosion_drawSmallExplosion
    cp 8
    jp m,updateExplosion_drawSmallExplosion
    dec b
    jp updateExplosion_drawExplosion


updateExplosion_drawExplosion:
    ld iyh,3
    ld de,largeExplosion_tiles
updateExplosion_drawSmallExplosion_entrypoint:
    push bc
    call getMapCellPointerEvenIfOutOfBounds
    pop bc
updateExplosion_drawExplosion_loopy:
    ld iyl,3
updateExplosion_drawExplosion_loopx:
    call checkCoordinatesOutOfBounds
    jp nz,updateExplosion_drawExplosion2
    ld a,(de)
    ld (hl),a
updateExplosion_drawExplosion2:
    inc de
    dec iyl
    jr z,updateExplosion_drawExplosion_loopx_done
    inc hl
    inc c
    jr updateExplosion_drawExplosion_loopx
updateExplosion_drawExplosion_loopx_done:
    dec iyh
    ret z
    dec c
    dec c
    ld a,(map_width)
    sub 2
    push de
    ld d,0
    ld e,a
    add hl,de
    pop de
    jr updateExplosion_drawExplosion_loopy


updateExplosion_drawSmallExplosion:
    ld iyh,1
    ld de,smallExplosion_tiles
    jr updateExplosion_drawSmallExplosion_entrypoint


updateExplosionsAfterMapRendering:
    ; we iterate the explosions in reverse order, in order to restore the map exactly as it was:
    ld hl,bomb_explosions+EXPLOSION_STRUCT_SIZE
    ld a,(hl)
    or a
    call nz,updateExplosionAfter    ; first explosion
    ld hl,bomb_explosions
    ld a,(hl)
    or a
    ret z                           ; second explosion


updateExplosionAfter:
    xor a
    ld (need_to_redraw_map),a   ; trigger redraw

    dec (hl)
    inc hl

    ; restore the background:
    ld a,(hl)
    inc hl
    sub BOMB_EXPLOSION_HEIGHT/2
    ld b,a
    ld a,(hl)
    inc hl
    sub BOMB_EXPLOSION_WIDTH/2
    ld c,a      ; bc now has the top-left coordinate of the explosion
    ld iyl,a    ; we save the left coordinate for later
    ex de,hl    ; pointer to the buffer where the background is stored is now in DE
    push bc
    call getMapCellPointerEvenIfOutOfBounds
    pop bc
    ld ix,BOMB_EXPLOSION_WIDTH + BOMB_EXPLOSION_HEIGHT*256
updateExplosionAfter_loop:
    call checkCoordinatesOutOfBounds
    jp nz,updateExplosionAfter_outOfBounds
    ld a,(de)
    ld (hl),a
updateExplosionAfter_outOfBounds:
    inc de
    inc hl
updateExplosionAfter_continue:
    inc c
    dec ixl
    jp nz,updateExplosionAfter_loop
    ld ixl,BOMB_EXPLOSION_WIDTH
    ld c,iyl
    push bc
    ld a,(map_width)
    sub BOMB_EXPLOSION_WIDTH
    ld b,0
    ld c,a
    add hl,bc
    pop bc
    inc b
    dec ixh
    jp nz,updateExplosionAfter_loop
    ret


;-----------------------------------------------
; destroys the surrounding tiles of a bomb
bombExplosion:
    ld hl,decompressed_sfx + SFX_explosion
    call playSFX

    call removeAllItems

    ; explosion (clear a BOMB_EXPLOSION_WIDTH * BOMB_EXPLOSION_HEIGHT area)
    ld a,(ix+4)
    sub BOMB_EXPLOSION_HEIGHT/2
    ld b,a
    ld a,(ix+6)
    sub BOMB_EXPLOSION_WIDTH/2
    ld c,a      ; bc now has the top-left coordinate of the explosion
    ld de,BOMB_EXPLOSION_WIDTH + BOMB_EXPLOSION_HEIGHT*256

bombExplosion_loop:
    ; clear the position pointed by bc
    push bc
    call getMapCellPointerCheckingBounds
    jp nz,bombExplosion_loop_outofbounds
    ld a,(hl)
    cp TILE_NON_DESTROYSABLE_WALL_START
    jp nc,bombExplosion_loop_outofbounds
    call isWater
    jp nz,bombExplosion_loop_outofbounds
    xor a
    ld (hl),a

    ; see if there is any animation we need to remove:
    call removeMapAnimation

bombExplosion_loop_outofbounds:
    pop bc

    inc c
    dec e
    jp nz,bombExplosion_loop
    ld e,BOMB_EXPLOSION_WIDTH
    ld a,c
    sub BOMB_EXPLOSION_WIDTH
    ld c,a
    inc b
    dec d
    jp nz,bombExplosion_loop

    call drawAllItems


    ; hit enemies:
    ; calculate the hit rectangle:
    ld a,(ix+4)
    sub BOMB_EXPLOSION_HEIGHT/2
    ld d,a
    add a,BOMB_EXPLOSION_HEIGHT-1
    ld h,a
    ld a,(ix+6)
    sub BOMB_EXPLOSION_WIDTH/2
    ld e,a      ; bc now has the top-left coordinate of the explosion
    add a,BOMB_EXPLOSION_HEIGHT-1
    ld l,a

    ld a,(map_n_enemies)
    or a
    ret z
    ld b,a
    ld iy,map_enemies
bombExplosionHitEnemies_loop:
    push bc
    ld a,(iy)
    or a
    call nz,areaCollisionWithEnemy
    jp nz,bombExplosionHitEnemies_collision
bombExplosionHitEnemies_continue_loop:
    ld bc,ENEMY_STRUCT_SIZE
    add iy,bc
    pop bc
    djnz bombExplosionHitEnemies_loop
    xor a
    ret

bombExplosionHitEnemies_collision:
    push ix
    push iy
    pop ix
    push hl
    call enemyDoubleHit
    pop hl
    pop ix
    jp bombExplosionHitEnemies_continue_loop 


;-----------------------------------------------
; checks if the player is over an explosion
isPlayerOnExplosion:
    ld a,(player_y)
    ld b,a
    ld a,(player_x)
    ld c,a

    ld hl,bomb_explosions
    ld a,(hl)
    or a
    call nz,isCoordinateOnExplosion
    ret nz
    ld hl,bomb_explosions+EXPLOSION_STRUCT_SIZE
    ld a,(hl)
    or a
    jp nz,isCoordinateOnExplosion
    ret

isCoordinateOnExplosion:
    ; check if the explosion hit the player:
    inc hl
    ld a,(hl)   ; y
    sub b
    cp BOMB_EXPLOSION_HEIGHT/2+1
    jp p,isCoordinateOnExplosion_no    
    cp -BOMB_EXPLOSION_HEIGHT/2
    jp m,isCoordinateOnExplosion_no
    inc hl
    ld a,(hl)   ; x
    sub c
    cp BOMB_EXPLOSION_WIDTH/2+1
    jp p,isCoordinateOnExplosion_no
    cp -BOMB_EXPLOSION_WIDTH/2
    jp m,isCoordinateOnExplosion_no
    or 1
    ret

isCoordinateOnExplosion_no:
    xor a
    ret

