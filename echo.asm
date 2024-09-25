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

	mov bl, [count] ;count -> dl
	mov [byte offset buffer + bx], '$' ;CR = $

	mov cx, 5
print:
	mov dx, offset buffer
	mov ah, 09h
	int 21h			;print string

	mov dl, 10
	mov ah, 02h ;\n
	int 21h

	loop print


exit:
	mov ax, 4c00h     
	int 21h
END start  