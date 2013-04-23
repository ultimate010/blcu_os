.globl start
.globl show
start:
    call mymain
exit:
    movl $0,%ebx
    movl $1,%eax
    int $0x80
show:
    movl 4(%esp),%ecx
    movl 8(%esp),%edx
    movl $1,%ebx
    movl $4,%eax
    int $0x80
    ret
