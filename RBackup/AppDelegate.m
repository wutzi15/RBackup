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

NSString *InString;
NSString *OutString;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)ChooseInputPath:(id)sender
{
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:FALSE];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton ) {
        
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        
        // Loop through the files and process them.
        for(int i = 0; i < [files count]; i++ ) {
            
            // Do something with the filename.
            InString = [[files objectAtIndex:i] path];
            NSLog(@"In path: %@", InString);
            [InputPath setStringValue: InString];
        }
        
    }
}

- (IBAction)ChooseOutputPath:(id)sender
{
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:FALSE];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton ) {
        
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        
        // Loop through the files and process them.
        for(int i = 0; i < [files count]; i++ ) {
            
            // Do something with the filename.
            OutString = [[files objectAtIndex:i] path];
            NSLog(@"Out path: %@", OutString);
            [OutputPath setStringValue: OutString];
        }
        
    }

}

- (void) copyData:(NSFileHandle*) handle
{
    NSString *string= [[NSString alloc]initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding ];
    [textview setString:string];
}

- (IBAction)DoBackup:(id)sender
{
    if ( [allTrim( InString ) length] == 0 ) {
        NSRunCriticalAlertPanel(@"Input Path empty!", @"Input Path cannot be emtpy. Please try again.", @"Ok", nil, nil);
        return;
    }
    if ( [allTrim( OutString ) length] == 0 ) {
        NSRunCriticalAlertPanel(@"Output Path empty!", @"Output Path cannot be emtpy. Please try again.", @"Ok", nil, nil);
        return;
    }
    NSLog(@"Backing up from %@ to %@", InString, OutString);
    
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
    [NSThread detachNewThreadSelector:@selector(copyData) toTarget:self withObject:handle];
    [SpinWheel stopAnimation:self];
  
 
}

@end
