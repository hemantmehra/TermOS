
org 0x7c00

;; -------------------------
;; Load file Table
;; -------------------------
mov bx, 0x100 ; load sector to mem 0x1000
mov es, bx     ; ES = 0x1000
xor bx, bx      ; ES:BX = 0x1000:0

xor dx, dx      ; dh = head, dl = drive
mov cx, 0x0006  ; ch = cylinder, cl = starting sector to read

load_fileTable:
    mov ah, 0x02 ; BIOS int 13/0x02 read disk sector
    mov al, 0x01 ; # of sector to read
    int 0x13

    jc load_fileTable ; retry

;; -------------------------
;; Load Kernel
;; -------------------------
mov BX, 0x200   ; load sector to mem 0x2000
mov es, bx      ; ES = 0x1000
xor bx, bx      ; ES:BX = 0x1000:0

xor dx, dx      ; dh = head, dl = drive
mov cx, 0x0002  ; ch = cylinder, cl = starting sector to read

load_kernel:
    mov ah, 0x02 ; BIOS int 13/0x02 read disk sector
    mov al, 0x04 ; # of sector to read
    int 0x13

    jc load_kernel ; retry

    ;; -------------------------
    ;; Segmenting
    ;; -------------------------
    mov ax, 0x200
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov sp, 0xFFFF
    mov ax, 0x900
    mov ss, ax

    ;; Set uo video mode
    mov ax, 0x0003
    int 0x10

    mov ah, 0x0B
    mov bx, 0x0001
    int 0x10 

    jmp 0x200:0x0

times 510-($-$$) db 0
dw 0xaa55