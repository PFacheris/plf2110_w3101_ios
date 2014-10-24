//
//  InputViewController.m
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import "InputViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface InputViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *bodyView;
@property (nonatomic) NSInteger index;


@end

@implementation InputViewController

- (void)loadView {
    [super loadView];
    self.bodyView.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
    self.bodyView.layer.borderWidth = .5;
    self.bodyView.layer.cornerRadius = 5;
    self.bodyView.clipsToBounds = YES;
}

-(IBAction)titleFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.titleField isFirstResponder] && [touch view] != self.titleField) {
        [self.titleField resignFirstResponder];
    }
    if ([self.bodyView isFirstResponder] && [touch view] != self.bodyView) {
        [self.bodyView resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)saveButtonPressed:(id)sender
{
    if ([self.titleField.text isEqualToString:@""] || self.titleField.text == nil) {
        [self.delegate inputViewControllerDidCancel:self];
    } else {
        if (self.index)
        {
            [self.delegate inputViewController:self
                            didFinishWithTitle:self.titleField.text
                                      withBody:self.bodyView.text
                                     withIndex:self.index];
        }
        else {
            [self.delegate inputViewController:self
                            didFinishWithTitle:self.titleField.text
                                      withBody:self.bodyView.text];
        }
    }
}

@end
