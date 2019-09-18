# Makefile
SHELL := /bin/bash
CC = gcc
CFLAGS = -O2 -ansi
V = 0

PREFIX = /usr
MANDIR = $(PREFIX)/share/man/man6
LIB = $(PREFIX)/share/inform615
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
	install -d $(DESTDIR)$(LIB)
	install -d $(DESTDIR)$(LIB)/{bin,demos,minform,tutor}
	install -c -m 755 $(MAIN) $(DESTDIR)$(PREFIX)/bin
	install -c -m 755 bin/i6 $(DESTDIR)$(PREFIX)/bin
	install -c -m 644 bin/a8.bin $(DESTDIR)$(LIB)/bin
	install -c -m 644 demos/minform.inf $(DESTDIR)$(LIB)/demos
	install -c -m 644 minform/* $(DESTDIR)$(LIB)/minform
	install -c -m 644 tutor/* $(DESTDIR)$(LIB)/tutor
	install -c -m 644 i6.6 $(DESTDIR)$(MANDIR)
	gzip $(DESTDIR)$(MANDIR)/i6.6
	ln -s $(LIB)/minform/grammar.h $(DESTDIR)$(LIB)/minform/Grammar.h
	ln -s $(LIB)/minform/parser.h $(DESTDIR)$(LIB)/minform/Parser.h
	ln -s $(LIB)/minform/verblib.h $(DESTDIR)$(LIB)/minform/VerbLib.h

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(MAIN)
	rm -f $(DESTDIR)$(PREFIX)/bin/i6
	rm -f $(DESTDIR)$(MANDIR)/i6.6.gz
	rm -rf $(DESTDIR)$(LIB)
