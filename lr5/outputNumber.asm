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
	xor edx, edx
	;mov edx, 0 ; replaced
	div ecx
	dec esi
	mov [esi], dl
	;cmp eax, 0 ; replaced
	test eax, eax
	je short .print
	
	jmp short .while

.print:
	cmp esi, ebp
	je .return
	add [esi], byte '0'
	push esi
	call putChar
	add esp, 4

	inc esi
	jmp short .print

.return:
	popfd
	popad

	mov esp, ebp
	pop ebp
	ret