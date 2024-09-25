IDEAL
MODEL small
P386
STACK 100h
DATASEG
CODESEG

; IN ax
; OUT bl
proc cbs
	xor bl, bl

	lp:
	and ax, ax
	jz done
	
	mov cx, ax
	dec cx
	and ax, cx
	inc bl

	jmp lp

	done:
	ret
endp

start:
	mov ax, 0b
	call cbs

exit:
	mov ax, 4c00h     
	int 21h
END start  