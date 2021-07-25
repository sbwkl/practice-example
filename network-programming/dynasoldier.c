#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv) {
  char msg[1024];
  int n;
  while((n = read(STDIN_FILENO, msg, sizeof(msg))) > 0) {
      if (msg[n - 1] == '\n') {
        msg[n - 1] = '\0';
      }
      printf("%s\n", msg);
  }
  printf("dynasoldier\n");
}
