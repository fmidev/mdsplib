LIB = mdsplib

# $Id$

CC = gcc
#CC = clang

#CFLAGS = -g -O2 -fPIC -DDEBUGZZ
#CFLAGS = -g -O0 -fPIC -DDEBUGZZ
#CFLAGS = -g -Os -fPIC
CFLAGS = -g -O2 -fPIC
#CFLAGS = -g -O0 -fPIC

prosessor := $(shell uname -p)

ifeq ($(origin PREFIX), undefined)
  PREFIX = /usr
else
  PREFIX = $(PREFIX)
endif

ifeq ($(prosessor), x86_64)
  libdir = $(PREFIX)/lib64
else
  libdir = $(PREFIX)/lib
endif

bindir = $(PREFIX)/bin
includedir = $(PREFIX)/include


LIBS = 

library: libmetar.a

release: all
all: metar_test library

libmetar.a: src/antoi.o src/charcmp.o src/decode_metar.o src/decode_metar_remark.o src/fracpart.o src/print_decoded_metar.o src/stspack2.o src/stspack3.o
	ar ruv libmetar.a src/antoi.o src/charcmp.o src/decode_metar.o src/decode_metar_remark.o src/fracpart.o src/print_decoded_metar.o src/stspack2.o src/stspack3.o
	ranlib libmetar.a

metar_test: src/metar_test.o libmetar.a
	$(CC) $(CFLAGS) -o metar_test src/metar_test.o libmetar.a $(LIBS)

src/antoi.o: src/antoi.c src/local.h
	$(CC) $(CFLAGS) -c src/antoi.c -o src/antoi.o

src/charcmp.o: src/charcmp.c src/local.h
	$(CC) $(CFLAGS) -c src/charcmp.c -o src/charcmp.o

src/decode_metar.o: src/decode_metar.c src/metar_structs.h
	$(CC) $(CFLAGS) -c src/decode_metar.c -o src/decode_metar.o

src/decode_metar_remark.o: src/decode_metar_remark.c src/metar_structs.h
	$(CC) $(CFLAGS) -c src/decode_metar_remark.c -o src/decode_metar_remark.o

src/metar_test.o: src/metar_test.c src/metar_structs.h
	$(CC) $(CFLAGS) -c src/metar_test.c -o src/metar_test.o

src/fracpart.o: src/fracpart.c src/local.h
	$(CC) $(CFLAGS) -c src/fracpart.c -o src/fracpart.o

src/print_decoded_metar.o: src/print_decoded_metar.c src/metar_structs.h
	$(CC) $(CFLAGS) -c src/print_decoded_metar.c -o src/print_decoded_metar.o

src/stspack2.o: src/stspack2.c src/local.h
	$(CC) $(CFLAGS) -c src/stspack2.c -o src/stspack2.o

src/stspack3.o: src/stspack3.c src/local.h
	$(CC) $(CFLAGS) -c src/stspack3.c -o src/stspack3.o

install: library
	mkdir -p $(includedir)
	mkdir -p $(libdir)
	install -m 0644 libmetar.a $(libdir)/
	ranlib $(libdir)/libmetar.a
	install -m 0644 include/metar.h $(includedir)
	install -m 0644 src/metar_structs.h $(includedir)
	install -m 0644 src/local.h $(includedir)/local.h

rpm: clean
	if [ -e $(LIB).spec ]; \
	then \
	  tar -czvf $(LIB).tar.gz --transform "s,^,$(LIB)/," * ; \
	  rpmbuild -tb $(LIB).tar.gz ; \
	  rm -f $(LIB).tar.gz ; \
	else \
	  echo $(LIB).spec file missing; \
	fi;
test:	metar_test
	./metar_test

.PHONY : clean
clean:
ifeq ($(OS), Windows_NT)
	echo off
	del /q src\*.o
	del /q metar_test.exe 
	del /q libmetar.a
	echo on
else
	rm -f libmetar.a src/*.o src/*.a metar_test
endif
