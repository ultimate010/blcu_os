#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/stat.h>

int
main(int argc, char *argv[]) {
    struct stat st;
    if (argc != 3) {																		//传入的参数个数有误			
        fprintf(stderr, "Usage: <input filename> <output filename>\n");
        return -1;
    }
    if (stat(argv[1], &st) != 0) {															//打开文件有误
        fprintf(stderr, "Error opening file '%s': %s\n", argv[1], strerror(errno));
        return -1;
    }
    printf("'%s' size: %lld bytes\n", argv[1], (long long)st.st_size);
    if (st.st_size > 510) {																	//文件大小有误
        fprintf(stderr, "%lld >> 510!!\n", (long long)st.st_size);
        return -1;
    }
    char buf[512];
    memset(buf, 0, sizeof(buf));   															//将buf中的所有字符置为0，用于初始化。
    FILE *ifp = fopen(argv[1], "rb");														//作为输入的数据文件
    int size = fread(buf, 1, st.st_size, ifp);												//获取数据的大小
    if (size != st.st_size) {																//读取错误
        fprintf(stderr, "read '%s' error, size is %d.\n", argv[1], size);
        return -1;
    }
    fclose(ifp);
	//以下两句目的是设置结束语句
    buf[510] = 0x55;
    buf[511] = 0xAA;																		
    FILE *ofp = fopen(argv[2], "wb+");														//以写方式打开argv[2]指向的源文件名对应的二进制文件	
    size = fwrite(buf, 1, 512, ofp);														//令整个程序的大小为512个字节
    if (size != 512) {
        fprintf(stderr, "write '%s' error, size is %d.\n", argv[2], size);
        return -1;
    }
    fclose(ofp);
    printf("build 512 bytes boot sector: '%s' success!\n", argv[2]);
    return 0;
}
