SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl

# Paths
SIM_DIR := $(abspath $(CURDIR)/../..)
RTL_DIR := $(abspath $(SIM_DIR)/../rtl)

export PYTHONPATH := $(SIM_DIR)

# Import source lists
include $(SIM_DIR)/sources.mk

# Select compilation sources
VHDL_SOURCES := $(UTILS_PKG_SOURCES)
VHDL_SOURCES += $(XTIME_128_SOURCES)
VHDL_SOURCES += $(COUNTER_SOURCES)
VHDL_SOURCES += $(MULTH_32WAY_SOURCES)
VHDL_SOURCES += $(H_INIT_SOURCES)
VHDL_SOURCES += $(H_POWER_BANK_SOURCES)

# top
VHDL_SOURCES += $(GHASH_SOURCES)

# DUT and tests
TOPLEVEL = ghash_2x4way
MODULE = GHASH_coco

COMPILE_ARGS += --std=08

# visualise the waveform
#SIM_ARGS += --wave=waves.ghw

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf sim_build
	rm -rf __pycache__
	rm -f results.xml
	rm -f waves.ghw
	rm -f *.cf
	rm -f *.o
	rm -f *.exe
	rm -f *.pyc