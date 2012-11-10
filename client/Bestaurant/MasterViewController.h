//
//  MasterViewController.h
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//  Copyright (c) 2012 HackPrinceton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
