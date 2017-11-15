global inputNumber

EXTERN getChar
EXTERN finish

section .data
	err_msg db "ERROR"
	len equ $-err_msg

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
	;GETCHAR
	;======
	;push eax
	;push ebx
	;push ecx
	;push edx

	;mov eax, 3
	;mov ebx, 0
	;lea ecx, [ebp-4]
	;mov edx, 1
	;int 80h

	call getChar

	;pop edx
	;pop ecx
	;pop ebx
	;pop eax
	;=====
	;mov eax, [ebp-4]

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
	mov eax, 4
	mov ebx, 1
	mov ecx, err_msg
	mov edx, len
	int 80h
	call finish