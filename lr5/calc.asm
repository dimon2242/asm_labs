GLOBAL calc

calc:
	push ebp
	mov ebp, esp
	sub esp, 14 ; 1) Disctiminant; 2) first root; 3) second root; 4) other :)

	pushad
	pushfd

	mov byte [ebp-14], 4

	finit

	fild dword [ebp+12] ; b
	fmul st0
	fild dword [ebp-14]
	fild dword [ebp+8] ; c
	fmulp st1
	fild dword [ebp+16] ; a
	fmulp st1
	fsubr st1

	fsqrt

	mov byte [ebp-14], 2
	fild dword [ebp+12] ; b
	fsub st1
	fild word [ebp-14] ; 2
	fild dword [ebp+16] ; a
	fmul st1
	fxch st1
	fxch st2
	fdivrp st1
	;; st(2) is discriminant

	fxch st2

	fild dword [ebp+12] ; b
	fadd st1
	fild dword [ebp+16] ; a
	fmul st3
	fxch st1
	fdivrp st1

	fxch st1
	fxch st3

	popfd
	popad

	fxch st1
	fistp dword [ebp-8]

	;fist dword [ebp-8]
	mov eax, [ebp-8]
	neg eax

	mov esp, ebp
	pop ebp
	ret