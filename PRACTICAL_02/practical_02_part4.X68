*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  

    MOVE.B      #20,         D0
    MOVE.L      #2000,       D1
    MOVE.B      #100,        D2
    
    MOVE.L      #20,         $3000
    MOVE.L      #20,         $3010
    MOVE.L      #100,        $3020 
        
    MOVE.L      #10,         $3030  
    MOVE.W      #1002,       $3040
    MOVE.W      #1,          $3050 
    
    MOVE.B      #10,         $1000 
    MOVE.L      #21000,      $1010 
    MOVE.L      #1200,       $1020 
    
    MOVE.B      #20,         D3
    MOVE.W      #2000,       D4
    MOVE.B      #100,        D5
    
    MOVE.L      #20,         D6
    MOVE.W      #2000,       D7
    MOVE.B      #100,        $3100 


* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
