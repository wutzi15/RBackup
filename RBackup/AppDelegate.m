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
            [InputPath setStringValue: OutString];
        }
        
    }

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
    
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"rsync"];
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"-avz", @"--stats", @"-h","--progress", InString, OutString, nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [SpinWheel startAnimation:self];
    [task launch];
    [SpinWheel stopAnimation:self];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"grep returned:\n%@", string);
    
    

 
}

@end
