IDEAL
MODEL small
P386
STACK 100h
DATASEG
	chars DB "0123456789ABCDEF"
CODESEG

start:
	mov ax, @data
	mov ds, ax

	mov ax, 016B7h
	mov bx, ax     ;input -> dx
	mov cx, 0

print:
	mov si, bx       ;input -> si

	mov ax, 0F000h
	shr ax, cl
	and si, ax         ;mask

	mov ch, 12
	sub ch, cl

	xchg ch, cl

	shr si, cl

	xchg ch, cl

	mov dl, [offset chars + si]
	mov ah, 02h      
	int 21h	


	add cl, 4
	cmp cl, 12
	jna print


	; mov dx, cx
	; and dx, 0F000h
	; shr dx, 12
	; add dx, dx
	; add dx, offset chars
	; mov ah, 09h
	; int 21h


	; mov dx, cx
	; and dx, 0F00h
	; shr dx, 8
	; add dx, dx
	; add dx, offset chars
	; mov ah, 09h
	; int 21h



	; mov dx, cx
	; and dx, 00F0h
	; shr dx, 4
	; add dx, dx
	; add dx, offset chars
	; mov ah, 09h
	; int 21h


	; mov dx, cx
	; and dx, 000Fh
	; add dx, dx
	; add dx, offset chars
	; mov ah, 09h
	; int 21h





	; mov dx, offset post
	; mov ah, 09h	          ;string
	; int 21h

	; mov dl, '#'
	; mov ah, 02h      ; char
	; int 21h	


exit:
	mov ax, 4c00h     
	int 21h
END start  



