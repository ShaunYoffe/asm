IDEAL
MODEL small
P386
STACK 100h
DATASEG
v1 DD 3.5, 1.234
v2 DD -0.2, 1.8
dot DD (?)
CODESEG

start:
	mov ax, @data
	mov ds, ax
	fld [v1]
	fld [v2]
	fmulp
	fld [v1+4]
	fld [v2+4]
	fmulp
	faddp
	fstp [dot]
	fld [dot]
exit:
	mov ax, 4c00h     
	int 21h
END start  