.globl start
.globl show
start:								
    call mymain
exit:
    movl $0,%ebx			#ebx寄存器置零
    movl $1,%eax			#eax寄存器置1
    int $0x80				#系统调用是通过int 0x80来实现的，eax寄存器中为调用的功能号，
							#ebx、ecx、edx、esi等等寄存器则依次为参数
show:
    movl 4(%esp),%ecx		#ecx寄存器置esp+4 指向的内存位置
    movl 8(%esp),%edx		#edx寄存器置esp+8 指向的内存位置
    movl $1,%ebx			#ebx寄存器置1
    movl $4,%eax			#功能号为4
    int $0x80				#同上
    ret
	
#更详细可参考”汇编学习之系统调用(int $0x80) “http://blog.chinaunix.net/uid-10386087-id-2958668.html