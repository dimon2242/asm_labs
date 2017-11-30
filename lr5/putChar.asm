global putChar

putChar:
	push ebp
	mov ebp, esp
	pushad

	mov eax, 4
	mov ebx, 1
	mov ecx, [ebp + 8]
	mov edx, 1
	int 80h

	popad
	mov esp, ebp
	pop ebp
	ret

