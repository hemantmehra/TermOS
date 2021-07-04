print_registers:
	pusha
        mov si, regString
        call printString
        call printHex          ; print DX

        mov byte [regString+2], 'a'
        call printString
        mov dx, ax
        call printHex          ; print AX

        mov byte [regString+2], 'b'
        call printString
        mov dx, bx
        call printHex          ; print BX

        mov byte [regString+2], 'c'
        call printString
        mov dx, cx
        call printHex          ; print CX

        mov word [regString+2], 'si'
        call printString
        mov dx, si
        call printHex          ; print SI

        mov byte [regString+2], 'd'
        call printString
        mov dx, di
        call printHex          ; print DI

        mov word [regString+2], 'cs'
        call printString
        mov dx, cs
        call printHex          ; print CS

        mov byte [regString+2], 'd'
        call printString
        mov dx, ds
        call printHex          ; print DS

        mov byte [regString+2], 'e'
        call printString
        mov dx, es
        call printHex          ; print ES

	mov byte [regString+2], 's'
        call printString
        mov dx, ss
        call printHex          ; print SS
	
	mov ah, 0Eh
	mov al, 0Ah
	int 0x10
	mov al, 0Dh
	int 0x10
	popa
        ret

        ;; Variables
regString:  db 0Ah,0Dh,'dx        ',0 ; hold string of current register name and memory address
