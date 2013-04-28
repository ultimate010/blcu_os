# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # 十六位汇编模式 Assemble for 16-bit mode
    cli                                             # 首先关闭中断Disable interrupts

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # 把所有ax,es,ss都置为0  Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    mov $Message,%ax								#将Message送入ax
    mov %ax,%bp										#把ax中的Message送入寄存器bp
    mov $30,%cx										#计数用途的寄存器cx置30，即之后会循环30次
    mov $0x1301,%ax									#ah=13是功能号表示显示字符串 ,al=01是显示输出方式
    mov $0x000c,%bx									#bh=0是0页,bl=0ch高亮（黑底红字）
    mov $0,%dl										#0行0列
    int $0x10										#调用Bios中断0x10，具体执行什么功能取决与ah和bx的值（在前边设置的）
    jmp .											#跳转
Message:.ascii "Hello From Zaks!\r\nMy name is WangXingyou!ABCDEFGHIJKLMN    "

####################
#
#附加知识
#
####################
#int10的13功能号
#功能号：13H 
#功能：在Teletype模式下显示字符串 
#入口参数：AH＝13H
#         BH＝页码
#          BL＝属性(若AL=00H或01H)
#          CX＝显示字符串长度
#          (DH、DL)＝坐标(行、列)
#ES:BP＝显示字符串的地址 AL＝ 显示输出方式 
#0—字符串中只含显示字符，其显示属性在BL中。显示后，光标位置不变 
#1—字符串中只含显示字符，其显示属性在BL中。显示后，光标位置改变 
#2—字符串中含显示字符和显示属性。显示后，光标位置不变 
#3—字符串中含显示字符和显示属性。显示后，光标位置改变
#
#Some annotations were written by zhuozhuang