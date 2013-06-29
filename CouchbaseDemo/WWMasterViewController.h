//
//  WWMasterViewController.h
//  CouchbaseDemo
//
//  Created by Cash on 13-6-30.
//  Copyright (c) 2013年 imwangwei.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWDetailViewController;

@interface WWMasterViewController : UITableViewController

@property (strong, nonatomic) WWDetailViewController *detailViewController;

@end
