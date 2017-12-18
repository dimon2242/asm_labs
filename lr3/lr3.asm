%include "stud_io.inc"
global _start

section .text
_start:
	
	call inputNumber
	mov esi, eax
	call inputNumber
	add eax, esi
	push eax
	call outputNumber
	add esp, 4
	jmp _end
	
inputNumber:
	push ebp ; пролог
	mov ebp, esp
	sub esp, 4 ; всё ещё пролог. Тут выделяем 4 байта под локальные данные

	push ebx ; сохраняем регистры, которые будут использоваться в этой подпрограмме
	push ecx ; то же самое
	push edx ; то же самое
	pushfd ; сохраняем состояние всех флагов

	mov edx, 0
	mov ecx, 10
	mov ebx, 0
	mov eax, 0

.while:
	GETCHAR
	cmp eax, 10
	je .return
	cmp eax, " "
	je .return
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
	mov [ebp-4], edx ; храним в локальной памяти
	jmp .while
.return:
	mov eax, [ebp-4] ; возвращаем из подпрграммы значение через eax

	popfd ; восстанавливаем флаги
	pop edx ; восстанавливаем регистры
	pop ecx ; тоже
	pop ebx ; тоже

	mov esp, ebp ; возвращаем указатель на вершину стека (эпилог)
	pop ebp ; возвращаем базовый указатель
	ret ; выходим в точку вызова
	
.err:
	PRINT "ERROR"
	jmp _end

outputNumber:
	push ebp
	mov ebp, esp
	sub esp, 8

	pushad ; сохраняем dword регистры
	pushfd ; сохраняем флаги

	mov ecx, 10

	mov eax, [ebp+8] ; обращаемся к параметрам, переданным подпрограмме через стек
	mov esi, ebp

.while:
	mov edx, 0
	div ecx
	dec esi
	mov [esi], dl
	cmp eax, 0
	je .print
	
	jmp .while

.print:
	cmp esi, ebp
	je .return
	add [esi], byte '0'
	PUTCHAR byte [esi]
	inc esi
	jmp .print

.return:
	popfd
	popad

	mov esp, ebp
	pop ebp
	ret

_end:
	PUTCHAR 10
	FINISH