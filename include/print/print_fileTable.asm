print_fileTable:
	pusha
	;; Load file table string from memory location 0x1000
    mov si, file_header
    call printString

    xor cx, cx
    mov ax, 0x100
    mov es, ax
    xor bx, bx
    mov ah, 0x0e

    mov al, [ES:BX]

fileName_loop:
    mov al, [ES:BX]
    cmp al, 0
    je end_print_fileTable

    int 0x10
    cmp cx, 9
    je file_ext
    inc cx
    inc bx

    jmp fileName_loop

file_ext:
    mov cx, 3
    call print_blanks_loop

    inc bx
    mov al, [ES:BX]
    int 0x10
    inc bx
    mov al, [ES:BX]
    int 0x10
    inc bx
    mov al, [ES:BX]
    int 0x10

dir_entry_number:
    mov cx, 9
    call print_blanks_loop

    inc bx
    mov al, [ES:BX]
    call print_hex_as_ascii

start_sector_number:
    mov cx, 9
    call print_blanks_loop

    inc bx
    mov al, [ES:BX]
    call print_hex_as_ascii

file_size:
    mov cx, 14
    call print_blanks_loop

    inc bx
    mov al, [ES:BX]
    call print_hex_as_ascii
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10

    inc bx
    xor cx, cx
    jmp fileName_loop

end_print_fileTable:
	popa
	ret
