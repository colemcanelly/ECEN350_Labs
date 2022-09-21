#include <stdio.h>

extern long long int test();
extern char* lab02b();
extern char* lab02c(long long int a);
extern long long int* lab02d(long long int a);
int main(void)
{
	test();
	char* b_result = lab02b();	// Capitalizes a letter at specific index
	printf(b_result);

	char* c_result = lab02c(120);	// Converts the given input (decimal) to hex
	printf(c_result);

	long long int* d_result = lab02d(69);
	return 0;
}
