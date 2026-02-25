*-----------------------------------------------------------
* Title      : Practical 6, PART 6
* Written by : Ismael Charaf Megrini
* Date       : 25/02/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000

START:
    MOVE.L #HEALTH, -(SP)
    MOVE.B #14, D0
    MOVE.B #14, D1

    MOVE.L D0, -(SP)      
    MOVE.L D1, -(SP)      

    JSR    GAME_LOOP
    BSR    HEADS_UP_DISPLAY
    BRA    END_GAME

GAME_LOOP:
    MOVE.L 4(SP), D1      
    MOVE.L 8(SP), D0      

    CMP    D0, D1
    BEQ    DAMAGE
    BRA    NO_DAMAGE

DAMAGE:
    MOVEA.L 12(SP), A1     
    SUB.B  #10, (A1)
    
NO_DAMAGE:
    RTS

HEADS_UP_DISPLAY:
    MOVE.B HEALTH, D1
    MOVE.B #3, D0         
    TRAP   #15
    RTS

END_GAME:
    MOVE.B #9, D0         
    TRAP   #15

HEALTH: DC.B 100

    END    START 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
