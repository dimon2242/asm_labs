GLOBAL inputReal

EXTERN getChar
EXTERN finish
EXTERN outputNumber

section .data
	err_msg db "ERROR"
	len equ $-err_msg

inputReal:
	push ebp
	mov ebp, esp
	sub esp, 16 ;4) знак; 8) порядок с десяткой; 12) целая часть; 16) дробная часть;
	
	push ebx
	push ecx
	push edx
	push esi
	pushfd

	xor edx, edx
	mov ecx, 10
	xor ebx, ebx
	xor eax, eax

	mov byte [ebp-8], 10
	mov byte [ebp-4], 1

.while:
	call getChar
	cmp eax, 10
	je .return
	cmp eax, ' '
	je .return
	cmp eax, '-'
	jnz short .afterNeg
	neg dword [ebp-4]
	jmp .while

.afterNeg:
	cmp eax, '.'
	jz .frac
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
	mov [ebp-12], edx
	jmp .while

.frac:
	xor esi, esi
	xor ebx, ebx
	xor eax, eax
	xor edx, edx
.whileFrac:
	call getChar
	cmp eax, 10
	je .prepareFrac
	cmp eax, " "
	je .prepareFrac
	cmp eax, '0'
	jl .err
	cmp eax, '9'
	jg .err
	inc esi
	mov ebx, eax
	sub ebx, '0'
	mov eax, edx
	mul ecx
	mov edx, eax
	add edx, ebx
	mov [ebp-16], edx
	jmp .whileFrac

.prepareFrac:
	finit
	fild dword [ebp-4]
	fild dword [ebp-8]
	fild dword [ebp-12]
	fild dword [ebp-16]

.whileLoc:
	test esi, esi
	jz .endDiv

	fdiv st2
	dec esi
	jmp .whileLoc

.endDiv:
	fadd st1
	fmulp st3
	fist dword [ebp-12]
	jmp .fracEnd

.return:
.end:
	mov eax, [ebp-12]
	mul dword [ebp-4]
	mov [ebp-12], eax
.fracEnd:
 	mov eax, [ebp-12]
 	popfd
	pop esi
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