DUNE   ?= jbuilder
PANDOC ?= pandoc

PACKAGE :=
VERSION := $(shell cat VERSION)

SOURCES :=

TARGETS := bin/describe bin/export bin/shell

%.html: %.rst
	$(PANDOC) -o $@ -t html5 -s $<

all: build

_build/default/bin/describe.exe: bin/describe.ml
	$(DUNE) build bin/describe.exe

_build/default/bin/export.exe: bin/export.ml
	$(DUNE) build bin/export.exe

_build/default/bin/shell.exe: bin/shell.ml
	$(DUNE) build bin/shell.exe

bin/describe: _build/default/bin/describe.exe
	ln -f $< $@

bin/export: _build/default/bin/export.exe
	ln -f $< $@

bin/shell: _build/default/bin/shell.exe
	ln -f $< $@

build: $(TARGETS)

check:
	$(DUNE) runtest

dist:
	@echo "not implemented"; exit 2 # TODO

install:
	@echo "not implemented"; exit 2 # TODO

uninstall:
	@echo "not implemented"; exit 2 # TODO

clean:
	@rm -f *~ $(TARGETS)
	$(DUNE) clean

distclean: clean

mostlyclean: clean

.PHONY: check dist install clean distclean mostlyclean
.SECONDARY:
.SUFFIXES:
