all:
	cc -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc -fno-stack-protector -Os -c bootasm.S -o bootasm.o
	@ld -m elf_i386 -nostdlib -N -e start -Ttext 0x7c00 bootasm.o  -o bootblock.o
	@objcopy  -R .pdr -R .comment -R .note -S -O binary bootblock.o bootblock.out
	./sign bootblock.out boot.img
run:all
	@qemu -hda boot.img
clean:
	rm -f *.o *.out *.img
