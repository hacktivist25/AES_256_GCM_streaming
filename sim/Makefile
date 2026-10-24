.PHONY: help all h_init ghash aes_engine clean

.DEFAULT_GOAL := help

help:
	@echo "available targets :"
	@echo "  make h_init       - Test of module H_init"
	@echo "  make clean        - Clean all simulations"
	
all: h_init autretest

h_init:
	$(MAKE) -C tests/GHASH_submodules/H_init -f Makefile.H_init.mk

autretest:
	$(MAKE) -C tests/GHASH_engine -f Makefile.autretest.mk

clean:
	$(MAKE) -C tests/GHASH_submodules/H_init -f Makefile.H_init.mk clean
	$(MAKE) -C tests/GHASH_engine -f Makefile.autretest.mk