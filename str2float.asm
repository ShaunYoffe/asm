; TODO: if an integer is supplied, ie "21" (with no dot), finddot enters infinite loop and str2float outputs huge value


IDEAL
MODEL small
P386
STACK 100h
DATASEG
	max DB 255
	count DB (?)
	buffer DB 255 dup (?)
	tens DW 1, 10, 100, 1000, 10000
	FPUIN DD 0
	FPUOUT DD 0
CODESEG

	; input: di = offset of leftmost digit in string
	; input: cx = number of digits to convert (0-5)
	; destroys ax, bx, cx, si, di, flags
	; output: ADDS value to dx (dx = dx + value)
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
	; input: dl = length of string to convert (minimum 3)
	; destroys: flags, dh
	; output: si = offset of dot INSIDE string offset, FFFF if no dot was found
	proc finddot
		xor si, si
		xor dh, dh
		sub dl, 2
		check:
			cmp [byte bx + si], '.'
			je founddot

			cmp si, dx
			jae didntfinddot

			inc si
			jmp check

		didntfinddot:
		mov si, 0FFFFh
		founddot:
		add dl, 2
		ret
	endp

	; input: bx = string offset
	; input: dl = length to convert
	; destroys: ax, bx, cx, dx, di, si
	; uses 2 FPU registers
	; output: st(0) = value
	proc str2float
		xor dh, dh
		call finddot          ; offset buffer + si = dot address
		mov di, bx
		mov cx, si
		push dx
		push cx
		push bx

		cmp cx, 0FFFFh
		jne dotwasfound
		mov cx, dx

		dotwasfound:
		xor dx, dx
		call str2int
		mov ax, dx

		pop bx
		pop cx                 ; preserve dot offset
		pop dx                 ; preserve target length

		cmp cx, 0FFFFh
		jne isfloat
		mov [word offset FPUIN], ax
		fild [dword offset FPUIN]
		jmp dotdone

		isfloat:
		mov di, bx
		add di, cx             
		inc di                 ; di = dot address + 1
		neg cx
		add cx, dx
		dec cx                 ; cl = number of digits to convert
		xor dx, dx
		push cx
		push ax
		call str2int
		pop ax
		pop di					; di = number of digits to convert
		shl di, 1				; tens is words
		mov [word offset FPUIN], dx
		fild [word offset FPUIN]
		mov di, [tens + di]
		mov [word offset FPUIN], di
		fild [word offset FPUIN]
		fdivp st(1),st
		mov [word offset FPUIN], ax
		fild [dword offset FPUIN]
		fxch st(1)
		faddp st(1), st

		dotdone:
		ret
	endp

start:
	mov ax, @data
	mov ds, ax


	mov dx, offset max
	mov ah, 0Ah
	int 21h

	mov bx, offset buffer
	mov dl, [byte count]
	xor dh, dh
	call str2float
exit:
	mov ax, 4c00h     
	int 21h
END start  