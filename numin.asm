IDEAL
MODEL small
P386
STACK 100h
DATASEG
	max DB 255
	count DB (?)
	buffer DB 255 dup (?)
	tens DW 1, 10, 100, 1000, 10000
	value DW 0
CODESEG
start:
	mov ax, @data
	mov ds, ax

	mov dx, offset max
	mov ah, 0Ah
	int 21h

	xor ch, ch

	mov cl, [byte count]
	mov bx, offset buffer
	add bx, cx
	dec bx
	
toval:
	xor ah, ah
	mov al, [byte bx]
	sub al, '0'

	mov si, offset tens + 8 ; ptr 10,000
	sub si, cx
	sub si, cx

	mul [word si]
	add [word value], ax

	dec bx
	loop toval





exit:
	mov ax, 4c00h     
	int 21h
END start  
