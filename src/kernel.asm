;; Kernel
;; ==============================
    ;; Print Menu
main_menu:
    call clear_screen_text_mode

    mov si, kernel_header
    call printString

;; Get user input
get_input:
    mov si, prompt
    call printString
    xor cx, cx
    mov si, cmdString

    mov ax, 0x200  ; reset to 0x2000 kernel area
    mov es, ax
    mov ds, ax

keyloop:
    xor ax, ax
    int 0x16        ; get Keystroke, character goes to al

    ;; print user input
    mov ah, 0x0e
    cmp al, 0xD
    je run_cmd

    int 0x10
    cmp al, 0x08        ; backspace
    jne .not_backspace
    dec si
    dec cx
    jmp keyloop

    .not_backspace:
    mov [si], al        ; store input char to string
    inc cx              ; increment byte counter of input
    inc si              ; go to next byte in di/cmdString
    jmp keyloop

run_cmd:
    cmp cx, 0
    je input_notFound

    mov byte [si], 0
    mov si, cmdString

check_command:
    push cx
    mov di, cmdDir
    rep cmpsb
    je fileTable_print

    pop cx
    push cx
    mov di, cmdReboot
    mov si, cmdString
    rep cmpsb
    je reboot

    pop cx
    push cx
    mov di, cmdPrtreg
    mov si, cmdString
    rep cmpsb
    je register_print

    pop cx
    push cx
    mov di, cmdGfxtest
    mov si, cmdString
    rep cmpsb
    je graphics_test

    pop cx
    push cx
    mov di, cmdHlt
    mov si, cmdString
    rep cmpsb
    je end_prog

    pop cx
    push cx
    mov di, cmdCls
    mov si, cmdString
    rep cmpsb
    je clear_screen

    pop cx
    push cx
    mov di, cmdShutdown
    mov si, cmdString
    rep cmpsb
    je shutdown

    pop cx

check_file:
    mov ax, 0x100
    mov es, ax
    xor bx, bx
    mov si, cmdString

check_next_char:
    mov al, [ES:BX]
    cmp al, 0
    je input_notFound

    cmp al, [si]
    je start_compare

    add bx, 16
    jmp check_next_char

start_compare:
    push bx

compare_loop:
    mov al, [ES:BX]
    inc bx
    cmp al, [si]
    jne restart_search

    dec cl
    jz found_program
    inc si
    jmp compare_loop

restart_search:
    mov si, cmdString
    pop bx
    inc bx
    jmp check_next_char

found_program:
    ; Get file extension - bytes 10-12
    mov al, [ES:BX]
    mov [fileExt], al
    mov al, [ES:BX + 1]
    mov [fileExt + 1], al
    mov al, [ES:BX + 2]
    mov [fileExt + 2], al


    add bx, 4
    mov cl, [ES:BX]     ; sector # to start reading from
    inc bx
    mov bl, [ES:BX]     ; # of sectors to read
    mov byte [fileSize], bl

    xor ax, ax
    mov dl, 0x00
    int 0x13            ; reset disk system

    mov ax, 0x800
    mov es, ax
    mov al, bl          ; # of sectors to read
    xor bx, bx          ; ES:BX = 0x8000:0x0000

    mov ah, 0x02
    mov ch, 0x00        ; track #
    mov dh, 0x00        ; head #
    mov dl, 0x00        ; drive #

    int 0x13
    jnc run_program

    mov si, notLoaded
    call printString
    jmp get_input

run_program:
    mov cx, 3
    mov si, fileExt
    mov ax, 0x200
    mov es, ax
    mov di, fileBin
    repe cmpsb
    jne print_text_file

    mov ax, 0x800
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    jmp 0x800:0x0000

print_text_file:
    mov ax, 0x800
    mov es, ax
    xor cx, cx
    mov ah, 0x0e

add_cx_size:
    imul cx, word [fileSize], 512

print_file_char:
    mov al, [ES:BX]
    int 0x10
    inc bx
    loop print_file_char
    jmp get_input

input_notFound:
    mov si, failure
    call printString
    jmp get_input

        ;; ============================
        ;;  File Table
        ;; ============================

fileTable_print:
    call print_fileTable
    jmp get_input

        ;; ============================
        ;;  Reboot
        ;; ============================

reboot:
    jmp 0xFFFF:0x0000   ; Far jmp to reset vector

        ;; ============================
        ;;  Print registers
        ;; ============================
register_print:
    mov si, printReg_header
    call printString
    call print_registers
    jmp get_input

        ;; ============================
        ;;  Graphics Mode test
        ;; ============================
graphics_test:
    call resetGraphicsScreen
    
    ;; Test Square
    mov ah, 0x0C    ; int 10h ah 0x0C - write gfx pixel
    mov al, 0x01    ; blue
    mov bh, 0x00    ; page screen

    ;; Starting pixel
    mov cx, 100    ; column
    mov dx, 100    ; row
    int 0x10

squareColLoop:
    inc cx
    int 0x10
    cmp cx, 150
    jne squareColLoop

    inc dx
    int 0x10
    mov cx, 99
    cmp dx, 150
    jne squareColLoop

    mov ah, 0x00
    int 0x16
    jmp main_menu

shutdown:
    mov ax, 2000h
    mov dx, 604h
    out dx, ax

clear_screen:
    call clear_screen_text_mode
    jmp get_input

        ;; ============================
        ;;  End Program
        ;; ============================
end_prog:
    cli
    hlt

print_hex_as_ascii:
    mov ah, 0x0e
    add al, 0x30
    cmp al, 0x39
    jle hexNum
    add al, 0x7

hexNum:
    int 0x10
    ret

print_blanks_loop:
    mov ah, 0x0e
    mov al, ' '
    int 0x10
    loop print_blanks_loop
    ret

%include "../include/print/print_string.asm"
%include "../include/print/print_hex.asm"
%include "../include/print/print_registers.asm"
%include "../include/print/print_fileTable.asm"
;; %include "../include/screen/clearScreen.asm"
%include "../include/screen/clear_screen_text_mode.asm"
%include "../include/screen/resetGraphicsScreen.asm"

        ;; ============================
        ;;  Variables
        ;; ============================

kernel_header: db '        ****    TermOS    ****', 0xA, 0xD, 0xA, 0xD, 0
prompt: db '> ', 0
success: db 0xA, 0xD, 'Loaded', 0xA, 0xD, 0
failure: db 0xA, 0xD, 'Command not found', 0xA, 0xD, 0

cmdDir:         db 'dir', 0
cmdReboot:      db 'reboot', 0
cmdPrtreg:      db 'prtreg', 0
cmdGfxtest:     db 'gfxtest', 0
cmdHlt:         db 'hlt', 0
cmdCls:         db 'cls', 0
cmdShutdown:    db 'shutdown', 0
cmdEditor:      db 'editor', 0

file_header: db 0xA, 0xD,\
                '-------------------------------------------------------------', 0xA, 0xD,\
                'File Name   Extension   Entry #   Start sector   size(sector)', 0xA, 0xD,\
                '-------------------------------------------------------------', 0xA, 0xD, 0

printReg_header: db 0xA, 0xD,\
                    '---------------------------', 0xA, 0xD,\
                    'Register       Mem Location', 0xA, 0xD,\
                    '---------------------------', 0xA, 0xD, 0

notFoundString: db 0xA, 0xD, 'Program not found. Try Again (Y)', 0xA, 0xD, 0
cmdLength: db 0

notLoaded: db 0xA, 0xD, 'Program not loaded! Try again', 0xA, 0xD, 0
secNotFound: db 0xA, 0xD, 'Sector not found! Try again (Y)', 0xA, 0xD, 0
goBackMsg: db 0xA, 0xD, 0xA, 0xD, 'Press any key to go back...', 0xA, 0xD, 0
fileExt:   db '   ', 0
fileSize:  db 0
fileBin:   db 'bin', 0
fileTxt:   db 'txt', 0
cmdString: db ''

        ;; ============================
        ;;  Sector Padding Magic
        ;; ============================

times 2048-($-$$) db 0
