#!/bin/bash
nasm -f elf -l getR.lst -o getR.o getR.asm && nasm -f elf -l getExpR.lst -o getExpR.o getExpR.asm && nasm -f elf -l putChar.lst -o putChar.o putChar.asm && nasm -f elf -l calc.lst -o calc.o calc.asm && nasm -f elf -l $1.lst -o $1.o $1.asm && nasm -f elf -l getChar.lst -o getChar.o getChar.asm && nasm -f elf -l finish.lst -o finish.o finish.asm && nasm -f elf -l outputNumber.lst -o outputNumber.o outputNumber.asm && ld -m elf_i386 -o $1 $1.o finish.o getChar.o putChar.o getR.o outputNumber.o calc.o getExpR.o


