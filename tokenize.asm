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

	tokencount DB 0Dh
	tokens DW 255 dup (?)

	floatcount DB 0
	floatstore DQ 256 dup (?)
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

	; input: bx = string start offset
	; input di = offset into tokens buffer to write to
	; input cl = length
	; destroys: 
	; output: tokens
	proc tokenize
		xor ch, ch
		mov bx, bx
		xor dh, dh
		loopoverstring:
			
			add bl, ch
			adc bx, 0
			mov dl, [byte si]

			cmp dl, "+"
			je symbol
			cmp dl, "-"
			je symbol
			cmp dl, "*"
			je symbol
			cmp dl, "/"
			je symbol
			cmp dl, "^"
			je symbol
			cmp dl, "("
			je symbol
			cmp dl, ")"
			je symbol

			jmp number

			symbol:
				xchg bx, si
				cmp [byte si], "x"
				xchg si, bx
				


				number:
		cmp ch, cl
		jne loopoverstring
		ret
	endp
start:
	mov ax, @data
	mov ds, ax

	mov dx, offset max
	mov ah, 0Ah
	int 21h

	mov cl, [byte offset count]
	mov si, offset buffer
	mov di, offset tokens
	mov [byte offset count], 0Dh
	call tokenize
	; fstp [qword offset floatstore + 8]
exit:
	mov ax, 4c00h     
	int 21h
END start  

; token template
; type : value

; example:
; 10000001:2D (symbol:minus) S=1 P=0
; 00000001:02 (value:offset into floatstore) S=0 P=0
; 10000000:10000000 (x:x)	S=1 P=1
