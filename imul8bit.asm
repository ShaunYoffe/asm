IDEAL
MODEL small
P386
STACK 100h
DATASEG
CODESEG

start:
	mov al, 11010110b
	mov bl, 11000010b

	mov ch, al
	mov cl, bl ; cx = al:bl
	xor al, bl
	shr al, 7
	mov dl, al ; sign -> dl
	mov al, ch
	and al, 10000000b
	cmp al, 10000000b
	mov al, ch
	jne skipa ; |al|
	neg al
skipa:
	and bl, 10000000b
	cmp bl, 10000000b
	mov bl, cl
	jne skipb ; |bl|
	neg bl
skipb:
	mov cx, 0
jump:
	cmp bl, 0
	je cont
	add cx, ax
	dec bl
	jmp jump
cont:
	cmp dl, 0b
	je exit
	neg cx
exit:
	mov ax, cx
	mov ax, 4c00h
	int 21h
END start