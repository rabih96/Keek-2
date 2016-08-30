TARGET = :clang::5.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Keek2
Keek2_FILES = $(wildcard *.m) $(wildcard *.x)
Keek2_INSTALL_PATH = /Library/PreferenceBundles
Keek2_FRAMEWORKS = CoreGraphics UIKit
Keek2_PRIVATE_FRAMEWORKS = Preferences
Keek2_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
Keek2_WEAK_FRAMEWORKS = ContactsUI
Keek2_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Keek2.plist$(ECHO_END)
