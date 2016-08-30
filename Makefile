export ARCHS = armv7 armv7s arm64
export THEOS_DEVICE_IP=192.168.1.68
export THEOS_DEVICE_PORT=22

#GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Keek2
Keek2_FILES = Tweak.xm KNCViewController.xm KeekDataProvider.xm KeekCardView.xm CDTContextHostProvider.xm KCCCardListView.m KCCCardView.m KeekIconView.m KCCIconListView.m
Keek2_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
Keek2_CFLAGS = -fobjc-arc -w
Keek2_LDFLAGS += -Wl,-segalign,4000
Keek2_LIBRARIES = substrate rocketbootstrap
Keek2_PRIVATE_FRAMEWORKS = AppSupport UIKit BackBoardServices
Keek2_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall backboardd"
SUBPROJECTS += keek2
#SUBPROJECTS += keek2client
include $(THEOS_MAKE_PATH)/aggregate.mk
