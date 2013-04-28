#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <console.h>
int kern_init(void) __attribute__((noreturn));
int
kern_init(void) {

    cons_init();                // 初始化终端

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
    int i=0;
    for(i=0;i<10;i++){
      cprintf("Count:%d Hello World From Zaks!\n",i);
    }
    while (1);
}
