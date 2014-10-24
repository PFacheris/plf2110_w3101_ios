//
//  InputViewController.h
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputViewController;

@protocol InputViewControllerDelegate <NSObject>

- (void)inputViewController:(InputViewController *)inVc
         didFinishWithTitle:(NSString *)title
                   withBody:(NSString *)body;

- (void)inputViewControllerDidCancel:(InputViewController *)inVc;

@end

@interface InputViewController : UIViewController

@property (nonatomic, weak) id<InputViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *bodyView;

@end
