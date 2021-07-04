;;; File Table entry size = 16 bytes
;;; Byte 	Purpose
;;; ------------------
;;; 0-9		File name
;;; 10-12	Extension
;;; 13		Directory Entry - 0h based # of file table entries
;;; 14		Starting sector i.e. 6h would be start in sector 6.
;;; 15		File Size (# of sectors) 0-255 sectors.
;;;			Max size of 1 file entry = 127.5 KB
;;;			Max size overall 255 * 512 * 255 = 32 MB 

;;  0-9		     10-12  13   14   15

db 'bootsec   ', 'bin', 00h, 01h, 01h, \
   'kernel    ', 'bin', 00h, 02h, 04h, \
   'fileTable ', 'txt', 00h, 06h, 01h, \
   'calculator', 'bin', 00h, 07h, 01h, \
   'editor    ', 'bin', 00h, 08h, 02h

times 512-($-$$) db 0
