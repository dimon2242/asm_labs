

EXTERN getChar
EXTERN finish
EXTERN putChar
EXTERN outputNumber
EXTERN inputNumber

global _start

section .text
_start:
	
	call inputNumber
	mov esi, eax
	call inputNumber
	add eax, esi
	mov ebx, 0
	push eax
	call outputNumber
	add esp, 4 ; убираем из стека аргумент, который передавали подпрограмме выше (push eax)

	jmp _end
	
_end:
	call finish