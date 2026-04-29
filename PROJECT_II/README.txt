Name: Ismael Charaf Megrini
Date: 4/29/2026
Description: A converted version of the original 68000 program. It takes two numbers, adds them, repeats 3 times, and prints the running sum

Project files:

 - sum_program.asm - the main program
 - adder.asm - the REGISTER_ADDER function on its own (for testing)
 - test_adder.c - test file with assert cases
 - Makefile - to compile and run

How to build and run:

You need NASM and GCC. On WSL or Ubuntu just install them with: 

 - sudo apt install nasm gcc make
 

 - make (to run the program)
 - make test (to run the tests)

How the conversion works: 

68000          x86_64                  What it does
-----          ------                  ------------
D3             r12                     running sum
D4             r13                     loop counter
D1, D2         rdi, rsi                function parameters
CLR.L          mov reg, 0              set register to 0
MOVE.L         mov                     copy a value
ADD.L          add                     add two values
BSR            call                    call a subroutine
RTS            ret                     return from subroutine
BNE            jne                     jump if not equal to zero
SUBQ.W #1      sub reg, 1              subtract 1
TRAP #15       call printf / scanf     system input/output
DC.B           db                      declare a byte/string
SIMHALT        ret                     end the program