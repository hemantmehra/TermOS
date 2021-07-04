OS: bootsec.bin kernel.bin fileTable.bin calculator.bin editor.bin
	cat ../bin/bootsec.bin ../bin/kernel.bin ../bin/fileTable.bin ../bin/calculator.bin ../bin/editor.bin > temp.bin;\
	dd if=/dev/zero of=os.bin bs=512 count=2880;\
	dd if=temp.bin of=os.bin conv=notrunc;\
	rm temp.bin

bootsec.bin:
	nasm ../src/bootsec.asm -f bin -o ../bin/bootsec.bin

fileTable.bin:
	nasm ../src/fileTable.asm -f bin -o ../bin/fileTable.bin

kernel.bin:
	nasm ../src/kernel.asm -f bin -o ../bin/kernel.bin

calculator.bin:
	nasm ../src/calculator.asm -f bin -o ../bin/calculator.bin

editor.bin:
	nasm ../src/editor.asm -f bin -o ../bin/editor.bin

clean:
	rm -f ../bin/*.bin
