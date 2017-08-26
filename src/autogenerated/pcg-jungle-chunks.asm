jungle_chunk_table:
  db 26    ; the first byte is the number of chunks
  db PCG_CHUNK_BACKGROUND + PCG_CHUNK_TOP
  dw jungle_chunk_pletter0
  db PCG_CHUNK_BACKGROUND + PCG_CHUNK_TOP
  dw jungle_chunk_pletter1
  db PCG_CHUNK_FG_TYPE1
  dw jungle_chunk_pletter2
  db PCG_CHUNK_FG_TYPE1
  dw jungle_chunk_pletter3
  db PCG_CHUNK_FG_TYPE1
  dw jungle_chunk_pletter4
  db PCG_CHUNK_FG_TYPE1
  dw jungle_chunk_pletter5
  db PCG_CHUNK_FG_TYPE2
  dw jungle_chunk_pletter6
  db PCG_CHUNK_FG_TYPE2
  dw jungle_chunk_pletter7
  db PCG_CHUNK_FG_TYPE3
  dw jungle_chunk_pletter8
  db PCG_CHUNK_FG_TYPE3
  dw jungle_chunk_pletter9
  db PCG_CHUNK_FG_TYPE3
  dw jungle_chunk_pletter10
  db PCG_CHUNK_FG_TYPE4
  dw jungle_chunk_pletter11
  db PCG_CHUNK_FG_TYPE4
  dw jungle_chunk_pletter12
  db PCG_CHUNK_FG_TYPE5
  dw jungle_chunk_pletter13
  db PCG_CHUNK_FG_TYPE5
  dw jungle_chunk_pletter14
  db PCG_CHUNK_FG_TYPE5
  dw jungle_chunk_pletter15
  db PCG_CHUNK_FG_TYPE6
  dw jungle_chunk_pletter16
  db PCG_CHUNK_FG_TYPE6
  dw jungle_chunk_pletter17
  db PCG_CHUNK_FG_TYPE6
  dw jungle_chunk_pletter18
  db PCG_CHUNK_FG_TYPE6
  dw jungle_chunk_pletter19
  db PCG_CHUNK_FG_TYPE1 + PCG_CHUNK_BOTTOM
  dw jungle_chunk_pletter20
  db PCG_CHUNK_FG_TYPE1 + PCG_CHUNK_BOTTOM
  dw jungle_chunk_pletter21
  db PCG_CHUNK_FG_TYPE3 + PCG_CHUNK_BOTTOM
  dw jungle_chunk_pletter22
  db PCG_CHUNK_FG_TYPE4 + PCG_CHUNK_BOTTOM
  dw jungle_chunk_pletter23
  db PCG_CHUNK_DOUBLE_ROOM
  dw jungle_chunk_pletter24
  db PCG_CHUNK_DOUBLE_ROOM
  dw jungle_chunk_pletter25
jungle_chunk_pletter0:
  incbin "pcg-jungle-chunk0.plt"
jungle_chunk_pletter1:
  incbin "pcg-jungle-chunk1.plt"
jungle_chunk_pletter2:
  incbin "pcg-jungle-chunk2.plt"
jungle_chunk_pletter3:
  incbin "pcg-jungle-chunk3.plt"
jungle_chunk_pletter4:
  incbin "pcg-jungle-chunk4.plt"
jungle_chunk_pletter5:
  incbin "pcg-jungle-chunk5.plt"
jungle_chunk_pletter6:
  incbin "pcg-jungle-chunk6.plt"
jungle_chunk_pletter7:
  incbin "pcg-jungle-chunk7.plt"
jungle_chunk_pletter8:
  incbin "pcg-jungle-chunk8.plt"
jungle_chunk_pletter9:
  incbin "pcg-jungle-chunk9.plt"
jungle_chunk_pletter10:
  incbin "pcg-jungle-chunk10.plt"
jungle_chunk_pletter11:
  incbin "pcg-jungle-chunk11.plt"
jungle_chunk_pletter12:
  incbin "pcg-jungle-chunk12.plt"
jungle_chunk_pletter13:
  incbin "pcg-jungle-chunk13.plt"
jungle_chunk_pletter14:
  incbin "pcg-jungle-chunk14.plt"
jungle_chunk_pletter15:
  incbin "pcg-jungle-chunk15.plt"
jungle_chunk_pletter16:
  incbin "pcg-jungle-chunk16.plt"
jungle_chunk_pletter17:
  incbin "pcg-jungle-chunk17.plt"
jungle_chunk_pletter18:
  incbin "pcg-jungle-chunk18.plt"
jungle_chunk_pletter19:
  incbin "pcg-jungle-chunk19.plt"
jungle_chunk_pletter20:
  incbin "pcg-jungle-chunk20.plt"
jungle_chunk_pletter21:
  incbin "pcg-jungle-chunk21.plt"
jungle_chunk_pletter22:
  incbin "pcg-jungle-chunk22.plt"
jungle_chunk_pletter23:
  incbin "pcg-jungle-chunk23.plt"
jungle_chunk_pletter24:
  incbin "pcg-jungle-chunk24.plt"
jungle_chunk_pletter25:
  incbin "pcg-jungle-chunk25.plt"
