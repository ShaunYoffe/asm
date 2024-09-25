IDEAL
MODEL small
P386
STACK 100h
DATASEG
CODESEG

proc evn
	mov bx, ax
	and bx, 1b
	xor bx, 1b
	ret
endp


start:
	mov ax, 1069
	call evn
exit:
	mov ax, 4c00h     
	int 21h
END start  