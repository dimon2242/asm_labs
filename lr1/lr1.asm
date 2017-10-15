%include "stud_io.inc"
global _start;

section .text;
_start:
	mov edx, 0;
	mov ecx, 10;
	mov ebx, 0;
	mov eax, 0;
_mark:
	GETCHAR;
	mov ebx, eax;
	cmp ebx, '0';
	jl _print;
	cmp ebx, '9';
	jg _print;
	sub ebx, '0';
	mov eax, edx;
	mul ecx;
	mov edx, eax;
	add edx, ebx;
	jmp _mark;
	
_print:
	cmp edx, 0;
	jz _end;
	dec edx;
	PUTCHAR '*';
	jmp _print;
_end:
	PUTCHAR 10;
	FINISH;
