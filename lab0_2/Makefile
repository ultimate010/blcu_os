all:
	cc -m32 -c myasm.S -o myasm.o
	cc -m32 -c main.c -o main.o
	@ld -m elf_i386 -e start myasm.o main.o  -o run.o
	@objdump -S run.o > run.asm
run:all
	./run.o
clean:
	rm -f *.o *.out *.asm
