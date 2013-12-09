
# Description

Reads bibtex entries from stdin, and writes a "clean" version of all entries to stdout.

Does the following to clean bibtex entries:

- All field names are lower-cased.

- Entries are sorted by

    - Year
    - Entry type
    - Title
    - Citation key

# Installation

Have a look at the Makefile.
`make install` is probably what you want.
You need a recent version of GHC and cabal.
