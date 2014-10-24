//
//  DetailViewController.m
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITextView *dateView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.note[@"Title"];
    
    self.textView.text = self.note[@"Body"];
    self.textView.editable = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    self.dateView.text = [dateFormatter stringFromDate:self.note[@"Date"]];
    self.dateView.editable = NO;
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.delegate detailViewControllerDidDelete:self];
}

@end
