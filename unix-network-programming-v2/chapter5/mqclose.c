#include <mqueue.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>

int main(int argc, char **argv) {

    mqd_t mqd;
    if ((mqd = mq_open("/test", O_RDONLY)) < 0) {
        printf("open msg error: %d, %s\n", errno, strerror(errno));
        return 0;
    };
    if(mq_close(mqd) < 0) {
        printf("close msg error: %d, %s\n", errno, strerror(errno));
        return 0;
    }
}