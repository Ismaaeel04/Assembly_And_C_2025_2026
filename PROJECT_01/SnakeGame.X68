; ------------------------------------------------------------
; Title      : Snake game
; Written by : Ismael Charaf Megrini
; Date       : 4/03/2026
; Description: Use W/A/S/D to move. Eat * to grow and score 
; ------------------------------------------------------------

    ORG     $1000

; ---- Constants ----
BOARD_W     EQU     20
BOARD_H     EQU     15
MAX_LEN     EQU     100
DIR_UP      EQU     1
DIR_DOWN    EQU     2
DIR_LEFT    EQU     3
DIR_RIGHT   EQU     4

; ---- Program Start ----
START:
            BSR     INIT_GAME

MAIN_LOOP:
            BSR     DRAW_BOARD
            BSR     GET_INPUT
            BSR     MOVE_SNAKE
            BSR     CHECK_COLLISION
            
            ; Check if game over flag is set
            LEA     GAME_FLAG, A1
            CMP.B   #1, (A1)
            BEQ     END_GAME
            
            BSR     CHECK_FOOD
            
            ; Small delay
            MOVE.B  #8, D0
            TRAP    #15
            MOVE.L  D1, D7
DELAY_LOOP:
            MOVE.B  #8, D0
            TRAP    #15
            SUB.L   D7, D1
            CMP.L   #30, D1
            BLT     DELAY_LOOP
            
            BRA     MAIN_LOOP

; ============================================================
; INIT_GAME - Set starting values
; ============================================================
INIT_GAME:
            ; Snake starts at position 10,7
            LEA     SNAKE_X, A1
            MOVE.B  #10, (A1)
            LEA     SNAKE_Y, A1
            MOVE.B  #7, (A1)
            
            ; Snake length = 3
            LEA     SNAKE_LEN, A1
            MOVE.B  #3, (A1)
            
            ; Direction = RIGHT
            LEA     DIRECTION, A1
            MOVE.B  #DIR_RIGHT, (A1)
            
            ; Score = 0
            LEA     SCORE, A1
            MOVE.L  #0, (A1)
            
            ; Game flag = 0 (playing)
            LEA     GAME_FLAG, A1
            MOVE.B  #0, (A1)
            
            ; Init body positions (tail behind head)
            LEA     BODY_X, A1
            LEA     BODY_Y, A2
            MOVE.B  #10, (A1)
            MOVE.B  #7, (A2)
            MOVE.B  #9, 1(A1)
            MOVE.B  #7, 1(A2)
            MOVE.B  #8, 2(A1)
            MOVE.B  #7, 2(A2)
            
            ; Place first food
            LEA     FOOD_X, A1
            MOVE.B  #5, (A1)
            LEA     FOOD_Y, A1
            MOVE.B  #5, (A1)
            
            RTS

; ============================================================
; DRAW_BOARD - Clear and draw the game
; ============================================================
DRAW_BOARD:
            ; Clear screen
            MOVE.B  #11, D0
            MOVE.W  #$FF00, D1
            TRAP    #15
            
            ; Set cursor to top
            MOVE.B  #11, D0
            MOVE.W  #$0000, D1
            TRAP    #15
            
            ; Draw top border
            LEA     MSG_BORDER_TOP, A1
            MOVE.B  #13, D0
            TRAP    #15
            
            ; Draw each row
            MOVE.B  #0, D6          ; row counter
            
DRAW_ROW:
            CMP.B   #BOARD_H, D6
            BEQ     DRAW_BOTTOM
            
            ; Print left wall
            MOVE.B  #'|', D1
            MOVE.B  #6, D0
            TRAP    #15
            
            ; Print each column
            MOVE.B  #0, D5          ; col counter
            
DRAW_COL:
            CMP.B   #BOARD_W, D5
            BEQ     DRAW_ROW_END
            
            ; Check if this cell is food
            LEA     FOOD_X, A1
            LEA     FOOD_Y, A2
            CMP.B   (A1), D5
            BNE     NOT_FOOD
            CMP.B   (A2), D6
            BNE     NOT_FOOD
            
            ; Its food
            MOVE.B  #'*', D1
            MOVE.B  #6, D0
            TRAP    #15
            ADD.B   #1, D5
            BRA     DRAW_COL
            
NOT_FOOD:
            ; Check if this cell is snake body
            BSR     CHECK_BODY_CELL
            CMP.B   #1, D4
            BEQ     DRAW_SNAKE_CHAR
            
            ; Empty space
            MOVE.B  #' ', D1
            MOVE.B  #6, D0
            TRAP    #15
            ADD.B   #1, D5
            BRA     DRAW_COL

DRAW_SNAKE_CHAR:
            ; Check if its the head (index 0)
            CMP.B   #1, D3
            BEQ     DRAW_HEAD
            MOVE.B  #'o', D1
            MOVE.B  #6, D0
            TRAP    #15
            ADD.B   #1, D5
            BRA     DRAW_COL

DRAW_HEAD:
            MOVE.B  #'@', D1
            MOVE.B  #6, D0
            TRAP    #15
            ADD.B   #1, D5
            BRA     DRAW_COL
            
DRAW_ROW_END:
            ; Print right wall and newline
            MOVE.B  #'|', D1
            MOVE.B  #6, D0
            TRAP    #15
            ; Newline
            LEA     MSG_NEWLINE, A1
            MOVE.B  #13, D0
            TRAP    #15
            
            ADD.B   #1, D6
            BRA     DRAW_ROW
            
DRAW_BOTTOM:
            LEA     MSG_BORDER_BOT, A1
            MOVE.B  #13, D0
            TRAP    #15
            
            ; Show score
            LEA     MSG_SCORE, A1
            LEA     SCORE, A6
            MOVE.L  (A6), D1
            MOVE.B  #17, D0
            TRAP    #15
            
            ; Show controls
            LEA     MSG_CONTROLS, A1
            MOVE.B  #13, D0
            TRAP    #15
            
            RTS

; ============================================================
; CHECK_BODY_CELL - Check if D5,D6 is a snake cell
; Sets D4=1 if yes, D4=0 if no, D3=1 if head
; ============================================================
CHECK_BODY_CELL:
            MOVE.B  #0, D4
            MOVE.B  #0, D3
            LEA     BODY_X, A1
            LEA     BODY_Y, A2
            LEA     SNAKE_LEN, A3
            MOVE.B  (A3), D2
            AND.L   #$FF, D2
            MOVE.L  #0, D1
            
CHECK_BODY_LP:
            CMP.L   D2, D1
            BEQ     CHECK_BODY_END
            
            CMP.B   0(A1,D1), D5
            BNE     CHECK_NEXT
            CMP.B   0(A2,D1), D6
            BNE     CHECK_NEXT
            
            ; Match found
            MOVE.B  #1, D4
            CMP.L   #0, D1
            BNE     CHECK_BODY_END
            MOVE.B  #1, D3      ; its the head
            BRA     CHECK_BODY_END
            
CHECK_NEXT:
            ADD.L   #1, D1
            BRA     CHECK_BODY_LP
            
CHECK_BODY_END:
            RTS

; ============================================================
; GET_INPUT - Read keyboard input
; ============================================================
GET_INPUT:
            ; Check if key is pending
            MOVE.B  #7, D0
            TRAP    #15
            CMP.B   #0, D1
            BEQ     NO_INPUT
            
            ; Read the key
            MOVE.B  #5, D0
            TRAP    #15
            
            ; Check W/A/S/D
            CMP.B   #'w', D1
            BEQ     SET_UP
            CMP.B   #'W', D1
            BEQ     SET_UP
            CMP.B   #'s', D1
            BEQ     SET_DOWN
            CMP.B   #'S', D1
            BEQ     SET_DOWN
            CMP.B   #'a', D1
            BEQ     SET_LEFT
            CMP.B   #'A', D1
            BEQ     SET_LEFT
            CMP.B   #'d', D1
            BEQ     SET_RIGHT
            CMP.B   #'D', D1
            BEQ     SET_RIGHT
            BRA     NO_INPUT

SET_UP:
            LEA     DIRECTION, A1
            CMP.B   #DIR_DOWN, (A1)
            BEQ     NO_INPUT
            MOVE.B  #DIR_UP, (A1)
            BRA     NO_INPUT
SET_DOWN:
            LEA     DIRECTION, A1
            CMP.B   #DIR_UP, (A1)
            BEQ     NO_INPUT
            MOVE.B  #DIR_DOWN, (A1)
            BRA     NO_INPUT
SET_LEFT:
            LEA     DIRECTION, A1
            CMP.B   #DIR_RIGHT, (A1)
            BEQ     NO_INPUT
            MOVE.B  #DIR_LEFT, (A1)
            BRA     NO_INPUT
SET_RIGHT:
            LEA     DIRECTION, A1
            CMP.B   #DIR_LEFT, (A1)
            BEQ     NO_INPUT
            MOVE.B  #DIR_RIGHT, (A1)
            
NO_INPUT:
            RTS

; ============================================================
; MOVE_SNAKE - Shift body and move head
; ============================================================
MOVE_SNAKE:
            LEA     SNAKE_LEN, A3
            MOVE.B  (A3), D2
            AND.L   #$FF, D2
            
            ; Shift body from tail to head
            LEA     BODY_X, A1
            LEA     BODY_Y, A2
            
            MOVE.L  D2, D1
            SUB.L   #1, D1          ; start at last index
            
SHIFT_LOOP:
            CMP.L   #0, D1
            BEQ     SHIFT_DONE
            
            ; body[i] = body[i-1]
            MOVE.L  D1, D0
            SUB.L   #1, D0
            MOVE.B  0(A1,D0), 0(A1,D1)
            MOVE.B  0(A2,D0), 0(A2,D1)
            
            SUB.L   #1, D1
            BRA     SHIFT_LOOP
            
SHIFT_DONE:
            ; Move head based on direction
            LEA     DIRECTION, A3
            MOVE.B  (A3), D0
            
            LEA     SNAKE_X, A4
            LEA     SNAKE_Y, A5
            
            CMP.B   #DIR_UP, D0
            BEQ     MOVE_UP
            CMP.B   #DIR_DOWN, D0
            BEQ     MOVE_DOWN
            CMP.B   #DIR_LEFT, D0
            BEQ     MOVE_LEFT
            BRA     MOVE_RIGHT_DIR

MOVE_UP:
            SUB.B   #1, (A5)
            BRA     UPDATE_HEAD
MOVE_DOWN:
            ADD.B   #1, (A5)
            BRA     UPDATE_HEAD
MOVE_LEFT:
            SUB.B   #1, (A4)
            BRA     UPDATE_HEAD
MOVE_RIGHT_DIR:
            ADD.B   #1, (A4)

UPDATE_HEAD:
            ; Update body[0] with new head position
            MOVE.B  (A4), (A1)
            MOVE.B  (A5), (A2)
            RTS

; ============================================================
; CHECK_COLLISION - Wall and self collision
; ============================================================
CHECK_COLLISION:
            LEA     SNAKE_X, A1
            LEA     SNAKE_Y, A2
            
            ; Wall check
            CMP.B   #0, (A1)
            BLT     SET_GAMEOVER
            CMP.B   #BOARD_W, (A1)
            BEQ     SET_GAMEOVER
            CMP.B   #0, (A2)
            BLT     SET_GAMEOVER
            CMP.B   #BOARD_H, (A2)
            BEQ     SET_GAMEOVER
            
            ; Self collision - check head vs rest of body
            LEA     BODY_X, A3
            LEA     BODY_Y, A4
            LEA     SNAKE_LEN, A5
            MOVE.B  (A5), D2
            AND.L   #$FF, D2
            MOVE.L  #1, D1          ; start from index 1
            
SELF_CHECK:
            CMP.L   D2, D1
            BEQ     NO_COLLISION
            
            MOVE.B  (A1), D0
            CMP.B   0(A3,D1), D0
            BNE     SELF_NEXT
            MOVE.B  (A2), D0
            CMP.B   0(A4,D1), D0
            BEQ     SET_GAMEOVER
            
SELF_NEXT:
            ADD.L   #1, D1
            BRA     SELF_CHECK
            
SET_GAMEOVER:
            LEA     GAME_FLAG, A1
            MOVE.B  #1, (A1)
NO_COLLISION:
            RTS

; ============================================================
; CHECK_FOOD - See if snake ate food
; ============================================================
CHECK_FOOD:
            LEA     SNAKE_X, A1
            LEA     SNAKE_Y, A2
            LEA     FOOD_X, A3
            LEA     FOOD_Y, A4
            
            MOVE.B  (A1), D0
            CMP.B   (A3), D0
            BNE     NO_EAT
            MOVE.B  (A2), D0
            CMP.B   (A4), D0
            BNE     NO_EAT
            
            ; Ate food! Grow snake
            LEA     SNAKE_LEN, A5
            ADD.B   #1, (A5)
            
            ; Add score
            LEA     SCORE, A6
            ADD.L   #10, (A6)
            
            ; New food position using timer
            BSR     PLACE_FOOD
            
NO_EAT:
            RTS

; ============================================================
; PLACE_FOOD - Put food at a new spot
; ============================================================
PLACE_FOOD:
            MOVE.B  #8, D0
            TRAP    #15
            ; D1.L = time
            
            ; X = time mod BOARD_W (keep in range 1-18)
            AND.L   #$FFFF, D1
            MOVE.L  D1, D2
            
            ; Simple mod for X
            AND.L   #$0F, D1
            ADD.L   #2, D1
            CMP.L   #BOARD_W, D1
            BLT     X_OK
            SUB.L   #5, D1
X_OK:
            LEA     FOOD_X, A1
            MOVE.B  D1, (A1)
            
            ; Y from different bits
            MOVE.L  D2, D1
            LSR.L   #4, D1
            AND.L   #$0F, D1
            ADD.L   #1, D1
            CMP.L   #BOARD_H, D1
            BLT     Y_OK
            SUB.L   #4, D1
Y_OK:
            LEA     FOOD_Y, A1
            MOVE.B  D1, (A1)
            RTS

; ============================================================
; END_GAME - Game over screen
; ============================================================
END_GAME:
            LEA     MSG_GAMEOVER, A1
            MOVE.B  #13, D0
            TRAP    #15
            
            LEA     MSG_FINAL, A1
            LEA     SCORE, A6
            MOVE.L  (A6), D1
            MOVE.B  #17, D0
            TRAP    #15
            
            LEA     MSG_NEWLINE, A1
            MOVE.B  #13, D0
            TRAP    #15
            
            SIMHALT

; ============================================================
; Data Section
; ============================================================
SNAKE_X:        DC.B    10
SNAKE_Y:        DC.B    7
SNAKE_LEN:      DC.B    3
DIRECTION:      DC.B    4
GAME_FLAG:      DC.B    0
                DS.W    0
SCORE:          DC.L    0
FOOD_X:         DC.B    5
FOOD_Y:         DC.B    5

; Snake body arrays
                DS.W    0
BODY_X:         DS.B    MAX_LEN
BODY_Y:         DS.B    MAX_LEN

; ---- Messages ----
MSG_BORDER_TOP: DC.B    '+--------------------+',0
MSG_BORDER_BOT: DC.B    '+--------------------+',0
MSG_NEWLINE:    DC.B    '',0
MSG_SCORE:      DC.B    ' Score: ',0
MSG_CONTROLS:   DC.B    ' W/A/S/D to move',0
MSG_GAMEOVER:   DC.B    '*** GAME OVER ***',0
MSG_FINAL:      DC.B    'Final Score: ',0

            END     START



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
