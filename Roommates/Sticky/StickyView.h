//
//  StickyView.h
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/13.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sticky.h"

@interface StickyView : UIView <UIAlertViewDelegate>

@property (weak, nonatomic) id delegate;
@property (nonatomic) NSInteger stickyindex;

- (instancetype)initWithFrame:(CGRect)frame
                       Sticky:(Sticky*)sticky
                        Index:(NSInteger)index;

@end

@protocol StickyViewDelegate

- (void) onPressDeleteButtonOfStickyViewWithIndex:(NSInteger)index;

@end
