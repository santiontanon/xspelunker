; for making the music louder:
;Piano_instrument_profile:
;    db 5,10,15,14,13,12,11,11,10,10,9,9,8,#ff
;Wind_instrument_profile:
;    db 0,4,8,10,12,13,14, #ff
;SquareWave_instrument_volume:   equ 14

; with these the music is quieter, and the SFX are heard better:
Piano_instrument_profile:
    db 4,8,12,11,10,10,9,9,8,8,7,7,6,#ff
Wind_instrument_profile:
    db 0,3,6,8,10,11,12, #ff
SquareWave_instrument_volume:   equ 12


SFX_weapon_switch:
  db  7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,0, 5,#01 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#40,5,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#09    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#07    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#05    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#03    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END 


SFX_playerhit:
  db 7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,#00, 5,#08 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 5,#04 ;; frequency
  db MUSIC_CMD_SKIP
  db 5,#02 ;; frequency
  db MUSIC_CMD_SKIP
  db 5,#01 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#80, 5, #00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#40 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#20 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_jump:
  db 7,#b8    ;; SFX all channels to tone
  db 10,#0c    ;; volume
  db 4,#00, 5,#02 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#08, 5,#01 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#c0, 5,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_watersplash:
  db  7,#9c    ;; noise in channel C, and tone in channels B and A
  db 10,#0d    ;; volume
  db  6,#08    ;; noise frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db  6,#04    ;; noise frequency
  db 10,#0d    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#09    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#09    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#09    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#02    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#02    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 7,#b8    ;; SFX all channels to tone
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_item_pickup:
  db  7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,#80, 5,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db MUSIC_CMD_SKIP

  db 10,#0f    ;; volume
  db 4,#70, 5,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db MUSIC_CMD_SKIP

  db 10,#0f    ;; volume
  db 4,#60, 5,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db MUSIC_CMD_SKIP

  db 10,#0f    ;; volume
  db 4,#50, 5,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#02    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END    


SFX_sword_swing:
  db  7,#9c    ;; noise in channel C, and tone in channels B and A
  db 10,#0a    ;; volume
  db  6,#16    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#0c    ;; volume
  db  6,#14    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#0f    ;; volume
  db  6,#12    ;; noise frequency
  db MUSIC_CMD_SKIP
  db  6,#10    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#0c    ;; volume
  db  6,#08    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#0a    ;; volume
  db  6,#06    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db  6,#04    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db  6,#02    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db  6,#01    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#02    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END    


SFX_door_open:
SFX_boulder_pushed:
  db  7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,#00, 5,#06 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0e    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0c    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0a    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#07    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#05    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_fire_arrow:
  db 7,#b8    ;; SFX all channels to tone
  db 4,#00,5,#04    ;; frequency
  db 10,#10          ;; volume
  db 11,#00,12,#10  ;; envelope frequency
  db 13,#09         ;; shape of the envelope
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 4,#00,5,#08    ;; frequency
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db 10,#00          ;; silence
  db SFX_CMD_END   

SFX_fire_phaser:   
  db 7,#b8    ;; SFX all channels to tone
  db 4,#40,5,#00    ;; frequency
  db 10,#10          ;; volume
  db 11,#00,12,#10  ;; envelope frequency
  db 13,#09         ;; shape of the envelope
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 4,#60,5,#00    ;; frequency
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db 4,#80,5,#00    ;; frequency
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db 4,#a0,5,#00    ;; frequency
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db 4,#c0,5,#00    ;; frequency
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db 4,#e0,5,#00    ;; frequency
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db 4,#00,5,#01    ;; frequency
  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
  db 10,#00          ;; silence
  db SFX_CMD_END   

SFX_bullet_bounce:
  db 7,#b8    ;; SFX all channels to tone
  db 4,#00,5,#08    ;; frequency
  db 10,#0c    ;; volume
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#00          ;; silence
  db SFX_CMD_END   

SFX_explosion:   
  db  7,#9c    ;; noise in channel C, and tone in channels B and A
  db 10,#0f    ;; volume
  db  6,#10    ;; noise frequency
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  6,#14    ;; noise frequency
  db 10,#0c    ;; volume
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  6,#18    ;; noise frequency
  db 10,#09    ;; volume
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  6,#1c    ;; noise frequency
  db 10,#06    ;; volume
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  6,#1f    ;; noise frequency
  db 10,#03    ;; volume
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#00          ;; silence
  db SFX_CMD_END    


;SFX_fire_bullet_enemy:   
;  db 7,#b8    ;; SFX all channels to tone
;  db 4,#00,5,#02    ;; frequency
;  db 10,#10          ;; volume
;  db 11,#00,12,#10  ;; envelope frequency
;  db 13,#09         ;; shape of the envelope
;  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
;  db 4,#00,5,#04    ;; frequency
;  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
;  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
;  db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
;  db 10,#00          ;; silence
;  db SFX_CMD_END    


SFX_hit_enemy:
  db  7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,#0, 5,4 ;; frequency
  db MUSIC_CMD_SKIP
  db 5,5 ;; frequency
  db MUSIC_CMD_SKIP
  db 5,6 ;; frequency
  db MUSIC_CMD_SKIP
  db 5,7 ;; frequency
  db MUSIC_CMD_SKIP
  db 5,8 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db 5,9 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0a    ;; volume
  db 5,10 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#00    ;; volume
  db SFX_CMD_END


SFX_hit_deflected:
  db  7,#9c    ;; noise in channel C, and tone in channels B and A
  db 10,#0f    ;; volume
  db  6,#04    ;; noise frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP

  db  6,#01    ;; noise frequency
  db 10,#0c    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP

  db 10,#0a    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db  7,#b8    ;; SFX all channels to tone
  db 10,#0c    ;; volume
  db 4,#20, 5,0 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP

  db 10,#0a    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; volume
  db SFX_CMD_END


SFX_enemy_kill:
  db  7,#b8    ;; SFX all channels to tone

  db 10,#0f    ;; volume
  db 4,0, 5,8 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 5,6      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db 5,4      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db 5,2      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP

  db 10,#0d    ;; volume
  db 5,6 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 5,4      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db 5,3      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db 5,2      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP

  db 10,#0b    ;; volume
  db 5,4 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 5,3      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db 5,2      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db 5,1      ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP

  db 10,#00    ;; silence
  db SFX_CMD_END      


SFX_timer:   
    db  7,#b8    ;; SFX all channels to tone
    db 10,#0f    ;; volume
    db 4,#00,5,#01   ;; frequency
    db MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP
    db 10,#00    ;; silence
    db SFX_CMD_END      

   
;-----------------------------------------------
; Sound effects used for the percussion in the songs
SFX_open_hi_hat:
  db  7,#9c    ;; noise in channel C, and tone in channels B and A
  db 10,#0c    ;; volume
  db  6,#40    ;; noise frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0a    ;; volume
  db  6,#60    ;; noise frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db  6,#80    ;; noise frequency
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#00    ;; volume
  db  7,#b8    ;; SFX all channels to tone
  db SFX_CMD_END      

SFX_pedal_hi_hat:
  db  7,#9c    ;; noise in channel C, and tone in channels B and A
  db 10,#05    ;; volume
  db  6,#20    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db  6,#20    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db  6,#20    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10,#00    ;; volume
  db  7,#b8    ;; SFX all channels to tone
  db SFX_CMD_END   
