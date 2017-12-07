

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
	mult resw 1
	result resd 1
	sign resd 1

section .data
	minus db "-", 1

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
	mov word [mult], 4

	;push dword [a]
	;push dword [b]
	;push dword [c]


	;;;;;;;;;;;;;;;;
	;mov byte [ebp-14], 4

	finit
	;;; Discriminant
	fild dword [b]
	fmul st0
	fild word [mult]
	fild dword [a]
	fmulp st1
	fild dword [c]
	fmulp st1
	fsubr st1

	;fist dword [disc]

	fsqrt

	;;; End discriminant
	;;; Start Roots
	;;; First root
	fild dword [b]
	fsub st1
	mov word [mult], 2
	fild word [mult]
	fild dword [a]
	fmulp st1
	fdivrp st1
	fxch st1
	;;; End first root
	;;; Second root
	fild dword [b]
	faddp st1
	fild word [mult]
	fild dword [a]
	fmulp st1
	fdivrp st1
	fxch st1
	fist dword [result]
	;;; |x1|
	;;; |x2|
	
	;;;;;;;;;;;;;;;;;;;


	;mov eax, [b]
	mov eax, [result]
	imul dword [sign]

	test eax, eax
	jns .positive

	neg eax

	push minus
	call putChar

	add esp, 4
	jmp short .positive

.noSolution:
	jmp short _end

.positive:
	;mov eax, [b]
	;neg eax
	push eax
	call outputNumber
	add esp, 4

	jmp short _end
	
_end:
	call finish