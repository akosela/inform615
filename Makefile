# Makefile
SHELL := /bin/bash
OS := $(shell uname -s)
ifeq ($(findstring gcc, $(CC)), gcc)
	CFLAGS = -O2 -ansi
else
	CFLAGS = -O2 -std=c89
endif
CC = gcc
V = 0

PREFIX = /usr/local
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
	install -c -m 755 bin/inf $(DESTDIR)$(PREFIX)/bin
	install -c -m 644 bin/a8.bin $(DESTDIR)$(LIB)/bin
	install -c -m 644 demos/minform.inf $(DESTDIR)$(LIB)/demos
	install -c -m 644 minform/* $(DESTDIR)$(LIB)/minform
	install -c -m 644 tutor/* $(DESTDIR)$(LIB)/tutor
	install -c -m 644 inf.6 $(DESTDIR)$(MANDIR)
	gzip $(DESTDIR)$(MANDIR)/inf.6
ifeq ($(OS), Darwin)
	@mv $(LIB)/minform/grammar.h $(DESTDIR)$(LIB)/minform/grammar.h.tmp
	@mv $(LIB)/minform/grammar.h.tmp $(DESTDIR)$(LIB)/minform/Grammar.h
	@mv $(LIB)/minform/parser.h $(DESTDIR)$(LIB)/minform/parser.h.tmp
	@mv $(LIB)/minform/parser.h.tmp $(DESTDIR)$(LIB)/minform/Parser.h
	@mv $(LIB)/minform/verblib.h $(DESTDIR)$(LIB)/minform/verblib.h.tmp
	@mv $(LIB)/minform/verblib.h.tmp $(DESTDIR)$(LIB)/minform/VerbLib.h
else
	@ln -s $(LIB)/minform/grammar.h $(DESTDIR)$(LIB)/minform/Grammar.h
	@ln -s $(LIB)/minform/parser.h $(DESTDIR)$(LIB)/minform/Parser.h
	@ln -s $(LIB)/minform/verblib.h $(DESTDIR)$(LIB)/minform/VerbLib.h
endif

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(MAIN)
	rm -f $(DESTDIR)$(PREFIX)/bin/inf
	rm -f $(DESTDIR)$(MANDIR)/inf.6.gz
	rm -rf $(DESTDIR)$(LIB)
