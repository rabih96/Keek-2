include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Keek2Client
Keek2Client_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
