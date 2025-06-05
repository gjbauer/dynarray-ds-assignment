#include <stdio.h>

int main(int argc, char *argv[])
{
	char *buff;
	int count = 2, reallocs = 0;
	buff = (char*)malloc(count * sizeof(char));
	
	// TODO: Read from the second argument, and reallocate a new buffer as needed
	//for(;;);
	
	printf("number of reallocs: %d", reallocs);
	return 0;
}
