;-------------------------------------------------------
; Title       : Parameter Passing Example for x86_64
; Written by  : Ismael Charaf Megrini (ported to x86_64)
; Date Created: April-28-2026
;-------------------------------------------------------
 
global main
extern printf
extern scanf
 
section .text
 
main:
    push    rbp                             ; set up stack frame
    mov     rbp, rsp
    sub     rsp, 32                         ; reserve space for local use
 
    mov     r12, 0                          ; Running sum initialized to 0
    mov     r13, 3                          ; Loop counter set to 3
 
GAME_LOOP:
    ; Input two numbers and add them using REGISTER_ADDER subroutine
    mov     rdi, PROMPT                     ; Load address of prompt string
    mov     rax, 0
    call    printf                          ; Display string
 
    mov     rdi, fmt_int                    ; Read integer input (No input validation - Vulnerable!)
    mov     rsi, num1
    mov     rax, 0
    call    scanf                           ; Read user input
    mov     r14, [num1]                     ; Store first number in r14
 
    mov     rdi, PROMPT
    mov     rax, 0
    call    printf                          ; Display prompt again (No validation - Vulnerable!)
 
    mov     rdi, fmt_int
    mov     rsi, num2
    mov     rax, 0
    call    scanf                           ; Read second number into num2 (No validation - Vulnerable!)
 
    mov     rdi, r14                        ; first number into rdi
    mov     rsi, [num2]                     ; second number into rsi
    call    REGISTER_ADDER                  ; Call subroutine (rax = rdi + rsi)
    add     r12, rax                        ; Add result to running sum
 
    mov     rdi, RESULT
    mov     rsi, rax
    mov     rax, 0
    call    printf
 
    call    NEW_LINE
 
    ; Decrement loop counter and repeat if not zero
    sub     r13, 1
    jne     GAME_LOOP
 
    ; Display final sum
    mov     rdi, FINAL_RESULT
    mov     rsi, r12
    mov     rax, 0
    call    printf
 
    mov     rsp, rbp
    pop     rbp
    mov     rax, 0
    ret                                     
 

; Add numbers using register parameters

REGISTER_ADDER:
    mov     rax, rdi
    add     rax, rsi                        ; Add rsi to rax
    ret                                     ; Return from subroutine
 

; Subroutine to display Carriage Return and Line Feed

NEW_LINE:
    mov     rdi, CRLF
    mov     rax, 0
    call    printf
    ret
 

; Strings

section .data
PROMPT          db  'Enter number: ', 0
RESULT          db  'The sum is: %ld', 0
FINAL_RESULT    db  'Final sum is: %ld', 10, 0
CRLF            db  10, 0
fmt_int         db  '%ld', 0
 
section .bss
num1            resq 1
num2            resq 1
 