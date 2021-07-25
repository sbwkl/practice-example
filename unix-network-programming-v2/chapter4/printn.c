#include <stdio.h>
#include <unistd.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char **argv) {

  char msg[1024];
  int n;
  char str[1024];
  while((n = read(STDIN_FILENO, msg, sizeof(msg))) > 0) {
    msg[n] = '\0';
    printf("%s", msg);
    fflush(stdout);

    // for (int i = 0; ; i++) {
    //   if (msg[i] == '\0') {
    //     break;
    //   }
    //   printf("%x ", msg[i]);
    // }
    // printf("\n");

    // printf("receive %d byte, but msg size = %ld\n", n, strlen(msg));
    // snprintf(str, n, msg);
    // printf("%s\n", str);
    // fflush(stdout);
  }
}
