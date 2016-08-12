#include <unistd.h>
#include <stdio.h>
     
int main()
{
    char buf[150];
    int i;
    read( 0, buf, sizeof( buf ) );  // read 10 chars from standard input
    for(i=0 ; i<150 ; i++)
    {
        putchar(buf[i]);
    }
    return 0;
}
