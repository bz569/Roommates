//
//  NewStickyViewController.h
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/13.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewStickyViewController : UIViewController

@end

@protocol NewStickyDelegate

- (void)didReturnStickyView;

@end