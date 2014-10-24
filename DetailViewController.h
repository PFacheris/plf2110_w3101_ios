//
//  DetailViewController.h
//  NoteApp
//
//  Created by Patrick Facheris on 10/24/14.
//  Copyright (c) 2014 Patrick Facheris. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

- (void)detailViewControllerDidDelete:(DetailViewController *)detailVc;

@end

@interface DetailViewController : UIViewController

@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;

@property (nonatomic) NSInteger index;
@property (nonatomic) NSDictionary *note;


@end
