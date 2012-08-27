//
//  AppDelegate.m
//  RBackup
//
//  Created by wutzi on 26.08.12.
//  Copyright (c) 2012 wutzi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize SpinWheel;
@synthesize textview;
@synthesize InputPath;
@synthesize OutputPath;

NSString *InString, *OutString;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self Load];
}

- (IBAction)ChooseInputPath:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:FALSE];
    

    if ( [openDlg runModal] == NSOKButton ) {
        NSArray *files = [openDlg URLs];
        for(int i = 0; i < [files count]; i++ ) {
            NSString *_InString = [[files objectAtIndex:i] path];
            NSLog(@"In path: %@", _InString);
            [InputPath setStringValue: _InString];
            [self Load];
        }
    }
}

- (IBAction)ChooseOutputPath:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:FALSE];
    

    if ( [openDlg runModal] == NSOKButton ) {
        NSArray *files = [openDlg URLs];
        for(int i = 0; i < [files count]; i++ ) {
            NSString *_OutString = [[files objectAtIndex:i] path];
            NSLog(@"Out path: %@", _OutString);
            [OutputPath setStringValue: _OutString];
            [self Save];
        }
    }
}

- (void) copyData:(NSFileHandle*) handle
{
    NSString *string= [[NSString alloc]initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding ];
    [textview setString:string];
}

- (void) startTask {
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/rsync"];
    
    
    [task setArguments: [NSArray arrayWithObjects:@"-avz", @"--stats",@"-h",@"--progress",  InString , OutString, nil]];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *handle;
    handle = [pipe fileHandleForReading];
    
    [SpinWheel startAnimation:self];
    [task launch];
    [NSThread detachNewThreadSelector:@selector(copyData:) toTarget:self withObject:handle];
    [task waitUntilExit];
    [SpinWheel stopAnimation:self];
}

- (IBAction)DoBackup:(id)sender
{
    InString = [InputPath stringValue];
    OutString = [OutputPath stringValue];
    if ( [allTrim( InString ) length] == 0 ) {
        NSRunCriticalAlertPanel(@"Input Path empty!", @"Input Path cannot be emtpy. Please try again.", @"Ok", nil, nil);
        return;
    }
    if ( [allTrim( OutString ) length] == 0 ) {
        NSRunCriticalAlertPanel(@"Output Path empty!", @"Output Path cannot be emtpy. Please try again.", @"Ok", nil, nil);
        return;
    }
    NSLog(@"Backing up from %@ to %@", InString, OutString);
    [self performSelectorOnMainThread:@selector(startTask) withObject:nil waitUntilDone:NO];
   // [self performSelectorInBackground:@selector(startTask) withObject:nil];
}

-(void) applicationWillTerminate:(NSNotification *)notification
{
    [self Save];
}

-(void) Save
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *StringIn = [InputPath stringValue];
    NSString *StringOut = [OutputPath stringValue];
    [def setObject:StringIn forKey:@"StringIn"];
    [def setObject:StringOut forKey:@"StringOut"];
    //NSLog(@"saving: in: %@ \t out: %@", StringIn, StringOut);
    
}

-(void) Load
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *StringIn = [def stringForKey:@"StringIn"];
    NSString *StringOut = [def stringForKey:@"StringOut"];
   // NSLog(@"Loaded: in: %@ \t out: %@", StringIn, StringOut);
    [InputPath setStringValue:StringIn];
    [OutputPath setStringValue:StringOut];
}

@end
