

EXTERN getChar
EXTERN finish
EXTERN putChar
EXTERN outputNumber
EXTERN inputNumber

global _start

section .bss
	a resd 1
	b resd 1
	c resd 1
	disc resd 1
	buff resw 1
	result resd 1
	;sign resd 1
	;rootbuf resq 1
	;hmm resd 1

section .data
	err_msg db "No solutions"
	len equ $-err_msg
	err_msg_no_qeq db "Not quadratic equal"
	len_nqe equ $-err_msg_no_qeq

section .text
_start:
	call inputNumber
	mov [a], eax
	call inputNumber
	mov [b], eax
	call inputNumber
	mov [c], eax
	mov word [buff], 4

	;mov dword [hmm], 1000

	finit
	fild dword [a]
	ftst
	fstsw ax
	sahf
	je near .notQEq
	ffree

	;;; Discriminant
	fild dword [b]
	fmul st0
	fild word [buff]
	fild dword [a]
	fmulp st1
	fild dword [c]
	fmulp st1
	fsubr st1

	fist dword [disc]
	mov eax, [disc]

	test eax, eax
	jl near .noSolution

	fsqrt

	;;; End discriminant
	;;; Start Roots
	;;; First root
	fild dword [b]
	fsub st1
	mov word [buff], 2
	fild word [buff]
	fild dword [a]
	fmulp st1
	fdivp st1
	;fild dword [hmm]
	;fmulp
	;fistp dword [result]
	;fild dword [result]
	;fild dword [hmm]
	;fdivp


	fxch st1

	;;; End first root
	;;; Second root
	fild dword [b]
	faddp
	fild word [buff]
	fild dword [a]
	fmulp
	fdivp
	;fild dword [hmm]
	;fmulp
	;fistp dword [result]
	;fild dword [result]
	;fild dword [hmm]
	;fdivp
	;;; End second

	mov word [buff], 0
	fild word [buff]
	fxch
	fsubr st1
	fxch st2
	fsubp st1

	fstp dword [result]
	push dword [result]
	fstp dword [result]
	push dword [result]
	;;; |x1|
	;;; |x2|
	
	jmp short .outNumber

.notQEq:
	mov eax, 4
	mov ebx, 1
	mov ecx, err_msg_no_qeq
	mov edx, len_nqe
	int 80h
	call finish
	jmp short _end

.noSolution:
	mov eax, 4
	mov ebx, 1
	mov ecx, err_msg
	mov edx, len
	int 80h
	call finish
	jmp short _end

.outNumber:
	call outputNumber
	add esp, 8

	jmp short _end
	
_end:
	call finish