/* Pseudo code for Four Sample Sliding Window Averaging Filter */

case(state):

  idle:

  if (data_ready == 0)
    GOTO idle;
  else
    GOTO store;

  store:

   if (data_ready == 0)
     GOTO eidle;
   else
     register[5] = data;
     err = 0;

  sort1:

    register[1] = register[2];

  sort2:

    register[2] = register[3];

  sort3:

    register[3] = register[4];

  sort4:

    register[4] = register[5];

  add:

    register[5] = register[3] + register[4];
    register[6] = register[1] + register[2];
    register[0] = register[5] + register[6];

    if (overflow == 1)
      GOTO eidle;
    else
      GOTO idle;

  eidle:

    err = 1;

    if (data_ready == 1)
      GOTO store;
    else
      GOTO eidle;
  
  
