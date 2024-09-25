IDEAL
MODEL small
P386
STACK 100h
DATASEG
CODESEG

start:
	
exit:
	mov ax, 4c00h     
	int 21h
END start  