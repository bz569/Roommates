//
//  MessageCell.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/16.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //聊天内容
        self.tv_messageContent = [[UITextView alloc] init];
        self.tv_messageContent.editable = NO;
        self.tv_messageContent.scrollEnabled = NO;
        [self.contentView sizeToFit];
        [self.contentView addSubview:self.tv_messageContent];
        
        //头像
        self.iv_userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.iv_userIcon];
        
    }
    
    return self;
}


@end
