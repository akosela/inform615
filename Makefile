# Makefile
CC = gcc
CFLAGS = -O2 -ansi
V=0

PREFIX = /usr
MANDIR = $(PREFIX)/share/man/man6
MAIN = inform

# collect all source .c files
SRC = $(wildcard src/*.c)
# change suffixes from .c to .o
OBJ = $(SRC:.c=.o)

.c.o:
ifeq ($V, 0)
	@echo "  CC      " $*.o
	@$(CC) $(CFLAGS) -c $*.c -o $*.o
else
	$(CC) $(CFLAGS) -c $*.c -o $*.o
endif

$(MAIN): $(OBJ)
ifeq ($V, 0)
	@echo "  CCLD    " $@
	@$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
else
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
endif
	@strip $(MAIN)

.PHONY: clean
clean:
	rm -f $(OBJ) $(MAIN)

.PHONY: install
install:
	install -d $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)$(MANDIR)
	install -c -m 755 $(MAIN) $(DESTDIR)$(PREFIX)/bin
	install -c -m 644 $(MAIN).6 $(DESTDIR)$(MANDIR)
	gzip $(DESTDIR)$(MANDIR)/$(MAIN).6

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(MAIN)
	rm -f $(DESTDIR)$(MANDIR)/$(MAIN).6.gz
