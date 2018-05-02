PACKAGE := drylang
VERSION := $(shell cat VERSION)

SOURCES :=

TARGETS :=     \
  bin/analyze  \
  bin/check    \
  bin/compile  \
  bin/describe \
  bin/evaluate \
  bin/execute  \
  bin/export   \
  bin/format   \
  bin/index    \
  bin/locate   \
  bin/optimize \
  bin/parse    \
  bin/shell

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

_build/default/bin/%.exe: bin/%.ml
	$(DUNE) build $(@:_build/default/%=%)

bin/%: _build/default/bin/%.exe
	ln -f $< $@

all: build

build: $(TARGETS)

check:
	$(DUNE) runtest

dist:
	@echo "not implemented"; exit 2 # TODO

installdirs: $(TARGETS)
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(libexecdir)/$(PACKAGE)

install: installdirs $(TARGETS)
	$(INSTALL_PROGRAM) bin/dry $(DESTDIR)$(bindir)/dry
	$(foreach file,$(TARGETS),$(INSTALL_PROGRAM) $(file) $(DESTDIR)$(libexecdir)/$(PACKAGE)/$(file:bin/%=%);)

install-strip: installdirs $(TARGETS)
	$(INSTALL_PROGRAM) bin/dry $(DESTDIR)$(bindir)/dry
	$(foreach file,$(TARGETS),$(INSTALL_PROGRAM) -s $(file) $(DESTDIR)$(libexecdir)/$(PACKAGE)/$(file:bin/%=%);)

uninstall:
	rm -f $(DESTDIR)$(bindir)/dry
	$(foreach file,$(TARGETS),rm -f $(DESTDIR)$(libexecdir)/$(PACKAGE)/$(file:bin/%=%);)

clean:
	@rm -f *~ $(TARGETS)
	$(DUNE) clean

distclean: clean

mostlyclean: clean

.PHONY: check dist installdirs install install-strip clean distclean mostlyclean
.SECONDARY:
.SUFFIXES:
