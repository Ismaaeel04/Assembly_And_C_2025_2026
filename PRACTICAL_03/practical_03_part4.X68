*-----------------------------------------------------------
* Title      : PRACTICAl 3, PART 4
* Written by : ISMAEL CHARAF MEGRINI 
* Date       : 26/01/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:      

    LEA PLAYER_HEALTH, A0
    LEA PLAYER_POINTS, A1
    LEA PLAYER_X, A2
    LEA PLAYER_Y, A3
   
    MOVE.B $100, (A0)
    MOVE.B $200, (A1)
    MOVE.W $300, (A2)
    MOVE.L $400, (A3)
    
    MOVE.L (A0), $100
    MOVE.W (A1), $200
    MOVE.B (A2), $300
    MOVE.W (A3), $400
 
           
   

    SIMHALT    

PLAYER_HEALTH               dc.l                      $100   
PLAYER_POINTS               dc.l                      $200
PLAYER_X                    dc.l                      $300
PLAYER_Y                    dc.l                      $400
BOSS_HEALTH                 dc.l                      $500
BOSS_X                      dc.l                      $600
BOSS_Y                      dc.l                      $700
PLAYER_DAMAGE               dc.l                      $800
BOSS_DAMAGE                 dc.l                      $900
PLAYER_SPECIAL_ATTACK       dc.l                      $1000
PLAYER_LEVEL                dc.l                      $1100
PLAYER_NAME                 dc.l                      $1200  


    END    START        
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
