IDEAL
MODEL small
STACK 100h

DATASEG
	ten DW 10d
CODESEG

start:
	mov ax, @data
	mov ds, ax

	xor cx, cx
	mov ax, 1337

apart:
	xor dx, dx
	div [word ten]	; dx = ax % 10
	add dx, '0'
	push dx
	inc cl
	and ax, ax
	jnz apart


print:
	pop dx

	mov ah, 02h		
	int 21h			;print

	loop print



exit:
	mov ax, 4c00h
	int 21h
END start