#include <stdio.h>


struct CGPoint
{
  int x;
  int y;
};
typedef struct CGPoint  CGPoint;

void work()
{
  int     i, ii;
  CGPoint array[8][10];

  for (i = 0; i < 8; i++) {
    for (ii = 0; ii < 10; ii++) {
      CGPoint p;
      p.x          = i;
      p.y          = ii;
      array[i][ii] = p;
    }
  }

  printf("%d\n", array[7][3].y);
}

int main2(void)
{
  work();
  return(1);
}