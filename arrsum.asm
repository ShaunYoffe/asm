IDEAL
MODEL small
P386
STACK 100h
DATASEG
	x DB 37, 43, 11, 23, 88, 66, 55, 33, 122, 123, 111, 43, 99
	after DB (?)
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov ax, 0
	mov bx, offset after
	mov cx, bx
	mov bx, offset x
	sub cx, bx
jump:
	cmp bx, cx
	ja exit
	mov dx, [word ptr bx]
	mov dh, 0
	add ax, dx
	inc bx
	jmp jump
exit:
	mov ax, 4c00h     
	int 21h
END start  