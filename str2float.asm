IDEAL
MODEL small
P386
STACK 100h
DATASEG
	max DB 255
	count DB (?)
	buffer DB 255 dup (?)
	tens DW 1, 10, 100, 1000, 10000
CODESEG

	; input: di = offset of leftmost digit in string
	; input: cx = number of digits to convert (0-5)
	; destroys ax, bx, cx, si, di
	; output: dx = value
	proc str2int
		add di, cx
		dec di
		mov bx, cx
		add bx, cx
		toval:
			xor ah, ah
			mov al, [byte ds:di]
			sub al, '0'

			mov si, offset tens
			sub si, cx
			sub si, cx
			push dx
			mul [word bx + si]
			pop dx
			add dx, ax

			dec di
		loop toval
		ret
	endp

	; input: bx = offset of string start
	; output: si = offset of dot INSIDE string offset
	proc finddot
		xor si, si
		check:
			cmp [byte bx + si], '.'
			je found
			inc si
			jmp check
		found:
		ret
	endp
start:
	mov ax, @data
	mov ds, ax

	mov dx, offset max
	mov ah, 0Ah
	int 21h

	mov bx, offset buffer
	call finddot          ; buffer + si = dot offset
	mov di, offset buffer
	mov cx, si
	push cx

	call str2int
	pop cx
	mov di, offset buffer 
exit:
	mov ax, 4c00h     
	int 21h
END start  