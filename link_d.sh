#!/bin/sh
nasm -f elf32  -g -o calculator.o calculator.asm && ld -m elf_i386  -o calculator calculator.o
