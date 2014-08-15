//
//  StickyView.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/13.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "StickyView.h"

@interface StickyView ()


@end

@implementation StickyView

- (instancetype)initWithFrame:(CGRect)frame
                       Sticky:(Sticky*)sticky
                        Index:(NSInteger)index
{
    self = [super initWithFrame:frame];
    
    if(self){
        //add imageView
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 333.0)];
        iv.image = [UIImage imageNamed:sticky.background];
        [self addSubview:iv];
        
//        //add label
//        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 66.0, 200.0, 200.0)];
//        l.lineBreakMode = NSLineBreakByWordWrapping;
//        l.numberOfLines = 0;
//        l.text = [NSString stringWithFormat:@"%@\n\nby %@", sticky.content, sticky.poster];
//        [self addSubview:l];

        //add textView
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(60.0, 66.0, 200.0, 200.0)];
        tv.text = [NSString stringWithFormat:@"%@\n\nby %@", sticky.content, sticky.poster];
        tv.backgroundColor = nil;
        tv.font = [UIFont systemFontOfSize:18.0];
        [tv setContentInset:UIEdgeInsetsMake(20.0, 0, 0, 0)];
        tv.editable = NO;
        [self addSubview:tv];
        
        //add delete Btn
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(36.0, 50.0, 36.0, 36.0)];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"icn_del"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(pressDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delBtn];
        
        //set index
        self.stickyindex = index;
    }
    
    return self;
}

- (void)pressDeleteBtn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确认删除这条通知？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    
//    [self.delegate onPressDeleteButtonOfStickyViewWithIndex:self.stickyindex];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1){
        [self.delegate onPressDeleteButtonOfStickyViewWithIndex:self.stickyindex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end




















