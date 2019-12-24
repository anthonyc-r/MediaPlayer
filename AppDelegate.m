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

#import "AppDelegate.h"


@implementation AppDelegate 

//-GSFilePat

-(void)applicationDidFinishLaunching: (NSNotification*)aNotification {
	NSLog(@"NSApp did finish launching..");
	[NSBundle loadNibNamed: @"Application" owner: self];
	NSArray *args = [[NSProcessInfo processInfo] arguments];
	NSUInteger pathArgIdx = [args indexOfObject: @"-GSFilePath"];
	if (pathArgIdx != NSNotFound) {
		NSString *pathArg = args[pathArgIdx + 1];
		[videoWindow openFilePath: pathArg];
	}
}

-(void)setVideoWindow: (VideoWindow*)aVideoWindow {
	videoWindow = aVideoWindow;
}

-(void)openDocument: (id)sender {
	NSLog(@"open document");
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel runModal];
	NSURL *selectedURL = [[openPanel URLs] firstObject];
	[videoWindow openFilePath: [selectedURL path]];
}

-(BOOL)application: (NSApplication*)sharedApplication openFile: (NSString*)path {
	NSLog(@"app received open app");
	[videoWindow openFilePath: path];
	// TODO: - Actually check if it opens.
	return YES;
}

@end

int main(int argc, char **argv) {	
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSApplication *app = [NSApplication sharedApplication];
	AppDelegate *delegate = [AppDelegate new];
	[app setDelegate: delegate];
	[app run];
	[pool release];
	return 0;
}
