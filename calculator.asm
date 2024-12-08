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

;User messages
section .data
msg1: db 'Calculator in x86 Assembly language', 0xA , 'Choose a process by pressing the right keys', 0xA, '1 Addition', 0xA, '2 Subtraction', 0xA, '3 Multiplication', 0xA, '4 Division'
msg1_len: equ $- msg1


test_msg: db'This message is in the test function',0xA,0x0
test_msg_len: equ $- msg1

;Variables
section .bss

termios: resb 36

stdin_fd: equ 0
ICANON: equ 1<<1
ECHO: equ 1<<3


section .text

global _start
_start:
;Switching the canonical mode of the keyboard off so it does not wait for enter key 

main:
  mov eax, 4 
  mov ebx, 1
  mov ecx, msg1
  mov edx, msg1_len
  int 80h
  
  
  call canonical_on 

  xor eax, eax



  ;mov ah, 0
  ;int 16h

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

