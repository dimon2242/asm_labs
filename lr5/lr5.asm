

EXTERN getChar
EXTERN finish
EXTERN putChar
EXTERN outputNumber
EXTERN inputNumber
;EXTERN calc
;EXTERN getR

global _start

section .bss
	a resd 1
	b resd 1
	c resd 1
	disc resd 1
	buff resw 1
	result resd 1
	sign resd 1
	rootbuf resq 1

section .data
	err_msg db "No solutions", 12
	len equ $-err_msg

section .text
_start:
	mov dword [sign], -1
	call inputNumber
	;push eax
	mov [a], eax
	call inputNumber
	;push eax
	mov [b], eax
	call inputNumber
	;push eax
	mov [c], eax
	mov word [buff], 4

	;push dword [a]
	;push dword [b]
	;push dword [c]


	;;;;;;;;;;;;;;;;
	;mov byte [ebp-14], 4

	finit
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

	jl short .noSolution

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
	fxch st1
	;;; End first root
	;;; Second root
	fild dword [b]
	faddp
	fild word [buff]
	fild dword [a]
	fmulp
	fdivp ; WTF?

	mov word [buff], 0
	fild word [buff]
	fxch
	fsubr st1
	fxch st2
	fsubp st1
	;fxch st1

	fist dword [result]
	;;; |x1|
	;;; |x2|
	
	;;;;;;;;;;;;;;;;;;;


	;mov eax, [b]
	mov eax, [result]
	;imul dword [sign]

	jmp short .outNumber

	;test eax, eax
	;jns .positive

	;neg eax
	;push minus
	;call putChar

	;add esp, 4
	;jmp short .positive

.noSolution:
	mov eax, 4
	mov ebx, 1
	mov ecx, err_msg
	mov edx, len
	int 80h
	call finish
	jmp short _end

.outNumber:
	;mov eax, [b]
	;neg eax
	push eax
	call outputNumber
	add esp, 4

	jmp short _end
	
_end:
	call finish