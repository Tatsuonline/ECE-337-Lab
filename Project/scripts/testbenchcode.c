#include <stdio.h>

int main()
{
  int i = 0;
  int j = 21300;

  for (i = 0; i < 550; i++)
    {
      printf("assign tb_data_input = %d;\n", j+i); 
      printf("#(CLK_PERIOD);\n");
    }
  return 0;
}
