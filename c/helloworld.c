// First hour of learning C
/*
 * Multi-line comment
 * abcdefg
 * hijklmnop
 * qrstuv
 * wxyz
 */
#include <stdio.h>
// This is a comment
int main() {
    short int age = 14;
    long int randomNumber;
    char answer;
    /* Test comment */ printf("Hello World\n");
    printf("Age: %d\nRandom Number: %d\n",age,randomNumber);
    printf("Answer ? ");
    scanf("%c",&answer);
    printf("Answer was: %c\n",answer);
    printf("ASCII Value: %d\n",answer);
    short a;
    long b;
    long long c;
    long double d;

    printf("size of short = %d bytes\n", sizeof(a));
    printf("size of long = %d bytes\n", sizeof(b));
    printf("size of long long = %d bytes\n", sizeof(c));
    printf("size of long double= %d bytes\n", sizeof(d));
}
