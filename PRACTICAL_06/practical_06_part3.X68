*-----------------------------------------------------------
* Title      : Practical 6, PART 3
* Written by : Ismael Charaf Megrini
* Date       : 25/02/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  

    LEA $4000, A7
        
    MOVE.B #1, -(A7)
    MOVE.B #2, -(A7)
    MOVE.B #3, -(A7)
    MOVE.B #4, -(A7)
    
    MOVE.B (A7)+, D1
    MOVE.B (A7)+, D1
    MOVE.B (A7)+, D1
    MOVE.B (A7)+, D1


    SIMHALT             


    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
