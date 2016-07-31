#include <unistd.h>
#include <stdio.h>
     
int main()
{
    char buf[70];
    int i;
    read( 0, buf, sizeof( buf ) );  // read 10 chars from standard input
    for(i=0 ; i<70 ; i++)
    {
        putchar(buf[i]);
    }
    return 0;
}
