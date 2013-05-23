#include <stdio.h>

#define FALSE 0
#define TRUE  !FALSE

int main(){
  int count = 0;
  for(;count < 5; count++){
    int num = random(5);
    printf("%d\n", num);
  }

  return(0);
}

/*
 * While-Count= 1
 * While-Count= 2
 * While-Count= 3
 * While-Count= 4
 * While-Count= 5
 * for  -Count= 1
 * for  -Count= 2
 * for  -Count= 3
 * for  -Count= 4
 * for  -Count= 5
 * */
