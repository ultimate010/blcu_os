#
# Author: Wenbo Yang <solrex@gmail.com> <http://solrex.cn>
#
# This file is part of the source code of book "Write Your Own OS with Free
# and Open Source Software". Homepage @ <http://share.solrex.cn/WriteOS/>.
#
# This file is licensed under the GNU General Public License; either
# version 3 of the License, or (at your option) any later version.
# 被Zaks Wang简化成现在这样
# 2013-5-20

CC=gcc
LD=ld
OBJCOPY=objcopy

CFLAGS=-c
TRIM_FLAGS=-R .pdr -R .comment -R.note -S -O binary

LDFILE_KERNEL=kernel.ld
LDFILE_BOOT=boot.ld
LDFLAGS_KERNEL=-T$(LDFILE_KERNEL)
LDFLAGS_BOOT=-T$(LDFILE_BOOT)
all: boot.img
boot.bin: boot.S
	$(CC) $(CFLAGS) boot.S
	$(LD) boot.o -o boot.elf $(LDFLAGS_BOOT)
	$(OBJCOPY) $(TRIM_FLAGS) boot.elf $@
kernel.bin: kernel.S
	$(CC) $(CFLAGS) kernel.S
	$(LD) kernel.o -o kernel.elf $(LDFLAGS_KERNEL)
	$(OBJCOPY) $(TRIM_FLAGS) kernel.elf $@
boot.img: boot.bin kernel.bin
	dd if=boot.bin of=boot.img bs=512 count=1
	dd if=kernel.bin of=boot.img seek=1 bs=512 conv=notrunc
clean:
	@rm -f *.o *.elf *.bin *.img
qemu:all
	qemu -fda boot.img
debug:all
	@qemu -S -s -parallel stdio -fda boot.img &
	sleep 2
	gnome-terminal -e "gdb -q -x gdbinit"
