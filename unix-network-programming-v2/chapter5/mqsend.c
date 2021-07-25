#include <fcntl.h>
#include <sys/stat.h>
#include <mqueue.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

int main(int argc, char **argv) {
    mqd_t mqd;
    mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP;
    if ((mqd = mq_open("/test", O_CREAT | O_WRONLY, mode, NULL)) < 0) {
        printf("open mq error: %d, %s", errno, strerror(errno));
        return 0;
    }

    char *msg = "Hello world!";
    mq_send(mqd, msg, strlen(msg), 10);
}