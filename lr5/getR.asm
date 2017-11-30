
getR:
	global inputNumber

EXTERN getChar
EXTERN finish
EXTERN putChar

section .data
	err_msg db "ERROR"
	len equ $-err_msg

inputNumber:
	push ebp
	mov ebp, esp
	sub esp, 8

	push ebx
	push ecx
	push edx
	pushfd

	mov edx, 0
	mov ecx, 10
	mov ebx, 0
	mov eax, 0

	mov byte [ebp-8], 1 ; Для положительного числа (смещение 8) для второй локальной var.

.while:

	call getChar

	cmp eax, 10
	je .return
	cmp eax, " "
	je .return
	cmp eax, "-"
	jnz .afterNegative
	mov byte [ebp-8], -1 ; Для отрицательного числа
.afterNegative
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

	mul 
	
	ret

.err:
	mov eax, 4
	mov ebx, 1
	mov ecx, err_msg
	mov edx, len
	int 80h
	call finish