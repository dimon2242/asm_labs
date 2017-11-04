%include "stud_io.inc"
global _start

section .text
_start:
	mov edx, 0
	mov ecx, 10
	mov ebx, 0
	mov eax, 0
	mov esi, 0
	call inputNumber
	mov esi, eax
	call inputNumber
	add eax, esi
	mov ebx, 0
	push eax
	call outputNumber
	add esp, 4
	jmp _end
	
inputNumber:
	push ebp
	mov ebp, esp
	sub esp, 4

	pushad

.while:
	GETCHAR
	cmp eax, 10
	je .return
	cmp eax, " "
	je .return
	cmp eax, '0'
	jl .err
	cmp eax, '9'
	jg .err
	mov ebx, eax
	sub ebx, '0'
	mov eax, edx
	mul ecx
	mov edx, eax
	add edx, ebx
	mov [ebp-4], edx
	jmp .while
.return:
	popad
	mov eax, [ebp-4]

	mov esp, ebp
	pop ebp
	ret
	
.err:
	PRINT "ERROR"
	jmp _end

outputNumber:
	push ebp
	mov ebp, esp
	sub esp, 8

	pushad

	mov eax, [ebp+8]
	mov esi, ebp

.while:
	mov edx, 0
	div ecx
	dec esi
	mov byte [esi], dl
	cmp eax, 0
	je .print
	
	jmp .while

.print:
	cmp esi, ebp
	je .return
	add byte [esi], byte '0'
	PUTCHAR byte [esi]
	inc esi
	jmp .print

.return:
	popad
	mov esp, ebp
	pop ebp
	ret

_enderr:

	popad

	mov esp, ebp
	pop ebp
_end:
	PUTCHAR 10
	FINISH