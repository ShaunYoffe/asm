IDEAL
MODEL small
P386
STACK 100h
DATASEG
	string DB "hello$"
	afterstring DB (?)
	pre DB "# $"
	post DB " #$"
CODESEG

start:
	mov ax, @data
	mov ds, ax
	mov cx, offset afterstring
	sub cx, offset string
	add cx, 3
	mov bx, cx ; length -> bx

	mov dl, '#'

hash1:
	mov ah, 02h
	int 21h				;####
	loop hash1

	mov dl, 10
	mov ah, 02h ;\n
	int 21h


	mov dx, offset pre
	mov ah, 09h				; # ...
	int 21h


	mov dx, offset string
	mov ah, 09h				;string
	int 21h

	mov dx, offset post
	mov ah, 09h				; ... #
	int 21h

	xor dx, dx
	mov dl, 10
	mov ah, 02h ;\n
	int 21h

	mov cx, bx
	mov dl, '#'
hash2:
	mov ah, 02h
	int 21h				;####
	loop hash2



exit:
	mov ax, 4c00h     
	int 21h
END start  


; #########
; # hello #
; #########