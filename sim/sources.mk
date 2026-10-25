# ============================
# COMMON COMPONENTS
# ============================


# ============================
# AES ENGINE COMPONENTS
# ============================




# ============================
# COMPLETE AES ENGINE
# ============================

# ============================
# UTILS PACKAGE
# ============================

UTILS_PKG_SOURCES := \
    $(RTL_DIR)/utils/utils_pkg.vhd

# ============================
# GHASH COMPONENT
# ============================
GHASH_SOURCES := \
    $(RTL_DIR)/sub_modules/GHASH_2x4way.vhd

H_INIT_SOURCES := \
    $(RTL_DIR)/sub_modules/GHASH_submodules/H_init.vhd

MULTH_32WAY_SOURCES := \
    $(RTL_DIR)/sub_modules/GHASH_submodules/multH_32way.vhd
	
COUNTER_SOURCES := \
    $(RTL_DIR)/sub_modules/GHASH_submodules/counter.vhd
	
XTIME_128_SOURCES := \
    $(RTL_DIR)/sub_modules/GHASH_submodules/xtime_128.vhd
	
H_POWER_BANK_SOURCES := \
    $(RTL_DIR)/sub_modules/GHASH_submodules/H_power_bank.vhd