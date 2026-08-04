#include <string.h>
void f(char* s) {
  char buf[10];
  strcpy(buf, s);
  strcat(buf, s);
  sprintf(buf, "%s", s);
  gets(buf);
  system(s);
}
