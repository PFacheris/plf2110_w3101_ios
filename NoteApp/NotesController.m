//
//  ViewController.m
//  NoteApp
//
//  Created by Patrick Facheris on 10/22/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import "NotesController.h"
#import "InputViewController.h"
#import "DetailViewController.h"

static NSString *const kTableViewCellReuseIdentifier = @"kTableViewCellReuseIdentifier";

@interface NotesController () <UITableViewDelegate, UITableViewDataSource, InputViewControllerDelegate, DetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *path;

@property (nonatomic) NSMutableArray *notes;

@end

@implementation NotesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    self.path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.path])
    {
        self.notes = [[NSMutableArray alloc] initWithContentsOfFile:self.path];
    }
    
    else
    {
        self.notes = [[NSMutableArray alloc] init];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)saveNotes {
    [self.notes writeToFile: self.path atomically:YES];
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
    cell.textLabel.textColor = UIColorFromRGB(0x70C2E4);
    cell.detailTextLabel.text = [dateFormatter stringFromDate:note[@"Date"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    NSMutableDictionary *note = self.notes[index];
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dvcontroller"];
    detailVC.index = index;
    detailVC.note = note;
    detailVC.delegate = self;
    
    [self.navigationController pushViewController:detailVC
                                         animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - InputViewControllerDelegate Methods
- (void)inputViewController:(InputViewController *)inVc
         didFinishWithTitle:(NSString *)title
                   withBody:(NSString *)body
{
    NSMutableDictionary *note = [NSMutableDictionary new];
    note[@"Date"] = [NSDate date];
    note[@"Title"] = title;
    note[@"Body"] = body;
    
    [self.notes addObject:note];
    [self saveNotes];
    [self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputViewControllerDidCancel:(InputViewController *)inVc
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - DetailViewControllerDelegate Methods
- (void)detailViewControllerDidDelete:(DetailViewController *)detailVc
{
    [self.notes removeObjectAtIndex:detailVc.index];
    [self saveNotes];
    [self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailViewControllerDidUpdate:(DetailViewController *)detailVc
{
    [self saveNotes];
    [self.tableView reloadData];
}

#pragma mark - Interface Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ListToInput"]) {
        InputViewController *inputVC = segue.destinationViewController;
        inputVC.delegate = self;
    }
}

@end
