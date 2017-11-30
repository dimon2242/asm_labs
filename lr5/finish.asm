global finish

section .data
	end_newline db 10

finish:
	mov eax, 4
	mov ebx, 1
	mov ecx, end_newline
	mov edx, 1
	int 80h

	mov eax, 1
	mov ebx, 0
	int 80h