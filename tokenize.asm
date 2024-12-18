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

	tokencount DB 0
	tokens DW 255 dup (0)

	floatcount DB 0
	floats DQ 256 dup (0)
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

	; input: dx = token word
	; output = adds token to tokens buffer
	; destroys: bx
	proc addtoken
		xor bh, bh
		mov bl, [tokencount]
		shl bx, 1
		add bx, offset tokens
		mov [word bx], dx
		inc [tokencount]
		ret
	endp

	; input: si = string (0Dh terminated) start pointer
	; destroys: ax, bx, cx, dx, si, di
	; output: tokens
	proc tokenize
		cmp [byte si], 0Dh
		jne notover
		ret                ; base case, string IS terminator

		notover:
		mov di, si
		findsymbol:
			cmp [byte di], 0Dh ; in case string has no symbols, ie function is a constant / identity
			je symbolfound     ; idk man
			cmp [byte di], "+"
			je symbolfound
			cmp [byte di], "-"
			je symbolfound
			cmp [byte di], "*"
			je symbolfound
			cmp [byte di], "/"
			je symbolfound
			cmp [byte di], "^"
			je symbolfound


			inc di
		jmp findsymbol

		symbolfound:
			cmp di, si
			je addsymbol

			cmp [byte si], "x"
			jne number
			x:
				mov dx, 1000000010000000b    ; code for x
				call addtoken
				jmp addsymbol

			number:
				mov dx, di  ;si pointing at start of number
				sub dx, si  ;di pointing at symbol
				mov bx, si

				push di
				call str2float  ;does not support ints lol
				pop di

				xor bh, bh
				mov bl, [floatcount]
				shl bx, 3
				add bx, offset floats
				fstp [qword bx]
				inc [floatcount]

				sub bx, offset floats
				shr bx, 3
				mov dl, bl           ; dl = offset into floats buffer (/8, each float is qword)
				mov dh, 00000001b	 ; code for value
				call addtoken


			addsymbol:  ;+-*/^
				cmp [byte di], 0Dh
				je nomore
				mov dh, 10000001b
				mov dl, [byte di]
				call addtoken


		mov si, di
		inc si
		call tokenize
		nomore:
		ret
	endp
start:
	mov ax, @data
	mov ds, ax

	mov dx, offset max
	mov ah, 0Ah
	int 21h

	mov si, offset buffer
	call tokenize

exit:
	mov ax, 4c00h
	int 21h
END start  

; token template
; type : value

; example:
; 10000001:2D (symbol:minus) S=1 P=0
; 00000001:02 (value:offset into floats) S=0 P=0
; 10000000:10000000 (x:x)	S=1 P=1
