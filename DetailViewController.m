//
//  DetailViewController.m
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "InputViewController.h"

@interface DetailViewController () <InputViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *dateView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadUI];
    self.textView.editable = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    self.dateView.text = [dateFormatter stringFromDate:self.note[@"Date"]];
    self.dateView.editable = NO;
    
}

- (void)reloadUI {
    self.title = self.note[@"Title"];
    self.textView.text = self.note[@"Body"];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.imageView.image = [UIImage imageWithContentsOfFile:
                                [documentsDirectory stringByAppendingPathComponent:self.note[@"ImagePath"]]
                            ];
}

#pragma mark - Interface Actions

- (IBAction)deleteButtonPressed:(id)sender {
    [self.delegate detailViewControllerDidDelete:self];
}

- (IBAction)editButtonPressed:(id)sender {
    InputViewController *inputVC = [self.storyboard instantiateViewControllerWithIdentifier:@"incontroller"];
    inputVC.delegate = self;
    
    [self.navigationController pushViewController:inputVC
                                         animated:YES];
    [inputVC view];
    inputVC.bodyView.text = self.note[@"Body"];
    inputVC.titleField.text = self.note[@"Title"];
    inputVC.imagePath = [self.note objectForKey:@"ImagePath"];
    if (inputVC.imagePath)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        inputVC.imageView.image = [UIImage imageWithContentsOfFile:
                                   [documentsDirectory stringByAppendingPathComponent:self.note[@"ImagePath"]]
                                   ];
        [inputVC.addImageButton setTitle:@"Remove Image" forState:UIControlStateNormal];
        [inputVC.imageView setNeedsDisplay];
    }
}

- (IBAction)shareButtonPressed:(id)sender {
    if ( [MFMailComposeViewController canSendMail] ) {
        NSString *subject = self.note[@"Title"];
        NSArray *recipient = [NSArray arrayWithObject:@"test@email.com"];
        NSString *body = self.note[@"Body"];
    
        APP.globalMailComposer.mailComposeDelegate = self;
        [APP.globalMailComposer setSubject:subject];
        [APP.globalMailComposer setToRecipients:recipient];
        [APP.globalMailComposer setMessageBody:body isHTML:NO];
    
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSData *fileData = [NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:self.note[@"ImagePath"]]
        ];
        NSString *mimeType = @"image/jpeg";
    
        [APP.globalMailComposer addAttachmentData:fileData mimeType:mimeType fileName:[[self.note[@"Title"] stringByAppendingString:@".jpeg"] stringByStandardizingPath]];
    
        [self presentViewController:APP.globalMailComposer animated:YES completion:nil];
    }
    else
    {
        [APP cycleMailComposer];
    }
}

#pragma mark - InputViewControllerDelegate Methods
- (void)inputViewController:(InputViewController *)inVc
         didFinishWithTitle:(NSString *)title
                   withBody:(NSString *)body
              withImagePath:(NSString *)imagePath
{
    self.note[@"Title"] = title;
    self.note[@"Body"] = body;
    self.note[@"ImagePath"] = imagePath;
    [self reloadUI];
    [self.delegate detailViewControllerDidUpdate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputViewController:(InputViewController *)inVc
         didFinishWithTitle:(NSString *)title
                   withBody:(NSString *)body
{
    self.note[@"Title"] = title;
    self.note[@"Body"] = body;
    [self.note removeObjectForKey:@"ImagePath"];
    [self reloadUI];
    [self.delegate detailViewControllerDidUpdate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputViewControllerDidCancel:(InputViewController *)inVc
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate Methods
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^
     { [APP cycleMailComposer]; }
     ];
}



@end
