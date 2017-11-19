CC=gcc
CFLAGS=-ansi -Wall -pedantic-errors -g -lm

all: circular

fila_circular.o: fila_circular.c fila_circular.h
	$(CC) -c fila_circular.c $(CFLAGS)

circular.o: circular.c
	$(CC) -c circular.c $(CFLAGS)

circular: circular.o fila_circular.o
	$(CC) circular.o fila_circular.o -o circular $(CFLAGS)

clean:
	rm -f *.o circular
