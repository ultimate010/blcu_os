all:								
#.o文件为目标文件。用-o 命令来创建
#ld为连接工具，可将多个.o 文件，或者.o 文件和库文件链接成为可被操作系统执行的可执行程序

	cc -m32 -c myasm.S -o myasm.o
	cc -m32 -c main.c -o main.o
	@ld -m elf_i386 -e start myasm.o main.o  -o run.o
	@objdump -S run.o > run.asm
run:all										
#run依赖于all；						
	./run.o
clean:										
#清空目标文件，在命令行之前使用“-”，意思是忽略命令“rm”的执行错误	
	rm -f *.o *.out *.asm