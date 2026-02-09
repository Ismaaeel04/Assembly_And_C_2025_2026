*-----------------------------------------------------------
* Title      : PRACTICAL 4, PART 4
* Written by : ISMAEL CHARAF MEGRINI
* Date       : 09/02/2026
* Description:
*-----------------------------------------------------------
 ORG    $1000

START:
    LEA    PlayerHP, A0
    LEA    BossHP, A1
    
    MOVE.B #$64, D0
    MOVE.B #100, D1
    MOVE.W #0, D2
    
    MOVE.B D0, (A0)
    MOVE.B D1, (A1)

GAME_LOOP:
    BSR    ATTACK_BOSS
    
    MOVE.B D1, (A1)
    
    BRA    GAME_OVER
    

ATTACK_BOSS:
    SUB.B  #10, D1
    ADD.W  #50, D2
    EOR.B  #$FF, D3
    RTS

GAME_OVER:
    OR.B   #1, D4
    AND.B  #0, D5
    
    SIMHALT

    ORG    $2000
PlayerHP:  DS.B 1
BossHP:    DS.B 1

    END    START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
