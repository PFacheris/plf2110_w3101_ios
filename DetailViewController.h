//
//  DetailViewController.h
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic) NSInteger index;

@property (nonatomic) NSDictionary *note;

@end