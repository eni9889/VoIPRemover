ARCHS = armv7 arm64
TARGET =: clang
THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = VoIPRemover
VoIPRemover_FILES = Tweak.xm
VoIPRemover_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += voipremover
include $(THEOS_MAKE_PATH)/aggregate.mk
