#include <stdio.h>
#include <assert.h>
 
extern long REGISTER_ADDER(long a, long b);
 
int main()
{
    printf("Running tests...\n");
 
    // simple positive numbers
    assert(REGISTER_ADDER(5, 10) == 15);
    printf("Test 1 passed: 5 + 10 = 15\n");
 
    // adding zero
    assert(REGISTER_ADDER(0, 7) == 7);
    printf("Test 2 passed: 0 + 7 = 7\n");
 
    // both zero
    assert(REGISTER_ADDER(0, 0) == 0);
    printf("Test 3 passed: 0 + 0 = 0\n");
 
    // bigger numbers
    assert(REGISTER_ADDER(100, 250) == 350);
    printf("Test 4 passed: 100 + 250 = 350\n");
 
    // negative number
    assert(REGISTER_ADDER(-5, 10) == 5);
    printf("Test 5 passed: -5 + 10 = 5\n");
 
    // both negative
    assert(REGISTER_ADDER(-3, -4) == -7);
    printf("Test 6 passed: -3 + -4 = -7\n");
 
    // running sum like the main program does (3 times)
    long total = 0;
    total += REGISTER_ADDER(5, 10);
    total += REGISTER_ADDER(5, 10);
    total += REGISTER_ADDER(5, 10);
    assert(total == 45);
    printf("Test 7 passed: running sum 3x(5+10) = 45\n");
 
    printf("\nAll tests passed!\n");
    return 0;
}
 