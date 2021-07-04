
org 0x7c00

;; -------------------------
;; Load file Table
;; -------------------------
mov BX, 0x1000 ; load sector to mem 0x1000
mov es, bx     ; ES = 0x1000
mov bx, 0x0      ; ES:BX = 0x1000:0

mov dh, 0x0 ; no of sector
mov dl, 0x0 ; drive number
mov ch, 0x0 ; cylinder 0
mov cl, 0x06 ; starting sector

load_fileTable:
    mov ah, 0x02 ; BIOS int 13/0x02 read disk sector
    mov al, 0x01 ; # of sector to read
    int 0x13

    jc load_fileTable ; retry

;; -------------------------
;; Load Kernel
;; -------------------------
mov BX, 0x2000 ; load sector to mem 0x2000
mov es, bx     ; ES = 0x1000
mov bx, 0x0      ; ES:BX = 0x1000:0

mov dh, 0x0 ; no of sector
mov dl, 0x0 ; drive number
mov ch, 0x0 ; cylinder 0
mov cl, 0x02 ; starting sector

load_kernel:
    mov ah, 0x02 ; BIOS int 13/0x02 read disk sector
    mov al, 0x04 ; # of sector to read
    int 0x13

    jc load_kernel ; retry

    ;; -------------------------
    ;; Segmenting
    ;; -------------------------
    mov ax, 0x2000
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov sp, 0xFFFF
    mov ax, 0x9000
    mov ss, ax

    ;; Set uo video mode
    mov ax, 0x0003
    int 0x10

    mov ah, 0x0B
    mov bx, 0x0001
    int 0x10 

    jmp 0x2000:0x0

times 510-($-$$) db 0
dw 0xaa55