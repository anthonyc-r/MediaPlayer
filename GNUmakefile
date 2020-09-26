#
# An example GNUmakefile
#

# Include the common variables defined by the Makefile Package
include $(GNUSTEP_MAKEFILES)/common.make

OPTFLAGS="-g"

# Build a simple Objective-C program
VERSION = 0.1
PACKAGE_NAME = MediaPlayer
APP_NAME = MediaPlayer
MediaPlayer_APPLICATION_ICON = MediaPlayer.tiff

# The Objective-C files to compile
MediaPlayer_OBJC_FILES = AppDelegate.m VideoWindow.m
		
MediaPlayer_H_FILES = AppDelegate.h VideoWindow.h

MediaPlayer_RESOURCE_FILES = Resources/Application.gorm Resources/MediaPlayer.tiff \
	MediaPlayerInfo.plist


-include GNUmakefile.preamble

# Include in the rules for making GNUstep command-line programs
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make

UNAME_OS := $(shell uname -s)
ifeq ($(UNAME_OS), OpenBSD)
	ADDITIONAL_LDFLAGS += -L/usr/X11R6/lib
endif

ADDITIONAL_LDFLAGS += -lmpv
ADDITIONAL_FLAGS += -std=gnu99
-include GNUmakefile.postamble
