//
//  InputViewController.m
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *bodyView;


@end

@implementation InputViewController

- (IBAction)doneButtonPressed:(id)sender
{
    if ([self.titleField.text isEqualToString:@""] || self.titleField.text == nil) {
        [self.delegate inputViewControllerDidCancel:self];
    } else {
        [self.delegate inputViewController:self
                         didFinishWithTitle:self.titleField.text
                                   withBody:self.bodyView.text];
    }
}

@end
