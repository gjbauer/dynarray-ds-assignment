
all: dynarray

dynarray:
	clang -o dynarray dynarray.c

clean:
	rm dynarray

open:
	nvim -p *.c *.h

