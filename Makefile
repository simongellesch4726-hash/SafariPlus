export SIMJECT ?= 0
export ROOTLESS ?= 0
export NO_DEPENDENCIES ?= 0
export DEBUG_LOGGING ?= 0
export NO_LIBCOLORPICKER ?= 0

# ROOTLESS=1 remains supported for conventional rootless packaging.
# RootHide builds set THEOS_PACKAGE_SCHEME=roothide in the build environment.
ifeq ($(ROOTLESS),1)
export THEOS_PACKAGE_SCHEME ?= rootless
export NO_DEPENDENCIES = 1
endif

ifeq ($(SIMJECT),1)
export TARGET = simulator:clang:14.5:8.0
export ARCHS = x86_64
else
export TARGET = iphone:clang:17.0:15.0
export ARCHS = arm64e
endif

ifeq ($(NO_DEPENDENCIES),1)
export NO_LIBCOLORPICKER = 1
endif

export INCLUDES = $(THEOS_PROJECT_DIR)/Shared

include $(THEOS)/makefiles/common.mk

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS = MobileSafari WebContent SpringBoard Preferences

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 MobileSafari"
