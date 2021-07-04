clear_screen:
	pusha
	mov ah, 0x06
	mov al, 0x00
	mov bh, 0x00
	xor cx, cx
	mov dh, 25
	mov dl, 80
	int 0x10
	popa
	ret