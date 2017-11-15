%include "stud_io.inc"
global _start

section .text
_start:
	
	call inputNumber
	mov esi, eax
	call inputNumber
	add eax, esi
	push eax
	call outputNumber
	add esp, 4
	jmp _end
	
inputNumber:
	push ebp
	mov ebp, esp
	sub esp, 4

	push ebx
	push ecx
	push edx
	pushfd

	mov edx, 0
	mov ecx, 10
	mov ebx, 0
	mov eax, 0

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
	mov eax, [ebp-4]

	popfd
	pop edx
	pop ecx
	pop ebx

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
	pushfd

	mov ecx, 10

	mov eax, [ebp+8]
	mov esi, ebp

.while:
	mov edx, 0
	div ecx
	dec esi
	mov [esi], dl
	cmp eax, 0
	je .print
	
	jmp .while

.print:
	cmp esi, ebp
	je .return
	add [esi], byte '0'
	PUTCHAR byte [esi]
	inc esi
	jmp .print

.return:
	popfd
	popad

	mov esp, ebp
	pop ebp
	ret

_end:
	PUTCHAR 10
	FINISH