%include "stud_io.inc"
global _start

section .bss
	result resb 10
	resultlen equ $-result

section .text
_start:
	mov edx, 0
	mov ecx, 10
	mov ebx, 0
	mov eax, 0
	mov esi, 0

_mark:
	GETCHAR
	cmp eax, 10; 10 - enter code
	je _addition
	cmp eax, " "
	je _copy
	cmp eax, '0'
	jl _err
	cmp eax, '9'
	jg _err
	mov ebx, eax
	sub ebx, '0'
	mov eax, edx
	mul ecx
	mov edx, eax
	add edx, ebx
	jmp _mark

_err:
	PRINT "ERROR"
	jmp _end

_copy:
	mov esi, edx
	mov edx, 0
	jmp _mark

_addition:
	add esi, edx
	mov eax, esi
	mov ebx, 0
	mov edx, eax
	jmp _calc

_calc:
	mov edx, 0
	div ecx
	mov [result + ebx], edx
	cmp eax, 0
	je _print
	cmp ebx, resultlen - 1
	jz _print
	inc ebx
	jmp _calc

_print:
	mov eax, [result + ebx]
	add byte [result + ebx], '0'
	PUTCHAR byte [result + ebx]
	cmp ebx, 0
	je _end
	dec ebx
	jmp _print

_end:
	PUTCHAR 10
	FINISH
