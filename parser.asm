IDEAL
MODEL small
P386
STACK 100h
DATASEG
	max DB 255
	count DB (?)
	buffer DB 255 dup (?)
	
CODESEG

start:
	mov ax, @data
	mov ds, ax

	mov dx, offset max
	mov ah, 0Ah
	int 21h
exit:
	mov ax, 4c00h     
	int 21h
END start  