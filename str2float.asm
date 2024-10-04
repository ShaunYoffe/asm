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
	; destroys: flags
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

	; input: bx = string offset
	; destroys: ax, bx, cx, dx, di, si
	; uses 2 FPU registers
	; output: st(0) = value
	proc str2float
		call finddot          ; offset buffer + si = dot address
		mov di, offset buffer
		mov cx, si
		push cx
		call str2int
		mov ax, dx
	
		pop cx                 ; preserve dot offset
		mov di, offset buffer 
		add di, cx             
		inc di                 ; di = dot address + 1
		neg cx
		add cl, [byte offset count]
		adc ch, 0
		dec cl                 ; cl = number of digits to convert
		xor dx, dx
		push cx
		push ax
		call str2int
		pop ax
		pop di
		add di, di
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
		ret
	endp
start:
	mov ax, @data
	mov ds, ax


	mov dx, offset max
	mov ah, 0Ah
	int 21h

	mov bx, offset buffer
	call str2float
exit:
	mov ax, 4c00h     
	int 21h
END start  