;; clear screen by writing to video memory

clear_screen_text_mode:
	pusha
	mov ax, 0b800h
	mov es, ax
	xor di, di

	mov ah, 17h
	mov al, ' '
	mov cx, 80*25

	rep stosw

	mov ah, 02h
	xor bh, bh
	xor dx, dx
	int 10h

	popa
	ret
