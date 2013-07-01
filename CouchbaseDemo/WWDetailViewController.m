//
//  WWDetailViewController.m
//  CouchbaseDemo
//
//  Created by Cash on 13-6-30.
//  Copyright (c) 2013年 imwangwei.cn. All rights reserved.
//

#import "WWDetailViewController.h"

#import <CouchbaseLite/CouchbaseLite.h>

@interface WWDetailViewController ()
- (void)configureView;
@end

@implementation WWDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;
    
    // Update the view.
    [self configureView];
  }
}

- (void)configureView
{
  // Update the user interface for the detail item.

  if (self.detailItem) {
    CBLDocument *doc = self.detailItem;
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@\n\ntime:%@\n",
                             doc.documentID,
                             [doc propertyForKey:@"time"]
                             ];
    if ([doc propertyForKey:@"name"]) {
      [desc appendFormat:@"name:%@", [doc propertyForKey:@"name"]];
    }
    if ([doc propertyForKey:@"check"]) {
      [desc appendFormat:@"check:%@", [doc propertyForKey:@"check"]];
    }
    self.detailDescriptionLabel.text = desc;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Detail", @"Detail");
  }
  return self;
}
							
@end
