### Makefile: Epeira socket ###

PREFIX  ?= /usr/local
BINDIR  ?= $(PREFIX)/bin
CC      ?= cc
PKG_CONFIG ?= pkg-config

TARGET  = epeira_socket
SOURCE  = epeira_socket.c

GTK_CFLAGS := $(shell $(PKG_CONFIG) --cflags gtk+-3.0)
GTK_LIBS   := $(shell $(PKG_CONFIG) --libs gtk+-3.0)

CFLAGS  ?= -O2
CFLAGS  += -Wall -Wextra $(GTK_CFLAGS)
LDLIBS  += $(GTK_LIBS) -lX11

.PHONY: all install clean

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

install: $(TARGET)
	install -d "$(DESTDIR)$(BINDIR)"
	install -m 755 $(TARGET) "$(DESTDIR)$(BINDIR)/$(TARGET)"

clean:
	rm -f $(TARGET)

