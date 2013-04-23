

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

    mov $Message,%ax
    mov %ax,%bp
    mov $30,%cx
    mov $0x1301,%ax
    mov $0x000c,%bx
    mov $0,%dl
    int $0x10
    jmp .
Message:.ascii "Hello From Zaks!\r\nMy name is WangXingyou!ABCDEFGHIJKLMN    "

