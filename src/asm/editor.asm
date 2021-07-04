;; text editor

reset_editor:
	call resetTextScreen

	xor cx, cx
	mov di, hex_code

get_next_hex_char:
	xor ax, ax
	int 0x16
	mov ah, 0x0E
	cmp al, endInp
	je execute_input
	cmp al, endPgm
	je end_editor
	int 0x10
	call ascii_to_hex
	inc cx
	cmp cx, 2
	je put_hex_byte
	mov [hex_byte], al

return_from_hex: jmp get_next_hex_char

execute_input:
	jmp hex_code
	jmp reset_editor

put_hex_byte:
	rol byte [hex_byte], 4
	or byte [hex_byte], al
	mov al, [hex_byte]
	mov [di], al
	inc di
	xor cx, cx
	mov al, ' '
	int 0x10
	jmp return_from_hex

ascii_to_hex:
	cmp al, '9'
	jle get_hex_num
	sub al, 0x37
return_from_hex_num:
	ret

get_hex_num:
	sub al, 0x30
	jmp return_from_hex_num

end_editor:
	mov ax, 0x2000
	mov es, ax
	xor bx, bx

	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	jmp 0x2000:0x0000

%include "../src/screen/resetTextScreen.asm"
%include "../src/print/print_string.asm"

	;; Constants
	;; -------------------------------
endPgm equ '?'
endInp equ '$'

	;; Variables
	;; -------------------------------
testString: db 'Testing', 0
hex_byte: db 0x00
hex_code: times 255 db 0

times 1024-($-$$) db 0