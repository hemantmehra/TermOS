OS: bootsec.bin kernel.bin fileTable.bin calculator.bin editor.bin
	cat bootsec.bin kernel.bin fileTable.bin calculator.bin editor.bin > temp.bin;\
	dd if=/dev/zero of=os.bin bs=512 count=2880;\
	dd if=temp.bin of=os.bin conv=notrunc;\
	rm *[!os].bin

bootsec.bin:
	nasm ../src/asm/bootsec.asm -f bin -o bootsec.bin

fileTable.bin:
	nasm ../src/asm/fileTable.asm -f bin -o fileTable.bin

kernel.bin:
	nasm ../src/asm/kernel.asm -f bin -o kernel.bin

calculator.bin:
	nasm ../src/asm/calculator.asm -f bin -o calculator.bin

editor.bin:
	nasm ../src/asm/editor.asm -f bin -o editor.bin

clean:
	rm -f *.bin
