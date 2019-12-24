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
MediaPlayer_OBJC_FILES = AppDelegate.m VideoWindow.m View/VideoView.m
		
MediaPlayer_H_FILES = AppDelegate.h VideoWindow.h View/VideoView.h

MediaPlayer_RESOURCE_FILES = Resources/Application.gorm


-include GNUmakefile.preamble

# Include in the rules for making GNUstep command-line programs
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make

ADDITIONAL_LDFLAGS += -lmpv
ADDITIONAL_FLAGS += -std=gnu99
-include GNUmakefile.postamble
