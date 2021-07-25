#include <mqueue.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>

int main(int argc, char **argv) {

    if(mq_unlink("/test") < 0) {
        printf("unlink msg error: %d, %s\n", errno, strerror(errno));
        return 0;
    }
}