IDEAL
MODEL small
P386
STACK 100h
DATASEG
	arr DB 1, 2, 1, 3, 4, 2, 1, 0, 5, 6, 7, 1
	arrend DB (?)
	sortlen DW (?)
CODESEG

start:
	mov ax, @data
	mov ds, ax
	xor ax, ax

	mov cx, offset arrend
	sub cx, offset arr
	mov [sortlen], cx
	dec [sortlen]

	outer:
		mov bx, offset arr
		sort:
			mov al, [byte bx]
			cmp al, [byte bx+1]
			jae stay   ;if [n]>=[n+1]
			xchg al, [byte bx+1]
			mov [byte bx], al
			stay:
			inc bx
		cmp bx, [sortlen]
		jne sort
	loop outer




exit:
	mov ax, 4c00h     
	int 21h
END start  