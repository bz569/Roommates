//
//  Roommate.h
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/28.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Roommate : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) UIImage *icon;

@end
