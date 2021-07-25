#include <mqueue.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv) {
    mqd_t mqd;
    if ((mqd = mq_open("/test", O_RDONLY)) < 0) {
        printf("open mq error: %d, %s\n", errno, strerror(errno));
        return 0;
    }
    struct mq_attr attr;
    if (mq_getattr(mqd, &attr) < 0) {
        printf("get attr error: %d, %s\n", errno, strerror(errno));
        return 0;
    }
    char buff[attr.mq_msgsize];
    if(mq_receive(mqd, buff, attr.mq_msgsize, NULL) < 0) {
        printf("receive msg error: %d, %s\n", errno, strerror(errno));
        return 0;
    }

    printf("take msg from queue: %s\n", buff);
}