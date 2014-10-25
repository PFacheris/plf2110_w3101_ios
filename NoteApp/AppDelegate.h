//
//  AppDelegate.h
//  NoteApp
//
//  Created by Patrick Facheris on 10/22/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;

-(void)cycleMailComposer;

@end

#define APP ((AppDelegate *)[[UIApplication sharedApplication] delegate])
