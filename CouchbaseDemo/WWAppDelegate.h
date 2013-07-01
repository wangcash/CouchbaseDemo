//
//  WWAppDelegate.h
//  CouchbaseDemo
//
//  Created by Cash on 13-6-30.
//  Copyright (c) 2013年 imwangwei.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBLDatabase;

@interface WWAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) CBLDatabase *database;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
