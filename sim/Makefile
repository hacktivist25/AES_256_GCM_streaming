.PHONY: help all h_init GHASH clean

.DEFAULT_GOAL := help

help:
	@echo "available targets :"
	@echo "  make h_init       - Test of module H_init"
	@echo "  make GHASH        - Test of module GHASH"
	@echo "  make clean        - Clean all simulations"
	
all: h_init GHASH

h_init:
	$(MAKE) -C tests/GHASH_submodules/H_init -f Makefile.H_init.mk

GHASH:
	$(MAKE) -C tests/GHASH -f Makefile.GHASH.mk

clean:
	$(MAKE) -C tests/GHASH_submodules/H_init -f Makefile.H_init.mk clean
	$(MAKE) -C tests/GHASH -f Makefile.GHASH.mk