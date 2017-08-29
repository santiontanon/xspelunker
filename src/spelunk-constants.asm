;-----------------------------------------------
; BIOS calls:
DCOMPR: equ #0020
ENASLT: equ #0024
WRTVDP: equ #0047
WRTVRM: equ #004d
SETWRT: equ #0053
FILVRM: equ #0056
LDIRMV: equ #0059
LDIRVM: equ #005c
CHGMOD: equ #005f
CHGCLR: equ #0062
GICINI: equ #0090   
WRTPSG: equ #0093 
RDPSG:  equ #0096
CHSNS:  equ #009c
CHGET:  equ #009f
CHPUT:  equ #00a2
GTSTCK: equ #00d5
GTTRIG: equ #00d8
SNSMAT: equ #0141
RSLREG: equ #0138
RDVDP:  equ #013e
KILBUF: equ #0156
CHGCPU:	equ #0180


;-----------------------------------------------
; System variables
VDP.DR:	equ #0006
VDP.DW:	equ #0007
VDP_REGISTER_0: equ #f3df
CLIKSW: equ #f3db       ; keyboard sound
FORCLR: equ #f3e9
BAKCLR: equ #f3ea
BDRCLR: equ #f3eb
PUTPNT: equ #f3f8
GETPNT: equ #f3fa
MODE:   equ #fafc	
KEYS:   equ #fbe5    
KEYBUF: equ #fbf0
EXPTBL: equ #fcc1
TIMI:   equ #fd9f       ; timer interrupt hook
HKEY:   equ #fd9a       ; hkey interrupt hook


;-----------------------------------------------
; Assembler opcodes:	
JPCODE:         equ  #C3


;-----------------------------------------------
; VRAM map in Screen 1 (only 1 table of patterns, color table has 1 byte per each 8 patterns)
CHRTBL1:  equ     #0000   ; pattern table address
NAMTBL1:  equ     #1800   ; name table address 
CLRTBL1:  equ     #2000   ; color table address             
SPRTBL1:  equ     #0800   ; sprite pattern address  
SPRATR1:  equ     #1b00   ; sprite attribute address
; VRAM map in Screen 2 (3 tables of patterns, color table has 8 bytes per pattern)
CHRTBL2:  equ     #0000   ; pattern table address
NAMTBL2:  equ     #1800   ; name table address 
CLRTBL2:  equ     #2000   ; color table address             
SPRTBL2:  equ     #3800   ; sprite pattern address  
SPRATR2:  equ     #1b00   ; sprite attribute address

;-----------------------------------------------
; MSX1 colors:
COLOR_TRANSPARENT:	equ 0
COLOR_BLACK:		equ 1
COLOR_GREEN:		equ 2
COLOR_LIGHT_GREEN:	equ 3
COLOR_DARK_BLUE:	equ 4
COLOR_BLUE:		equ 5
COLOR_DARK_RED:		equ 6
COLOR_LIGHT_BLUE:	equ 7
COLOR_RED:		equ 8
COLOR_LIGHT_RED:	equ 9
COLOR_DARK_YELLOW:	equ 10
COLOR_YELLOW:		equ 11
COLOR_DARK_GREEN:	equ 12
COLOR_PURPLE:		equ 13
COLOR_GREY:		equ 14
COLOR_WHITE:		equ 15

;-----------------------------------------------
; Music related constants:
MAX_SONG_SIZE:			equ 1400

MUSIC_INSTRUMENT_SQUARE_WAVE:   equ 0
MUSIC_INSTRUMENT_PIANO:         equ 1 
MUSIC_INSTRUMENT_WIND:         	equ 2   

MUSIC_CMD_SKIP:           	equ #ff
MUSIC_CMD_SET_INSTRUMENT:       equ #fe
MUSIC_CMD_PLAY_INSTRUMENT_CH1:  equ #fd
MUSIC_CMD_PLAY_INSTRUMENT_CH2:  equ #fc
MUSIC_CMD_PLAY_INSTRUMENT_CH3:  equ #fb
MUSIC_CMD_PLAY_SFX:		equ #fa
MUSIC_CMD_GOTO:           	equ #f9
MUSIC_CMD_END:            	equ #f8
MUSIC_CMD_REPEAT:         	equ #f7
MUSIC_CMD_END_REPEAT:     	equ #f6
SFX_CMD_END:            	equ #f5

SFX_OPEN_HIHAT:			equ 0
SFX_PEDAL_HIHAT:		equ 1


;-----------------------------------------------
; Game constants:	
GAME_STATE_INTRO:		equ 0
GAME_STATE_TITLE:		equ 1
GAME_STATE_INTERLEVEL:		equ 2
GAME_STATE_PLAYING:		equ 3
GAME_STATE_GAMEOVER:		equ 4
GAME_STATE_ENDING:		equ 5

MAX_MAP_SIZE:			equ 4096
MAX_MAP_ENEMIES:		equ 32
MAX_MAP_ITEMS:			equ 32
MAX_MAP_ANIMATIONS:		equ 128
MAX_PLAYER_BULLETS:		equ 2
MAX_EXPLOSIONS:			equ 2
ANIMATION_STRUCT_SIZE:		equ 6	; animation type pointer (2 bytes), pointer to the map (2 bytes), timer, current frame
ENEMY_STRUCT_SIZE:		equ 8	; type, hp, state2, state3, y (tile, pixel), x (tile, pixel)
ITEM_STRUCT_SIZE:		equ 8	; type, x, y, ???, +4 bytes to store the background that was underneath the item
PLAYER_BULLET_STRUCT_SIZE:	equ 8	; type, state1, state2, state3, y (tile, pixel), x (tile, pixel)
EXPLOSION_STRUCT_SIZE:		equ 1+2+BOMB_EXPLOSION_WIDTH*BOMB_EXPLOSION_HEIGHT	; timer, x,y, and buffer

INPUT_TRIGGER1_BIT:		equ 4
INPUT_TRIGGER2_BIT:		equ 5
INPUT_RIGHT_BIT:		equ 3
INPUT_LEFT_BIT:			equ 2
INPUT_UP_BIT:			equ 0
INPUT_DOWN_BIT:			equ 1

INPUT_DOUBLE_CLICK_TIMMER:	equ 16

ITEM_SELECTION_SPRITE:		equ 0
PLAYER_WEAPON_SPRITE:		equ 1
PLAYER_SPRITE:			equ 2
PLAYER_BULLET_FIRST_SPRITE:	equ 4
FIRST_ENEMY_SPRITE_SLOT:	equ 6
ENEMY_SPRITE_SLOTS:		equ 16
NUMBER_OF_SPRITES_USED:		equ 6+ENEMY_SPRITE_SLOTS

PLAYER_BULLET_FIRST_SPRITE_PATTERN:	equ 6
ENEMY_FIRST_SPRITE_PATTERN:	equ 8

PLAYER_STATE_IDLE_RIGHT:	equ 0
PLAYER_STATE_IDLE_LEFT:		equ 1
PLAYER_STATE_CROUCHING_RIGHT:	equ 2
PLAYER_STATE_CROUCHING_LEFT:	equ 3
PLAYER_STATE_FALLING_RIGHT:	equ 4
PLAYER_STATE_FALLING_LEFT:	equ 5
PLAYER_STATE_WALKING_RIGHT:	equ 6
PLAYER_STATE_WALKING_LEFT:	equ 7
PLAYER_STATE_JUMPING_RIGHT:	equ 8
PLAYER_STATE_JUMPING_LEFT:	equ 9
PLAYER_STATE_CLIMBING_RIGHT:	equ 10
PLAYER_STATE_CLIMBING_LEFT:	equ 11
PLAYER_STATE_SWIMMING_RIGHT:	equ 12
PLAYER_STATE_SWIMMING_LEFT:	equ 13
PLAYER_STATE_MACHETE_RIGHT:	equ 14
PLAYER_STATE_MACHETE_LEFT:	equ 15
PLAYER_STATE_SHIELD_RIGHT:	equ 16
PLAYER_STATE_SHIELD_LEFT:	equ 17
PLAYER_STATE_D_WEAPON_RIGHT:	equ 18
PLAYER_STATE_D_WEAPON_LEFT:	equ 19
PLAYER_STATE_HURT_RIGHT:	equ 20
PLAYER_STATE_HURT_LEFT:		equ 21
PLAYER_STATE_DEAD_RIGHT:	equ 22
PLAYER_STATE_DEAD_LEFT:		equ 23

TILE_BG_START:			equ 0
TILE_BG_END:			equ 123
TILE_PRESSUREPLATE_START:	equ 5
TILE_PRESSUREPLATE_END:		equ 8
TILE_HAZARD_START:		equ 124
TILE_HAZARD_END:		equ 127
TILE_WATER_START:		equ 128
TILE_WATER_END:			equ 131
TILE_VINE_START:		equ 132
TILE_VINE_END:			equ 135
TILE_ROPE:			equ 134
TILE_PLATFORM_START:		equ 135
TILE_PLATFORM_END:		equ 139
TILE_WALL_START:		equ 140
TILE_WALL_END:			equ 255
TILE_NON_DESTROYSABLE_WALL_START:	equ 176

TILE_HEART:			equ 63

PLAYER_MAX_HEALTH:		equ 6
INVENTORY_SIZE:			equ 8
TIME_TO_GRAB_ROPE_AGAIN:	equ 9
PLAYER_INMUNITY_TIME:		equ 80
PLAYER_FALL_HURT_TIME:		equ 32
MACHETE_TIME:			equ 6
PUSH_TIME:			equ 24
MAX_ROPE_LENGTH:		equ 12
BOMB_EXPLOSION_WIDTH:		equ 5
BOMB_EXPLOSION_HEIGHT:		equ 5
BOMB_TIMER:			equ 40
COLLISION_BOX_MIN_PIXELS:	equ 3	; how many player pixels need to be in a tile, to be considered for collision

ITEM_BOMB:			equ 1
ITEM_ROPE:			equ 2
ITEM_ARROW:			equ 3
ITEM_STONE:			equ 4
ITEM_MACHETE:			equ 5
ITEM_SHIELD:			equ 6
ITEM_BOW:			equ 7
ITEM_BOOTS:			equ 8
ITEM_BELT:			equ 9
ITEM_SCUBAMASK:			equ 10
ITEM_IDOL:			equ 11
ITEM_PHASER:			equ 12
ITEM_BOULDER:			equ 13
ITEM_BUTTON:			equ 14
ITEM_DOOR:			equ 15
; These are not real items, but placeholders user in the PCG level chunks:
ITEM_PCG_SUPPLY:		equ 16
ITEM_PCG_ANY_JUNGLE:		equ 17
ITEM_PCG_GOOD_ITEM_JUNGLE:	equ 18
ITEM_PCG_ANY_OUTER_RUINS:	equ 19	; the set of items in the outer ruins is the same as in the inner tuins (so, you can get the phaser or belt in the outer ruins)
ITEM_PCG_GOOD_ITEM_OUTER_RUINS:	equ 20	; the set of items in the outer ruins is the same as in the inner tuins (so, you can get the phaser or belt in the outer ruins)
ITEM_PCG_ANY_INNER_RUINS:	equ 19	
ITEM_PCG_GOOD_ITEM_INNER_RUINS:	equ 20	

ENEMY_PINECONE:			equ 1
ENEMY_MONKEY:			equ 2
ENEMY_PIRANHA:			equ 3
ENEMY_SCORPION:			equ 4
ENEMY_BEE_NEST:			equ 5
ENEMY_BEE:			equ 6
ENEMY_EXPLOSION:		equ 7
ENEMY_BULLET:			equ 8
ENEMY_SNAKE:			equ 9
ENEMY_MAYA:			equ 10
ENEMY_ALIEN:			equ 11
ENEMY_SENTINEL:			equ 12
ENEMY_BULLET_LASERH:		equ 13
ENEMY_BULLET_LASERV:		equ 14

PCG_CHUNK_FG_TYPE1:		equ 1
PCG_CHUNK_FG_TYPE2:		equ 2
PCG_CHUNK_FG_TYPE3:		equ 3
PCG_CHUNK_FG_TYPE4:		equ 4
PCG_CHUNK_FG_TYPE5:		equ 5
PCG_CHUNK_FG_TYPE6:		equ 6
PCG_CHUNK_BACKGROUND:		equ 7
PCG_CHUNK_DOUBLE_ROOM:		equ 8
PCG_CHUNK_EMPTY:		equ 9	; this is used to mark spots where we do not want any additional chunk

PCG_CHUNK_TOP:			equ 128
PCG_CHUNK_BOTTOM:		equ 64

; enemy sprite offsets:
ENEMYSPRITE_OFFSET_PINECONE:	equ 0
ENEMYSPRITE_OFFSET_BULLET:	equ 32
ENEMYSPRITE_OFFSET_MONKEY:	equ 2*32
ENEMYSPRITE_OFFSET_PIRANHA:	equ ENEMYSPRITE_OFFSET_MONKEY+6*64
ENEMYSPRITE_OFFSET_SCORPION:	equ ENEMYSPRITE_OFFSET_PIRANHA+3*32
ENEMYSPRITE_OFFSET_BEE_NEST:	equ ENEMYSPRITE_OFFSET_SCORPION+4*32
ENEMYSPRITE_OFFSET_BEE:		equ ENEMYSPRITE_OFFSET_BEE_NEST+32
ENEMYSPRITE_OFFSET_EXPLOSION:	equ ENEMYSPRITE_OFFSET_BEE+4*32
ENEMYSPRITE_OFFSET_SNAKE:	equ ENEMYSPRITE_OFFSET_EXPLOSION+32
ENEMYSPRITE_OFFSET_MAYA:	equ ENEMYSPRITE_OFFSET_SNAKE+4*32
ENEMYSPRITE_OFFSET_ALIEN:	equ ENEMYSPRITE_OFFSET_MAYA+6*64
ENEMYSPRITE_OFFSET_SENTINEL:	equ ENEMYSPRITE_OFFSET_ALIEN+6*64
