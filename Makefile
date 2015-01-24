CC = gcc
CFLAGS = -Wall `pkg-config gtk+-3.0 --cflags` -O3
LIBS = `pkg-config gtk+-3.0 --libs`
NAME = parens-plot
HEADERS = src/*.h
SOURCES = src/main.c $(HEADERS:.h=.c)
OBJECTS = $(SOURCES:.c=.o)

$(NAME): $(OBJECTS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

main.o: src/main.c


clean:
	rm -f $(NAME)
	rm -f src/*.o
