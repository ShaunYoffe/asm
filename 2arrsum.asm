IDEAL
MODEL small
P386
STACK 100h
DATASEG
	arr1 DB 37, 43, 11, 23, 88, 66, 55, 33, 122, 123
	arr2 DB 65, 95, 32, 77, 11, 56, 5, 94, 132, 1
	arr3 DB 10 dup (?)
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov cx, 10
jump:
	xor ax, ax

	mov bx, offset arr1
	add bx, cx
	mov dl, [bx]
	add ax, dx

	mov bx, offset arr2
	add bx, cx
	mov dl, [bx]
	add ax, dx

	mov bx, offset arr3
	add bx, cx
	mov [bx], al

	loop jump
exit:
	mov ax, 4c00h     
	int 21h
END start  