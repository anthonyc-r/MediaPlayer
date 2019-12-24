/*
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <mpv/client.h>
#import <stdlib.h>
#import <stdio.h>
#import "VideoWindow.h"
#import "AppDelegate.h"

static void wakeup(void *context) {
	[(VideoWindow*)context performSelectorInBackground:
		@selector(readEvents) withObject: nil];
}


@implementation VideoWindow

-(void)awakeFromNib {
	NSLog(@"Did awake from nib");
	AppDelegate *delegate = [NSApp delegate];
	[delegate setVideoWindow: self];
}

-(void)close {
	[self closeMPVThenPerform: @selector(_) onTarget: nil withObject: nil];
	[super close];
}


-(void)openFilePath: (NSString*)filePath {
	if (mpv) {
		NSLog(@"MPV already running, closing, then trying again");
		[self closeMPVThenPerform: @selector(openFilePath:) onTarget:
			self withObject: filePath];
		return;
	}
	readingEvents = NO;
	mpv = mpv_create();
	int64_t wid = (intptr_t)[self windowRef];
	mpv_set_option(mpv, "wid", MPV_FORMAT_INT64, &wid);
	mpv_set_option_string(mpv, "input-default-bindings", "yes");
	mpv_request_log_messages(mpv, "warn");
	mpv_initialize(mpv);
	mpv_set_wakeup_callback(mpv, wakeup, self);
	
	const char *cmd[] = {"loadfile", [filePath UTF8String], NULL};
	mpv_command(mpv, cmd);
	[self makeKeyAndOrderFront: self];
}

-(void)closeMPVThenPerform: (SEL)selector onTarget: (id)target withObject: (id)object {
	if (mpv) {
		onMPVCloseSelector = selector;
		onMPVCloseTarget = target;
		onMPVCloseArg = object;
		const char *args[] = {"quit", NULL};
		mpv_command(mpv, args);
	} else {
		onMPVCloseTarget = nil;
		NSLog(@"Already closed");
		[target performSelectorOnMainThread: selector withObject: object
			waitUntilDone: NO];
	}
}

-(void)readEvents {
	if (readingEvents) {
		return;
	}
	NSLog(@"Now reading events");
	readingEvents = YES;
	while (mpv) {
		mpv_event *event = mpv_wait_event(mpv, 0);
		switch (event->event_id) {
		case MPV_EVENT_NONE:
			break;
		case MPV_EVENT_SHUTDOWN:
			NSLog(@"Event shutdown");
			mpv_detach_destroy(mpv);
			mpv = NULL;
			if (onMPVCloseTarget != nil) {
				[onMPVCloseTarget performSelectorOnMainThread: 
					onMPVCloseSelector withObject: onMPVCloseArg
					waitUntilDone: NO];
				onMPVCloseTarget = nil;

			}
			break;
		case MPV_EVENT_LOG_MESSAGE:
			NSLog(@"Event log message");
			struct mpv_event_log_message *msg =
				(struct mpv_event_log_message *)event->data;
			NSLog(@"[%s] %s: %s", msg->prefix, msg->level, 
				msg->text);			
			break;
		case MPV_EVENT_VIDEO_RECONFIG:
			NSLog(@"Event video reconfig");
			break;
		default:
			break;
		}
	}
	readingEvents = NO;
}
@end
