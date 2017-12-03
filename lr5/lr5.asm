

EXTERN getChar
EXTERN finish
EXTERN putChar
EXTERN outputNumber
EXTERN inputNumber
EXTERN calc
;EXTERN getR

global _start

section .data
	minus db "-", 1

section .text
_start:
	call inputNumber
	push eax
	call inputNumber
	push eax
	call inputNumber
	push eax
	;mov esi, eax
	;mov ebx, 0
	;push eax
	call calc
	add esp, 12
	test eax, 80h
	jz .positive
	neg eax

	push minus
	call putChar

	add esp, 4

.positive:
	push eax
	call outputNumber
	add esp, 4

	jmp short _end
	
_end:
	call finish