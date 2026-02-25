*-----------------------------------------------------------
* Title      : Practical 6, PART 1
* Written by : Ismael Charaf Megrini
* Date       : 25/02/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:         

       ; Move Trap Task to D0
       MOVE.B        #2, D0
       ; Interupt and Trap Task
       TRAP          #15

       LEA           MESSAGE, A1
       MOVE.B        #13, D0
       TRAP          #15

END_PROG:

       

    SIMHALT             ; halt simulator

MESSAGE: DC.B 'Trap Task Test', 0        


* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
