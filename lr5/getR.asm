
GLOBAL inputNumber

EXTERN getChar
EXTERN finish
EXTERN outputNumber

section .data
	err_msg db "ERROR"
	len equ $-err_msg

inputNumber:
	push ebp
	mov ebp, esp
	sub esp, 16 ; 1) знак; 2) порядок с десяткой; 3) целая часть; 4) дробная часть;

	push ebx
	push ecx
	push edx
	pushfd

	xor edx, edx
	mov ecx, 10
	xor ebx, ebx
	xor eax, eax

	mov byte [ebp-8], 10

	mov byte [ebp-4], 1 ; Для положительного числа (смещение 4)

.while:

	call getChar

	cmp eax, 10
	je .return
	cmp eax, " "
	je .return
	cmp eax, "-"
	jnz .afterNegative
	mov byte [ebp-4], -1 ; Для отрицательного числа
	jmp .while
.afterNegative:
	cmp eax, "."
	jz .frac ; Если дошли до точки
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
	;mov [ebp-4], edx
	;sub edx, '0'
	mov [ebp-12], edx
	jmp .while

.frac:
	xor ecx, ecx
.whileFrac:
	;push ecx
	;mov ecx, 0
	call getChar
	cmp eax, 10
	je .prepareFrac
	cmp eax, " "
	je .prepareFrac
	cmp eax, '0'
	jl .err
	cmp eax, '9'
	jg .err
	inc ecx
	;mul [ebp-16]
	;add [ebp-20], eax
	sub eax, '0'
	mov [ebp-16], eax ; первая локальная переменная
	jmp .whileFrac

.prepareFrac:
	finit
	fild dword [ebp-8]
	fild dword [ebp-12]
	fild dword [ebp-16]
.whileLoc:
	
	test ecx, ecx
	jz .endDiv

	fdiv st2
	dec ecx
	jmp .whileLoc

.endDiv:
	fadd st1
	fist dword [ebp-12]
	;add al, byte [ebp-4] ; ????

.return:
.end:
	mov eax, [ebp-12]
	;mul dword [ebp-4]

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