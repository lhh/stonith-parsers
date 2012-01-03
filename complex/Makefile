CFLAGS=-ggdb -DSTANDALONE

all: config

config:config.y config.l
	bison -d config.y
	flex -oconfig.c config.l
	gcc ${CFLAGS} -c -o config.o config.c -I. -DSTANDALONE
	gcc ${CFLAGS} -c -o config.tab.o config.tab.c -I.
	gcc -o config config.tab.o config.o

clean:
	rm -f *~ config.tab.* *.o config.c config y.tab.h

