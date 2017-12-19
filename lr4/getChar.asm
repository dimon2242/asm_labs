global getChar

getChar:
	push ebp
	mov ebp, esp
	sub esp, 4

	push ebx
	push ecx
	push edx

	mov eax, 3
	mov ebx, 0
	lea ecx, [ebp-4] ; вычисляем эффективный адрес и помещаем его в ecx (т.е. адрес ebp-4)
	mov edx, 1
	int 80h

	mov eax, [ebp-4]

	pop edx
	pop ecx
	pop ebx

	mov esp, ebp
	pop ebp
	ret