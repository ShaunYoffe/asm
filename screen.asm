IDEAL
MODEL small
P386
STACK 100h
DATASEG
LEN equ 100
CODESEG
;320x200
start:
	mov ax, 13h
	int 10h
	mov ax, 0A000h
	mov ds, ax
	xor ax, ax
	mov bx, 3210d



outer:
	mov cx, LEN
right:
	inc bx
	mov [byte bx], 0Fh
	loop right
	
	inc ax
	cmp ax, LEN
	jae l

	add bx, 320
	mov cx, LEN
left:
	mov [byte bx], 0Fh
	dec bx
	loop left

	inc ax
	cmp ax, LEN
	jae l

	add bx, 320
	jmp outer




l:
	jmp l
exit:
	mov ax, 4c00h     
	int 21h
END start  