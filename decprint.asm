IDEAL
MODEL small
P486
STACK 100h

DATASEG

	ten DW 10d
	flag DW 0
CODESEG

start:
	mov ax, @data
	mov ds, ax

	mov ax, 08060


	
	mov cx, ax     ;val -> cx
	mov bx, 10000d

lp:
	mov ax, cx
	
	xor dx, dx
	div bx		; ax /= 10^...
	xor dx, dx
	div [word ten]	; dx = ax % 10

	mov ax, bx   
	mov bx, dx 
	xor dx, dx		; ax <- bx <- dx <- 0
	div [word ten]
	mov dx, bx
	mov bx, ax

	xchg dx, [word flag]
	or dx, [word flag]
	jz skip						; trailing zero check
	xchg dx, [word flag]
	mov [word flag], 0FFFFh

	add dx, '0'
	mov ah, 02h					; print
	int 21h

skip:
	cmp bx, 1
	jae lp


exit:
	mov ax, 4c00h
	int 21h
END start