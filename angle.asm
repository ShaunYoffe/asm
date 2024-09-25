IDEAL
MODEL small
P386
STACK 100h
DATASEG
v1 DD 3.5, 1.234
v2 DD -0.2, 1.8
factor DD 57.295779513
angle DD (?)
CODESEG

start:
	mov ax, @data
	mov ds, ax
	fld [v1+4]
	fld [v1]
	fpatan
	fld [v2+4]
	fld [v2]
	fpatan
	fsubp
	fabs
	fld [factor]
	fmulp
	fstp [angle]
exit:
	mov ax, 4c00h     
	int 21h
END start  