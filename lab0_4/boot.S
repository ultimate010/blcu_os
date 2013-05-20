/*
   Author: Wenbo Yang <solrex@gmail.com> <http://solrex.cn>

   This file is part of the source code of book "Write Your Own OS with Free
   and Open Source Software". Homepage @ <http://share.solrex.cn/WriteOS/>.

   This file is licensed under the GNU General Public License; either
   version 3 of the License, or (at your option) any later version. */
# 被Zaks Wang简化成现在这样
# 2013-5-20

.code16
.set    BaseOfStack,     0x7c00    /* Stack base address, inner */
.set    BaseOfLoader,    0x9000    /* Section loading address of LOADER.BIN */
.set    OffsetOfLoader,  0x100/* Loading offset of kernel.bin*/
/* Start sector of file space =*/
.text
/* Floppy header of FAT12 */
    jmp     LABEL_START /* Start to boot. */
    nop                 /* nop required */
BPB_SecPerTrk:      .2byte  18            /* Sector per track */
BS_DrvNum:          .byte   0             /* Driver number of interrupt 13 */

/* Initial registers. */
LABEL_START:
    mov     %cs,%ax
    mov     %ax,%ds
    mov     %ax,%es
    mov     %ax,%ss
    mov     $BaseOfStack, %sp /* 0x7c00 */

    /* Clear screen */
    mov     $0x0600,%ax   /* %ah=6, %al=0 */
    mov     $0x0700,%bx   /* Black white */
    mov     $0,%cx        /* Top left: (0,0) */
    mov     $0x184f,%dx   /* Bottom right: (80,50) */
    int     $0x10         /* BIOS int 10h, ah=6: Initialize screen */

    /* Display "Booting**" */
    mov     $0,%dh
    call    DispStr       /* Display string(index 0)*/

    /* Reset floppy */
    xor     %ah,%ah
    xor     %dl,%dl       /* %dl=0: floppy driver 0 */
    int     $0x13         /* BIOS int 13h, ah=0: Reset driver 0 */


/* Read one sector to memory */
    mov     $BaseOfLoader,%ax
    mov     %ax,%es                     /* %es <- BaseOfLoader*/
    mov     $OffsetOfLoader,%bx         /* %bx <- OffsetOfLoader */
    mov     $1,%ax             /* %ax <- sector number in root */
    mov     $1,%cl
    call    ReadSector
    jmp     $BaseOfLoader,$OffsetOfLoader /* Jmp */


/* ==================================================================
   String table
*/
.set    MessageLength,34
BootMessage:        .ascii    "Booting From Zaks! Jmp to kernel\n"        /* index 0 */
Message1:           .ascii    "Ha Ha Funning                     "        /* index 1 */

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
    mov     $0,%dl                /* Start row and column */
    int     $0x10                 /* BIOS INT 10h, display string */
    ret

/* ==================================================================
   Routine: ReadSector
   Action: Read %cl Sectors from %ax sector(floppy) to %es:%bx(memory)
     Assume sector number is 'x', then:
       x/(BPB_SecPerTrk) = y,
       x%(BPB_SecPerTrk) = z.
     The remainder 'z' PLUS 1 is the start sector number;
     The quotient 'y' divide by BPB_NumHeads(RIGHT SHIFT 1 bit)is cylinder
       number;
     AND 'y' by 1 can got magnetic header.
*/
ReadSector:
    push    %ebp
    mov     %esp,%ebp
    sub     $2,%esp        /* Reserve space for saving %cl */
    mov     %cl,-2(%ebp)
    push    %bx            /* Save bx */
    mov     (BPB_SecPerTrk), %bl    /* %bl: the divider */
    div     %bl            /* 'y' in %al, 'z' in %ah */
    inc     %ah            /* z++, got start sector */
    mov     %ah,%cl        /* %cl <- start sector number */
    mov     %al,%dh        /* %dh <- 'y' */
    shr     $1,%al         /* 'y'/BPB_NumHeads */
    mov     %al,%ch        /* %ch <- Cylinder number(y>>1) */
    and     $1,%dh         /* %dh <- Magnetic header(y&1) */
    pop     %bx            /* Restore %bx */
    /* Now, we got cylinder number in %ch, start sector number in %cl, magnetic
       header in %dh. */
    mov     (BS_DrvNum), %dl
GoOnReading:
    mov     $2,%ah
    mov     -2(%ebp),%al    /* Read %al sectors */
    int     $0x13
    jc      GoOnReading     /* If CF set 1, mean read error, reread. */
    add     $2,%esp
    pop     %ebp
    ret

.org 510        /* Skip to address 0x510. */
.2byte 0xaa55   /* Write boot flag to 1st sector(512 bytes) end */

