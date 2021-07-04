call clear_screen_text_mode

mov si, testMsg
call printString

mov ah, 0x00
int 0x16

mov ax, 0x2000
mov es, ax

xor bx, bx

mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
jmp 0x2000:0x0000

%include "../include/print/print_string.asm"
%include "../include/screen/clear_screen_text_mode.asm"

testMsg: db 'Program Loaded!', 0

times 512-($-$$) db 0