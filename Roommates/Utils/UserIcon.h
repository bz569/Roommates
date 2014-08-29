//
//  UserIcon.h
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/29.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserIcon : NSObject

/**
 *  从Parse数据库获取Roommate头像到本地
 */
+ (void)refreshLocalIcons;

/**
 *  获取制定用户头像
 *
 *  @param userID 用户的ID，Parse中PFUser得ObjectId
 *
 *  @return 头像存在返回用户头像，头像不存在返回缺省头像
 */
+ (UIImage*)getIconWithUserID:(NSString*)userID;

@end
