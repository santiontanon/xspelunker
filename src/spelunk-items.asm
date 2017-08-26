;-----------------------------------------------
; draws all the items to the "map" buffer
drawAllItems:
    ld a,(map_n_items)
    or a
    ret z
    ld b,a
    ld de,map_items
drawAllItems_loop:
    push bc
    push de
    ld a,(de)
    or a
    call nz,drawItem  ; only draw those that are actually items
    pop de
    ld hl,ITEM_STRUCT_SIZE
    add hl,de
    ex de,hl
    pop bc
    djnz drawAllItems_loop

    xor a
    ld (need_to_redraw_map),a   ; trigger redraw

    ret


;-----------------------------------------------
; removes all the items to the "map" buffer, replacing them with the background they stored
; note: we render from last to first, to ensure it's all restored properly
removeAllItems:
    ld a,(map_n_items)
    or a
    ret z
    ld h,0
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl    ; assuming items are 8 bytes
    ld bc,map_items
    add hl,bc
    xor a
    ld bc,ITEM_STRUCT_SIZE
    sbc hl,bc
    ex de,hl
    ld a,(map_n_items)
    ld b,a
removeAllItems_loop:
    push bc
    push de
    ld a,(de)
    or a
    call nz,removeItem  ; only remove those that are actually items
    pop hl
    ld bc,ITEM_STRUCT_SIZE
    xor a
    sbc hl,bc
    ex de,hl
    pop bc
    djnz removeAllItems_loop
    ret


;-----------------------------------------------
; Renders the item pointed to by "de" to "map".
; To do this, the previous content of "map" is stored in the last 4 bytes of the item structure
; before being overwritten, so that the map can be reconstructed when we remove the item.
drawItem:
    ; 1) store the background
    ; 1.1) get the info from the item struct:
    push de
    inc de
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    inc de
    inc de
    ; 1.2) calculate the position in the map where to render
    ld h,0
    ld l,b  ; hl = y
    ld a,(map_width_log2)
    ld b,a
drawItem_loop:
    add hl,hl
    djnz drawItem_loop
    ld b,0
    add hl,bc
    ld bc,map
    add hl,bc
    push hl
    ; 1.3) store the background
    ldi
    ldi
    ld a,(map_width)
    sub 2
    ADD_HL_A_VIA_BC
    ldi
    ldi
    pop de  ; notice we are swapping hl and de (so, now "de" points at the "map" cell)
    pop hl

    ; 2) draw the item
    ld a,(hl)
    dec a
    jp z,drawItem_bomb
    dec a
    jp z,drawItem_rope
    dec a
    jp z,drawItem_arrow
    dec a
    jp z,drawItem_stone
    dec a
;    jp z,drawItem_machete  ; we will never have a machete in the map
    dec a
    jp z,drawItem_shield
    dec a
    jp z,drawItem_bow
    dec a
    jp z,drawItem_boots
    dec a
    jp z,drawItem_belt
    dec a
    jp z,drawItem_scubamask
    dec a
    jp z,drawItem_idol
    dec a
    jp z,drawItem_phaser
    dec a
    jp z,drawItem_boulder
    dec a
    jp z,drawItem_button
    dec a
    jp z,drawItem_door
    ret

;drawItem_machete:
;    ld hl,machete_patterns
;    jp drawItem_general

drawItem_bomb:
    ld hl,bomb_patterns
    jp drawItem_general

drawItem_rope:
    ld hl,rope_patterns
    jp drawItem_general

drawItem_shield:
    ld hl,shield_patterns
    jp drawItem_general

drawItem_bow:
    ld hl,bow_patterns
    jp drawItem_general

drawItem_arrow:
    ld hl,arrow_patterns
    ld a,(de)
    cp TILE_BG_END+1
    jp nc,drawItem_arrow_skip1    
    ldi
drawItem_arrow2:
    ld a,(map_width)
    dec a
    ADD_DE_A
    ld a,(de)
    cp TILE_BG_END+1
    ret nc
    ldi
    ret

drawItem_arrow_skip1:
    inc de
    inc hl
    jp drawItem_arrow2

drawItem_stone:
    ld a,(map_width)
    ADD_DE_A
    ld a,(de)
    cp TILE_BG_END+1
    ret nc    
    ld a,stone_pattern
    ld (de),a
    ret

drawItem_boots:
    ld hl,boots_patterns
    jp drawItem_general

drawItem_belt:
    ld hl,belt_patterns
    jp drawItem_general

drawItem_scubamask:
    ld hl,scubamask_patterns
    jp drawItem_general

drawItem_idol:
    ld hl,idol_patterns
    jp drawItem_general

drawItem_phaser:
    ld hl,phaser_patterns
    jp drawItem_general

drawItem_boulder:
    ld hl,boulder_patterns
    jp drawItem_general_no_skipping

drawItem_button:
    inc hl
    inc hl
    inc hl
    ld a,(hl)   ; get the button state
    or a
    jp nz,drawItem_button_down
    ld hl,button_up_patterns
    jp drawItem_general
drawItem_button_down:
    ld hl,button_down_patterns
    jp drawItem_general

drawItem_door:
    inc hl
    inc hl
    inc hl
    ld a,(hl)   ; get the door state
    or a
    jp z,drawItem_door_closed
drawItem_door_open:
    ; door opens from the top, so this skips the first two lines
    ld hl,map_width
    ld a,(hl)
    ADD_DE_A
    ld a,(hl)
    ADD_DE_A
    ld hl,door_patterns
    jp drawItem_general_no_skipping
drawItem_door_closed:
    ld hl,door_patterns
    call drawItem_general_no_skipping
    ld a,(map_width)
    sub 2
    ADD_DE_A
    jp drawItem_general_no_skipping


; this methods draws only on top of background tiles,
; the "drawItem_general_no_skipping" version, just draws overwritting anything
drawItem_general:
    ld a,(de)
    cp TILE_BG_END+1
    jp nc,drawItem_general_skip1
    ldi
drawItem_general2:
    ld a,(de)
    cp TILE_BG_END+1
    jp nc,drawItem_general_skip2
    ldi
drawItem_general3:
    ld a,(map_width)
    sub 2
    ADD_DE_A
    ld a,(de)
    cp TILE_BG_END+1
    jp nc,drawItem_general_skip3
    ldi
drawItem_general4:
    ld a,(de)
    cp TILE_BG_END+1
    ret nc
    ldi
    ret

drawItem_general_skip1:
    inc de
    inc hl
    jp drawItem_general2
drawItem_general_skip2:
    inc de
    inc hl
    jp drawItem_general3
drawItem_general_skip3:
    inc de
    inc hl
    jp drawItem_general4

drawItem_general_no_skipping:
    ldi
    ldi
    ld a,(map_width)
    sub 2
    ADD_DE_A
    ldi
    ldi
    ret

;-----------------------------------------------
; Remove the item pointed to by "de" to "map".
removeItem:
    ; 1) store the background
    ; 1.1) get the info from the item struct:
    inc de
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    inc de
    inc de
    ; 1.2) calculate the position in the map where to render
    ld h,0
    ld l,b  ; hl = y
    ld a,(map_width_log2)
    ld b,a
removeItem_loop:
    add hl,hl
    djnz removeItem_loop
    ld b,0
    add hl,bc
    ld bc,map
    add hl,bc
    push hl
    ; 1.3) restore the background
    ex de,hl
    call drawItem_general_no_skipping
    pop hl
    ret


;-----------------------------------------------
; updates the items that need updating in the game (e.g., boulders falling, buttons being pressed, etc.)
; item updates are very slow, since moving an item of position implies removing all of them and then redrawing. So, 
; these should be kept to a minimum.
itemUpdate:
    ld a,(map_n_items)
    or a
    ret z
    ld b,a
    ld ix,map_items
itemUpdate_loop:
    push bc

    ld a,(ix)
    or a
    jp z,itemUpdate_loop_next
    cp ITEM_BOULDER+1       
    jp m,itemUpdate_gravity ;; all the items with IDs lower or equal than ITEM_BOULDER are afected by gravity
    cp ITEM_BUTTON
    jp z,itemUpdate_button

itemUpdate_loop_next:
    ld bc,ITEM_STRUCT_SIZE
    add ix,bc
    pop bc
    djnz itemUpdate_loop
    ret

itemUpdate_gravity:
    ld a,(game_cycle)
    and #07
    jp nz,itemUpdate_loop_next

    ld c,(ix+1)
    ld b,(ix+2)
    ld a,(map_height)
    cp b
    jp m,itemUpdate_outofbounds
    inc b
    inc b
    call getMapCell
    jp nz,itemUpdate_gravity_second_check
    cp TILE_PLATFORM_START  ; this assumes that "wall" comes after "platform"
    jp nc,itemUpdate_loop_next
    inc hl
    ld a,(hl)
itemUpdate_gravity_second_check:
    cp TILE_PLATFORM_START  ; this assumes that "wall" comes after "platform"
    jp nc,itemUpdate_loop_next
    ; there is nothing below this boulder move it down!
    call removeAllItems
    inc (ix+2)
    call drawAllItems
    jp itemUpdate_loop_next

itemUpdate_button:
    push ix
    pop hl
    call collisionWithItem
    jr nz,itemUpdate_button_being_pressed
    ld c,(ix+1)   ; button x
    ld b,(ix+2)   ; button y
    inc b
    push bc
    call getMapCell
    pop bc
    ld d,a
    call isWall
    jr nz,itemUpdate_button_being_pressed
    ld a,d
    call isIdolTile
    jr nz,itemUpdate_button_being_pressed
    inc hl
    ld a,(hl)
;    inc c
;    call getMapCell
    ld d,a
    call isWall
    jp nz,itemUpdate_button_being_pressed
    ld a,d
    call isIdolTile
    jp nz,itemUpdate_button_being_pressed

    ; button is not being pressed:
    ld a,(ix+3)   ; button status
    or a
    jp z,itemUpdate_loop_next
    ; button was pressed, and now it is not pressed:
    xor a
    jr itemUpdate_button_updateDoor
itemUpdate_button_being_pressed:
    ld a,(ix+3)   ; button status
    or a
    jp nz,itemUpdate_loop_next
    ; button was not pressed, and now it is pressed:
    ld a,1
itemUpdate_button_updateDoor:
    ld (ix+3),a
    call setDoorStatus
    call removeAllItems
    call drawAllItems
    ld hl,SFX_door_open
    call playSFX
    jp itemUpdate_loop_next

itemUpdate_outofbounds:
    ld (ix),0
    jp itemUpdate_loop_next


;-----------------------------------------------
; sets the status of all the doors in the level to "a"
setDoorStatus:
    ld d,a
    ld a,(map_n_items)
    or a
    ret z
    ld b,a
    ld hl,map_items
setDoorStatus_loop:
    push hl
    ld a,(hl)
    cp ITEM_DOOR
    jp nz,setDoorStatus_loop_continue
    inc hl
    inc hl
    inc hl
    ld (hl),d
setDoorStatus_loop_continue:
    pop hl
    push bc
    ld bc,ITEM_STRUCT_SIZE
    add hl,bc
    pop bc
    djnz setDoorStatus_loop
    ret


;-----------------------------------------------
; Checks if the player is touching the item pointed at by (hl)
; - if there is NO collision, then Z is true
; - if there is collision, then NZ is true
collisionWithItem:
    ld a,(hl)
    ld d,a
    inc hl
    ld a,(player_x)
    sub (hl)

    ; if it's stone or arrow, collide with one less column (since they are narrower)
    ld e,a  ; temporarily store a in e
    ld a,d  ; d contains the item type
    cp ITEM_STONE
    jp z,collisionWithItems_skip_first_x_check
    cp ITEM_ARROW
    jp z,collisionWithItems_skip_first_x_check
    ld a,e  ; recover a

    dec a
    jp z,collisionWithItems_loop_y_collision
collisionWithItems_skip_first_x_check:
    ld a,e  ; recover a
    or a
    jp z,collisionWithItems_loop_y_collision
    inc a
    jp nz,collisionWithItems_loop_no_collision  
collisionWithItems_loop_y_collision:
    ld a,(player_y)
    inc hl
    sub (hl)
    dec a
    jp z,collisionWithItems_loop_collision
    inc a
    jp z,collisionWithItems_loop_collision
    inc a
    jp nz,collisionWithItems_loop_no_collision  
collisionWithItems_loop_collision:
    or 1    ; signal collision
    ret
collisionWithItems_loop_no_collision:
    xor a
    ret


;-----------------------------------------------
; Checks if the player is touching any item. This collision is done from the last object back,
; so that the if there are multiple collisions, the one returned is the one of the object the player can see.
; - if there is NO collision, then Z is true
; - if there is collision, then NZ is true, and the object collided with is pointed to by HL
collisionWithItems:
    ld a,(map_n_items)
    or a
    ret z
    ld h,0
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl    ; assuming items are 8 bytes
    ld bc,map_items
    add hl,bc
    xor a
    ld bc,ITEM_STRUCT_SIZE
    sbc hl,bc
    ld a,(map_n_items)
    ld b,a
collisionWithItems_loop:
    push bc
    ld a,(hl)
    or a
    jp z,collisionWithItems_loop_no_item
    push hl
    call collisionWithItem
    pop hl
    jp nz,collisionWithItems_collision
collisionWithItems_loop_no_item:
    ld bc,ITEM_STRUCT_SIZE
    xor a
    sbc hl,bc
    pop bc
    djnz collisionWithItems_loop
    xor a   ; signal no collision
    ret
collisionWithItems_collision:
    pop bc
    ret


;-----------------------------------------------
; Checks if there is a boulder immediately to the left of the player, and if there is, it
; tries to push it to the left if there is space available
checkForBoulderPushLeft:
    ld hl,map_items
    ld b,map_n_items
checkForBoulderPushLeft_loop:
    push hl
    ld a,(hl)
    cp ITEM_BOULDER
    jp nz,checkForBoulderPushLeft_loop_next
    inc hl
    ld c,(hl)
    ld a,(player_x)
    sub 2
    cp c
    jp nz,checkForBoulderPushLeft_loop_next
    inc hl
    ld c,(hl)
    ld a,(player_y)
    inc a
    cp c
    jp m,checkForBoulderPushLeft_loop_next
    sub 3
    cp c
    jp p,checkForBoulderPushLeft_loop_next

    ; we found the boulder!
    ld b,c   ; boulder y
    dec hl
    ld c,(hl)   ; boulder x
    dec c
    call checkForBoulderPush
    pop hl
    ret nz

    ; there is space for the boulder to be moved, so a push is possible!
    push hl
    ld hl,SFX_boulder_pushed
    call playSFX

    call removeAllItems
    pop hl
    inc hl
    dec (hl)
    dec hl
    call drawAllItems
    ret

checkForBoulderPushLeft_loop_next:
    pop hl
    ld de,8
    add hl,de
    djnz checkForBoulderPushLeft_loop
    ret

checkForBoulderPush:
    push bc
    call getMapCell
    call isWall
    pop bc
    ret nz  ; if there is something that could potentially block the boulder, return
    inc b
    call getMapCell
    call isWall
    ret


;-----------------------------------------------
; Checks if there is a boulder immediately to the right of the player, and if there is, it
; tries to push it to the right if there is space available
checkForBoulderPushRight:
    ld hl,map_items
    ld b,map_n_items
checkForBoulderPushRight_loop:
    push hl
    ld a,(hl)
    cp ITEM_BOULDER
    jp nz,checkForBoulderPushRight_loop_next
    inc hl
    ld c,(hl)
    ld a,(player_x)
    add a,2
    cp c
    jp nz,checkForBoulderPushRight_loop_next
    inc hl
    ld c,(hl)
    ld a,(player_y)
    inc a
    cp c
    jp m,checkForBoulderPushRight_loop_next
    sub 3
    cp c
    jp p,checkForBoulderPushRight_loop_next

    ; we found the boulder!
    ld b,c   ; boulder y
    dec hl
    ld c,(hl)   ; boulder x
    inc c
    inc c
    call checkForBoulderPush
    pop hl
    ret nz
    
    ; there is space fot the boulder to be moved, so a push is possible!
    push hl
    ld hl,SFX_boulder_pushed
    call playSFX

    call removeAllItems
    pop hl
    inc hl
    inc (hl)
    dec hl
    call drawAllItems
    ret

checkForBoulderPushRight_loop_next:
    pop hl
    ld de,8
    add hl,de
    djnz checkForBoulderPushRight_loop
    ret


;-----------------------------------------------
; Adds an item of type "a" to the map, in position "bc" (b is "y", and c is "x")
; the "z" flag upon return indicates success (z or not, nz)
spawnItemInMap:
    push af ; save the type of item to add
    push bc
    call removeAllItems ; we first remove (undraw) all the items from the map, since we might be adding a new one in the middle

    ; put the item in the map
    ld a,(map_n_items)
    ld b,a
    ld hl,map_items
    ld de,ITEM_STRUCT_SIZE
spawnItemInMap_loop:
    ld a,(hl)
    or a
    jr z,spawnItemInMap_spot_found
    add hl,de
    djnz spawnItemInMap_loop
    ; we haven't found any empty spot among the first (map_n_items) items, so, see if we can add a new item
    ld a,(map_n_items)
    cp MAX_MAP_ITEMS
    jr nz,spawnItemInMap_create_new_spot
    call drawAllItems
    pop bc
    pop af  ; we restore the stack
    or 1   ; we set the "nz" flat to indicate failure (I know, I know, the "nz" does not exist, it's just "z", but this is easier to understand :)) 
    ret

spawnItemInMap_create_new_spot:
    ld a,(map_n_items)
    inc a
    ld (map_n_items),a
spawnItemInMap_spot_found:
    pop bc
    pop af  ; we recover the type of item to add
    ld (hl),a
    inc hl
    ld (hl),c
    inc hl
    ld (hl),b
    call drawAllItems
    xor a   ; mark the "z" flat to indicate success
    ret


