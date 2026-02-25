*-----------------------------------------------------------
* Program: Practical 06, PART 2
* Name: Ismael Charaf Megrini
* Description: 
*-----------------------------------------------------------

START   ORG     $1000

*-----------------------------------------------------------
* Displaying Strings (Trap 14 and 13)
*-----------------------------------------------------------
        LEA     MSG_START,A1    
        MOVE.B  #14,D0          
        TRAP    #15             

        LEA     MSG_PROMPT,A1   
        MOVE.B  #13,D0          
        TRAP    #15

*-----------------------------------------------------------
* Reading a String (Trap 2)
*-----------------------------------------------------------
        LEA     BUFFER,A1       
        MOVE.B  #2,D0           
        TRAP    #15             

*-----------------------------------------------------------
* Numerical Input and Output (Trap 4 and 3)
*-----------------------------------------------------------
        LEA     MSG_NUM,A1      
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.B  #4,D0          
        TRAP    #15

        MOVE.L  D1,D2           
        LEA     MSG_RESULT,A1   
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.L  D2,D1           
        MOVE.B  #3,D0         
        TRAP    #15

*-----------------------------------------------------------
* Adjusting Display and Color (Trap 21 and 11)
*-----------------------------------------------------------

        MOVE.L  #$0000FF00,D1   
        MOVE.B  #1,D2           
        MOVE.B  #21,D0          
        TRAP    #15

       
        MOVE.W  #$050A,D1       
        MOVE.B  #11,D0          
        TRAP    #15

        LEA     MSG_COLOR,A1
        MOVE.B  #13,D0
        TRAP    #15

*-----------------------------------------------------------
* Termination (Trap 9)
*-----------------------------------------------------------
        MOVE.B  #9,D0           
        TRAP    #15

*-----------------------------------------------------------
* DATA SECTION
*-----------------------------------------------------------
MSG_START   DC.B    '--- 68K TRAP DEMONSTRATION ---',0
MSG_PROMPT  DC.B    'Please enter your name: ',0
MSG_NUM     DC.B    'Enter an integer: ',0
MSG_RESULT  DC.B    'The number you typed was: ',0
MSG_COLOR   DC.B    'This text is in Bold Green at Row 5!',0
            DS.W    0           
BUFFER      DS.B    80         

        END     START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
