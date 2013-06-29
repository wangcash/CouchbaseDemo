//
//  WWDetailViewController.h
//  CouchbaseDemo
//
//  Created by Cash on 13-6-30.
//  Copyright (c) 2013年 imwangwei.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
