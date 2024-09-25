IDEAL
MODEL small
P386
STACK 100h
DATASEG
CODESEG

start:
	mov ax, 1001011010010011b
	mov bx, 0000000000100110b
	and bx, bx
	jns jump
	neg ax
	neg bx
jump:
	cmp bx, 0
	je exit
	add cx, ax
	adc dx, 0FFFFh ;AAAAAAAAAAAAAAA
	dec bx
	jmp jump
exit:
	mov ax, cx
	mov ax, 4c00h
	int 21h
END start