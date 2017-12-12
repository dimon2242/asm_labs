global outputNumber

EXTERN putChar

section .data
	minus dd '-'
	dot dd '.'
	ent dd 10

outputNumber:
	push ebp
	mov ebp, esp
	sub esp, 28 ; 0-8 for symbols;
	;;; 1 root: 8-12 dig; 12-16 - frac
	;;; 2 root: 16-20 dig; 20-24 - frac
	;;; ebx - counter
	;;; 24-28 - other
	pushad
	pushfd

	mov ecx, 10
	;mov word [ebp-26], 0
	;inc word [ebp-26]
	mov esi, ebp
	mov dword [ebp], 1000


	sub esp, 2
	fstcw [esp]
	or word [esp], 0000110000000000b
	fldcw [esp]
	add esp, 2

	mov [ebp-28], dword 1000


	mov edi, 0
	lea ebx, [ebp-16]
.outputReal:
	inc edi
;;;;;;
	fld dword [ebp+4+edi*4]
	ftst
	fstsw ax
	sahf
	fist dword [ebx+4] ; dig of first root
	fild dword [ebx+4] ; too
	fsubp st1
	fild dword [ebp-28]
	fxch st1
	fmul st1
	
	fistp dword [ebx] ; fraction of first root
	fxch ; change pos 1000 and next root

;;;;;;
	mov eax, [ebx+4]
	jae short .while
	mov eax, [ebx]
	neg eax
	mov dword [ebx], eax
	mov eax, [ebx+4]

	neg eax
	push minus
	call putChar
	add esp, 4
	jmp short .while

.while:
	xor edx, edx
	div ecx
	dec esi
	mov [esi], dl
	test eax, eax
	je short .print
	jmp short .while


.print:
	cmp esi, ebp
	je .outputFrac
	add [esi], byte '0'
	push esi
	call putChar
	add esp, 4
	inc esi
	jmp short .print

.outputFrac:
	push dot
	call putChar
	add esp, 4
	mov esi, ebp
	mov eax, [ebx]
	push edi
	xor edi, edi

.whileFrac:
	inc edi
	xor edx, edx
	div ecx
	dec esi
	mov [esi], dl
	cmp edi, 3
	je short .printFrac
	jmp short .whileFrac

.printFrac:
	cmp esi, ebp
	je .retFrac
	add [esi], byte '0'
	push esi
	call putChar
	add esp, 4
	inc esi
	jmp short .printFrac


.retFrac:
	pop edi
	cmp edi, 2
	jz .return

	mov eax, 10
	push ent
	call putChar
	add esp, 4

	sub ebx, 8
	jmp .outputReal



.return:
	popfd
	popad

	mov esp, ebp
	pop ebp
	ret