#!/bin/bash
nasm -f elf -l $1.lst -o $1.o $1.asm && ld -m elf_i386 -o $1 $1.o
