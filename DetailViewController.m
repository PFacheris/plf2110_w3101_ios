//
//  DetailViewController.m
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import "DetailViewController.h"
#import "InputViewController.h"

@interface DetailViewController () <InputViewControllerDelegate>

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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    inputVC.imageView.image = [UIImage imageWithContentsOfFile:
                            [documentsDirectory stringByAppendingPathComponent:self.note[@"ImagePath"]]
                            ];
    [inputVC.imageView setNeedsDisplay];
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
    [self reloadUI];
    [self.delegate detailViewControllerDidUpdate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputViewControllerDidCancel:(InputViewController *)inVc
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}



@end
