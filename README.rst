***
DRY
***

.. image:: https://img.shields.io/badge/license-Public%20Domain-blue.svg
   :alt: Project license
   :target: https://unlicense.org

.. image:: https://img.shields.io/travis/dryproject/drylang/master.svg
   :alt: Travis CI build status
   :target: https://travis-ci.org/dryproject/drylang

|

*An experimental programming language.*

Prerequisites
=============

Build Prerequisites
-------------------

* `OCaml <https://ocaml.org>`__
  4.06+

* `Dune (aka Jbuilder) <https://github.com/ocaml/dune>`__
  1.0+beta20

* `GNU Make <https://www.gnu.org/software/make/>`__
  3.81+

Runtime Prerequisites
---------------------

The installed binaries have no runtime requirements or dependencies beyond
the system's standard library (``libc``).

Caveats
=======

**Here be dragons**.

**Caveat utilitor**: assume nothing works, and you may be pleasantly
surprised; and when it breaks, you get to keep both pieces.

Installation
============

Installation on Unix
--------------------

::

   $ make && sudo make install

Configuration
=============

::

   $ export DRY_ROOT=$HOME/.dry

   $ mkdir -p $DRY_ROOT

   $ cd $DRY_ROOT && git clone https://github.com/dryproject/drylib.git drylib

Usage
=====

::

   $ dry analyze --help         # analyze code
   $ dry check --help           # type-check code
   $ dry compile --help         # compile program
   $ dry describe --help        # describe a term
   $ dry evaluate --help        # evaluate code
   $ dry execute --help         # execute function
   $ dry export --help          # export terms into a target language
   $ dry format --help          # reformat code
   $ dry index --help           # show the package index
   $ dry locate --help          # locate the source file for a term
   $ dry optimize --help        # optimize code
   $ dry parse --help           # parse code
   $ dry shell --help           # the interactive DRY shell
