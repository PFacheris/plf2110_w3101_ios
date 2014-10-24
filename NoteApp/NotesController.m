//
//  ViewController.m
//  NoteApp
//
//  Created by Patrick Facheris on 10/22/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import "NotesController.h"
#import "InputViewController.h"

static NSString *const kTableViewCellReuseIdentifier = @"kTableViewCellReuseIdentifier";

@interface NotesController () <UITableViewDelegate, UITableViewDataSource, InputViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *notes;

@end

@implementation NotesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        self.notes = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    
    else
    {
        self.notes = [[NSMutableArray alloc] init];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:kTableViewCellReuseIdentifier];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    NSInteger row = [indexPath row];
    NSDictionary *note = self.notes[row];
    cell.textLabel.text = note[@"Title"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:note[@"Date"]];
    
    return cell;
}

#pragma mark - InputViewControllerDelegate Methods
- (void)inputViewController:(InputViewController *)inVc
         didFinishWithTitle:(NSString *)title
                   withBody:(NSString *)body

{
    NSDictionary *note = @{
        @"Date": [NSDate date],
        @"Title": title,
        @"Body": body
    };
    
    [self.notes addObject:note];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)inputViewControllerDidCancel:(InputViewController *)inVc
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


#pragma mark - Interface Actions

//- (IBAction)addRowButtonPressed:(id)sender
//{
//    [self.notes addObject:[NSString note]];
//    
//    NSInteger rowToAdd = self.notes.count - 1;
//    NSIndexPath *path = [NSIndexPath indexPathForRow:rowToAdd inSection:0];
//    
//    [self.tableView insertRowsAtIndexPaths:@[path]
//                          withRowAnimation:UITableViewRowAnimationTop];
//    
//    
//}

@end
