/*
   Author: Wenbo Yang <solrex@gmail.com> <http://solrex.cn>

   This file is part of the source code of book "Write Your Own OS with Free
   and Open Source Software". Homepage @ <http://share.solrex.cn/WriteOS/>.

   This file is licensed under the GNU General Public License; either
   version 3 of the License, or (at your option) any later version. */
# 被Zaks Wang简化成现在这样
# 2013-5-20

.code16
.set    BaseOfStack,    0x7c00
/* Start sector of file space =*/
.text
/* Floppy header of FAT12 */
    jmp     LABEL_START /* Start to boot. */
    nop                 /* nop required */

LABEL_START:
    mov     %cs,%ax
    mov     %ax,%ds
    mov     %ax,%es
    mov     %ax,%ss
    mov     $BaseOfStack, %sp /* 0x7c00 */

    /* Clear screen */

    #mov     $0x0600,%ax   /* %ah=6, %al=0 */
    #mov     $0x0700,%bx   /* Black white */
    #mov     $0,%cx        /* Top left: (0,0) */
    #mov     $0x184f,%dx   /* Bottom right: (80,50) */
    #int     $0x10         /* BIOS int 10h, ah=6: Initialize screen */
    /* Display "Booting**" */
    mov     $1,%dh
    call    DispStr       /* Display string(index 0)*/
    jmp     .


/* ==================================================================
   String table
*/
.set    MessageLength,10
BootMessage:        .ascii    "Booting **"        /* index 0 */
Message1:           .ascii    "In  Kernel"        /* index 1 */

/* ==================================================================
   Routine: DispStr
   Action: Display a string, string index stored in %dh
*/
DispStr:
    mov     $MessageLength, %ax
    mul     %dh
    add     $BootMessage,%ax
    mov     %ax,%bp               /* String address */
    mov     %ds,%ax
    mov     %ax,%es
    mov     $MessageLength,%cx    /* String length */
    mov     $0x1301,%ax           /* ah = 0x13, al = 0x01(W) */
    mov     $0x07,%bx             /* PageNum 0(bh = 0), bw(bl= 0x07)*/
    mov     $29,%dl                /* Start row and column */
    int     $0x10                 /* BIOS INT 10h, display string */
    ret

.org 510        /* Skip to address 0x510. */
.2byte 0xaa55   /* Write boot flag to 1st sector(512 bytes) end */

