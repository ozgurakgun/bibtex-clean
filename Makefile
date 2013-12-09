.PHONY: sandbox-install install clean

CORES = 1

sandbox-install:
	cabal sandbox init
	cabal install -j$(CORES) --bin=bin

install:
	cabal sandbox init
	cabal install -j$(CORES) --bin=$(HOME)/.cabal/bin

clean:
	rm -rf cabal.sandbox.config .cabal-sandbox dist
