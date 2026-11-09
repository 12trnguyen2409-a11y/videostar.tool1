ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VideoStarTool
VideoStarTool_FILES = Tweak.x
VideoStarTool_FRAMEWORKS = UIKit Foundation
VideoStarTool_LDFLAGS = -undefined dynamic_lookup

include $(THEOS_MAKE_PATH)/tweak.mk
