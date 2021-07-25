#include <stdio.h>
#include <unistd.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char **argv) {

  char *x = "abc";
  for (int i = 0; i < strlen(x); i++) {
    printf("%x\n", x[i]);
  }
}
