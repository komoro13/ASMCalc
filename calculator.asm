section .data

msg1: db 'Calculator in x86 Assembly language', 0xA , 'Choose a process by pressing the right keys', 0xA, '1 Addition', 0xA, '2 Subtraction', 0xA, '3 Multiplication', 0xA, '4 Division'
msg1_len: equ $- msg1


section .bss


section .text
global _start

_start:

mov eax, 4
mov ebx, 1
mov ecx, msg1
mov edx, msg1_len
int 80h

mov eax, 1
mov ebx, 0
int 80h
