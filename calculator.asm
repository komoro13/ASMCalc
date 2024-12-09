; **************************************************************************************
;  Calculator in 
;                 
;             ********    ********             ******       *******    *****       *****
;            **      **  **                  **** ****     ****  ****  *******    ******
;            **      **  **                 ****   ****     ****  **** ****  **  ** ****
;             ********   **                *************      ****     ****   ****  ****
;   \\  //    ********   *********        ***************  **  ****    ****         ****
;    \\//    **      **  **      **      ****         **** ****  ****  ****         ****
;    //\\    **      **  **      **      ****         ****  *********  ****         ****
;   //  \\    ********    ********       ****         ****    ****     ****         ****
;
; Author: Theodoros Bogiatzis
;


section .data

;This is the message displayed when the program starts
startMessage: db 'Calculator in x86 Assembly language', 0xA , 'Choose a process by pressing the right keys', 0xA, '1 Addition', 0xA, '2 Subtraction', 0xA, '3 Multiplication', 0xA,'4 Division',0xA,0x0
startMessage_len: equ $- startMessage

;Messages for each operation

addMessage:db 'Addition', 0xA, 0x0
addMessage_len: equ $- addMessage

subtractionMessage:db 'Subtraction', 0xA, 0x0
subtractionMessage_len: equ $- subtractionMessage

multiplicationMessage:db 'Multiplication', 0xA, 0x0
multiplicationMessage_len: equ $- multiplicationMessage

divisionMessage:db 'Division', 0xA,0xA, 0x0
divisionMessage_len: equ $- divisionMessage

enterFirstNumberMessage:db 0xA,0xA,0xA,'Enter a number: ', 0x0
enterFirstNumberMessage_len: equ $- enterFirstNumberMessage

enterSecondNumberMessage:db 'Enter another number: ', 0x0
enterSecondNumberMessage_len: equ $- enterSecondNumberMessage

resultMessage: db 'Result: ', 0x0
resultMessage_len: equ $- resultMessage

;Variables
section .bss

termios: resb 36

stdin_fd: equ 0
ICANON: equ 1<<1
ECHO: equ 1<<3
;we store the choice of the user here
chr: resb 1
;These variables are the numbers so we reserve 4 bytes each (1 doubleword)
num1: resd 1
num2: resd 1
result: resb 1

section .text

global _start
_start:
;Switching the canonical mode of the keyboard off so it does not wait for enter key 

main:
  ;Displaying the message when starting the program
  mov eax, 4 
  mov ebx, 1
  mov ecx, startMessage
  mov edx, startMessage_len
  int 80h
  
  ;setting canonical mode and echo off so the user can choose
  ;without pressing enter
  
  call echo_off
  call canonical_off 
  
  mov eax, 3
  mov ebx, 0
  mov ecx, chr
  mov edx, 1
  int 80h

  ;set canonical and echo back so the user can type normally	  
  call canonical_on
  call echo_on
  
  push num2
  push num1
  call get_numbers
  add esp, 8  

  push num2
  push num1
  
  call addition
  add esp, 8  
 
  push result
  call display_result  
  add esp, 1
  	
  ;clear eax
  xor eax, eax
  
  ;exit with code 0
  mov eax, 1
  mov ebx, 0
  int 80h

write_stdin_termios:
  push ebp
  mov ebp, esp
  mov eax, 36h
  mov ebx, stdin_fd
  mov ecx, 5402h
  mov edx, termios
  int 80h
  mov esp, ebp
  pop ebp
   ret

canonical_off:
  
  call read_stdin_termios
	
  ;clear canonical bit in local mode flags
  and dword [termios+12], ~ICANON

  call write_stdin_termios
  ret

;switching the echo off
echo_off:
  call read_stdin_termios
  ;clear echo bit in local mode flags
  and dword [termios+12], ~ECHO
  call write_stdin_termios
  ret

;canonical mode back on
canonical_on:
  call read_stdin_termios	
  ;set canonical bit in local mode flags
  or dword [termios+12], ICANON
  call write_stdin_termios
  ret

echo_on:
	call read_stdin_termios
	;set canonical bit in local mode flags
	or dword [termios+12], ECHO
	call write_stdin_termios
	ret

read_stdin_termios:
  push ebp 
  mov eax, 36h
  mov ebx, stdin_fd
  mov ecx, 5401h
  mov edx, termios
  int 80h		
  pop ebp
  ret

get_numbers:
  push ebp
  mov ebp, esp
  
  ;display first number message
  mov eax, 4
  mov ebx, 1
  mov ecx, enterFirstNumberMessage
  mov edx, enterFirstNumberMessage_len
  int 80h
 
  ;read first number
  mov eax, 3
  mov ebx, 0
  mov ecx, [esp + 8]
  mov edx, 4
  int 80h
  ;display second number message
  mov eax, 4
  mov ebx, 1
  mov ecx, enterSecondNumberMessage
  mov edx, enterSecondNumberMessage_len
  int 80h
  ;read second number
  mov eax, 3
  mov ebx, 0
  mov ecx, [esp + 12]
  mov edx, 4
  int 80h
  
  mov esp, ebp
  pop ebp
  ret
 
addition:
  
  push ebp
  mov ebp, esp
 
  
   
  ;store arguments to eax and ebx
  mov eax, [ebp + 8]
  ;convert char to int
  sub eax, '0' 
  mov ebx, [ebp + 12]    
  sub ebx, '0'  
     
  ;add the two numbers
  add eax, ebx
  add eax, '0'

  ;store the outcome to the result variable
  mov [result], eax
  
  mov esp, ebp
  pop ebp
  ret
  
display_result:
  push ebp
  mov ebp, esp
  
    
  mov eax, 4
  mov ebx, 1
  mov ecx, resultMessage
  mov edx, resultMessage_len
  int 80h 
    
  mov eax, 4
  mov ebx, 1
  mov ecx, result
  mov edx, 1
  int 80h
  
  mov esp, ebp
  pop ebp
  ret 


  
  
