*-----------------------------------------------------------
* Title      : Practical 05, PART 5
* Written by : ISMAEL CHARAF MEGRINI
* Date       : 11/02/2026
* Description: Game Loop with Enemies AND Power-ups
*-----------------------------------------------------------
        ORG     $1000

DAMAGE  EQU     10      ; Amount of damage to take
HEAL    EQU     10      ; Amount of health to gain (Power-up)

START:
                            
        BRA     GAME_LOOP   ; No complex register setup needed anymore!

GAME_LOOP:
        LEA     MSG_GAMELOOP, A1    ; Draw "Game Loop" text
        BSR     DRAW
        
        BSR     UPDATE              ; Move player & update screen
        BSR     CHECK_COLLISION     ; Check for Enemies
        BSR     CHECK_POWERUPS      ; Check for Power-ups (NEW)
        
        BRA     GAME_LOOP

* Moves player and draws health

UPDATE:
  
    ; 1. Draw "Health :" text
    LEA     MSG_HEALTH, A1
    BSR     DRAW

    ; 2. Print the actual Health number (FIX IS HERE)
    CLR.L   D1                  ; Clear D1 completely
    MOVE.B  PLAYER_HEALTH, D1   ; Load Health into D1
                                ; TRAP #15 reads from D1, not D0!
    
    MOVE.B  #3, D0              ; Task #3: Print number in D1
    TRAP    #15

    ; 3. New Line
    LEA     CRLF, A1
    BSR     DRAW

    ; 4. Check for Death
    CMP.B   #0, PLAYER_HEALTH   ; Check the variable, not the register
    BLE     GAME_OVER

    ; 5. Move Player
    ADD.L   #1, PLAYER_X        
    RTS

* CHECK_COLLISION: Loops through enemies

CHECK_COLLISION:
        LEA     ENEMY_POSITIONS, A0 ; Load array address

ENEMY_LOOP:
        MOVE.L  (A0)+, D1           ; Load next enemy into D1
        BEQ     END_CHECK           ; If 0, we reached end of array
        
        CMP.L   PLAYER_X, D1        ; Compare Player vs Enemy
        BEQ     TAKE_DAMAGE         ; If equal, take damage
        BRA     ENEMY_LOOP          ; Check next enemy

TAKE_DAMAGE:
        SUB.B   #DAMAGE, PLAYER_HEALTH
        LEA     MSG_COLLISION, A1
        BSR     DRAW
        RTS

* CHECK_POWERUPS: Loops through power-ups (NEW)

CHECK_POWERUPS:
        LEA     POWER_UPS, A0       ; Load power-up array address

POWER_LOOP:
        MOVE.L  (A0)+, D1           ; Load next power-up into D1
        BEQ     END_CHECK           ; If 0, end of array
        
        CMP.L   PLAYER_X, D1        ; Compare Player vs Power-up
        BEQ     APPLY_HEAL          ; If equal, heal!
        BRA     POWER_LOOP

APPLY_HEAL:
        ADD.B   #HEAL, PLAYER_HEALTH
        LEA     MSG_POWERUP, A1     ; Show message
        BSR     DRAW
        RTS

END_CHECK:
        RTS


* HELPERS & EXIT

DRAW:
        MOVE.B  #14, D0             ; Trap task #14 (Print string)
        TRAP    #15
        RTS

GAME_OVER:
        LEA     MSG_GAMEOVER, A1
        BSR     DRAW
        SIMHALT


* DATA SECTION

PLAYER_X        DC.L    1
PLAYER_HEALTH   DC.B    100

; Messages
MSG_GAMELOOP    DC.B    'Game Loop', 0
MSG_HEALTH      DC.B    ' Health: ', 0
MSG_COLLISION   DC.B    ' *** COLLISION! *** ', 0
MSG_POWERUP     DC.B    ' *** POWER UP! *** ', 0
MSG_GAMEOVER    DC.B    'Game Over!', 0
CRLF            DC.B    $0D, $0A, 0

; Arrays (Terminated with 0)
ENEMY_POSITIONS DC.L    20, 30, 40, 50, 60, 0
POWER_UPS       DC.L    10, 55, 220, 0     ; As per Figure 5.1.1

        END     START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
