PACKAGE := drylang
VERSION := $(shell cat VERSION)

SOURCES :=

TARGETS := bin/analyze bin/describe bin/export bin/index bin/locate bin/parse bin/shell

DUNE    ?= jbuilder
PANDOC  ?= pandoc
TAR     ?= tar

INSTALL ?= install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA    = $(INSTALL) -m 644

prefix     ?= /usr/local
exec_prefix = $(prefix)
bindir      = $(exec_prefix)/bin
libexecdir  = $(exec_prefix)/libexec

%.html: %.rst
	$(PANDOC) -o $@ -t html5 -s $<

all: build

_build/default/bin/analyze.exe: bin/analyze.ml
	$(DUNE) build bin/analyze.exe

_build/default/bin/describe.exe: bin/describe.ml
	$(DUNE) build bin/describe.exe

_build/default/bin/export.exe: bin/export.ml
	$(DUNE) build bin/export.exe

_build/default/bin/index.exe: bin/index.ml
	$(DUNE) build bin/index.exe

_build/default/bin/locate.exe: bin/locate.ml
	$(DUNE) build bin/locate.exe

_build/default/bin/parse.exe: bin/parse.ml
	$(DUNE) build bin/parse.exe

_build/default/bin/shell.exe: bin/shell.ml
	$(DUNE) build bin/shell.exe

bin/analyze: _build/default/bin/analyze.exe
	ln -f $< $@

bin/describe: _build/default/bin/describe.exe
	ln -f $< $@

bin/export: _build/default/bin/export.exe
	ln -f $< $@

bin/index: _build/default/bin/index.exe
	ln -f $< $@

bin/locate: _build/default/bin/locate.exe
	ln -f $< $@

bin/parse: _build/default/bin/parse.exe
	ln -f $< $@

bin/shell: _build/default/bin/shell.exe
	ln -f $< $@

build: $(TARGETS)

check:
	$(DUNE) runtest

dist:
	@echo "not implemented"; exit 2 # TODO

installdirs: $(TARGETS)
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(libexecdir)/$(PACKAGE)

install: installdirs $(TARGETS)
	$(foreach file,$(TARGETS),$(INSTALL_PROGRAM) $(file) $(DESTDIR)$(libexecdir)/$(PACKAGE)/$(file:bin/%=%);)

install-strip: installdirs $(TARGETS)
	$(foreach file,$(TARGETS),$(INSTALL_PROGRAM) -s $(file) $(DESTDIR)$(libexecdir)/$(PACKAGE)/$(file:bin/%=%);)

uninstall:
	$(foreach file,$(TARGETS),echo rm -f $(DESTDIR)$(libexecdir)/$(PACKAGE)/$(file:bin/%=%);)

clean:
	@rm -f *~ $(TARGETS)
	$(DUNE) clean

distclean: clean

mostlyclean: clean

.PHONY: check dist installdirs install install-strip clean distclean mostlyclean
.SECONDARY:
.SUFFIXES:
