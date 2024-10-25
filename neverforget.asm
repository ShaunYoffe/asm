; scrapped idea
IDEAL
MODEL small
P386
STACK 100h
DATASEG
	tally DW 0
	anysize DW 2048 dup (0) ;SIZE:DATADATADATADATADATA:SIZE:DATADATA:...
CODESEG
	; input: bx = size (in words)
	; output: di = address of allocated region (in ds)
	proc remember
		xor di, di
		cmp [word offset anysize + di], bx
		jae found

		; SIZE NEXT (BX WORDS) SIZE NEXT

		found:
			; lol, i wish
			mov [word offset anysize + di + 2 + 2*bx + 2], [word offset anysize + di] - bx
			mov [word offset anysize + di + 2 + 2*bx + 2 + 2], [word offset anysize + di + 2]
			ret
	endp
start:
	mov ax, @data
	mov ds, ax
	mov [word offset anysize], 2048

exit:
	mov ax, 4c00h     
	int 21h
END start  