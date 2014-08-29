//
//  UserIcon.h
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/29.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserIcon : NSObject

+ (void)refreshLocalIcons;
+ (UIImage*)getIconWithUserID:(NSString*)userID;

@end
