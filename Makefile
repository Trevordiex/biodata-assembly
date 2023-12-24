objects = main.o fields.o driver.o

biodata: $(objects)
	gcc -m32 -o biodata $(objects)

main.o: main.inc main.asm
	nasm -felf -F dwarf -o main.o main.asm

fields.o: fields.asm
	nasm -felf -F dwarf -o fields.o fields.asm

driver.o:
	gcc -m32 -g -c -o driver.o driver.c


.PHONY : clean
clean:
	-rm $(objects) biodata biodata.txt