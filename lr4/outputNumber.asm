global outputNumber

EXTERN putChar

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
	;PUTCHAR byte [esi]
	;push dword [esi]
	;call outputNum
	;add esp, 4

	;mov eax, 4
	;mov ebx, 1
	;mov ecx, esi
	;mov edx, 1
	;int 80h
	push esi
	call putChar
	add esp, 4

	inc esi
	jmp .print

.return:
	popfd
	popad

	mov esp, ebp
	pop ebp
	ret