//
//  AppDelegate.h
//  RBackup
//
//  Created by wutzi on 26.08.12.
//  Copyright (c) 2012 wutzi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
- (IBAction)ChooseInputPath:(id)sender;
- (IBAction)ChooseOutputPath:(id)sender;
@property (weak) IBOutlet NSTextField *InputPath;
@property (weak) IBOutlet NSTextField *OutputPath;
- (IBAction)DoBackup:(id)sender;
@property (weak) IBOutlet NSProgressIndicator *SpinWheel;
@property (unsafe_unretained) IBOutlet NSTextView *textview;

-(void) Save;
-(void) Load;


@end
