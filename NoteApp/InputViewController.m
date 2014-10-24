//
//  InputViewController.m
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import "InputViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface InputViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSString *imagePath;

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
        if (self.imagePath) {
            [self.delegate inputViewController:self
                            didFinishWithTitle:self.titleField.text
                                      withBody:self.bodyView.text
                                 withImagePath:self.imagePath];
        }
        else {
            [self.delegate inputViewController:self
                            didFinishWithTitle:self.titleField.text
                                      withBody:self.bodyView.text];
        }
    }
}

- (IBAction)addImageButtonPressed:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1);
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSUUID *uuid = [NSUUID UUID];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[uuid UUIDString]];
    [imageData writeToFile:imagePath atomically:YES];
    
    self.imagePath = [uuid UUIDString];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
