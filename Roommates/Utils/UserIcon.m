//
//  UserIcon.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/29.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "UserIcon.h"
#import <Parse/Parse.h>

@implementation UserIcon

+ (void)refreshLocalIcons
{
    PFUser *curUser = [PFUser currentUser];
    NSString *roomID = curUser[@"roomID"];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"roomID" equalTo:roomID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFUser *user in objects){
            PFFile *iconFile = user[@"icon"];
            
            if(iconFile)
            {
                NSData *iconData = [iconFile getData];
            
                //将图片保存在本地Docums/Icons文件夹中
                NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *iconsPath = [documentsPath stringByAppendingString:@"/Icons"];
                NSLog(@"iconsPath=%@", iconsPath);
            
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createDirectoryAtPath:iconsPath withIntermediateDirectories:YES attributes:nil error:nil];
            
                //设置图片名称
                NSString *imageName = [NSString stringWithFormat:@"icon_%@.png", user.objectId];
                NSString *imagePath = [iconsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", imageName]];
                NSLog(@"imagePath=%@", imagePath);
            
                //保存图片
                [fileManager createFileAtPath:imagePath contents:iconData attributes:nil];
            }
        }
    }];
}



+ (UIImage*)getIconWithUserID:(NSString*)userID
{
    UIImage *iconImage;
    
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *iconsPath = [documentsPath stringByAppendingString:@"/Icons"];
    NSString *imageName = [NSString stringWithFormat:@"icon_%@.png", userID];
    NSString *imagePath = [iconsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", imageName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:NO]) {
        iconImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    
    return iconImage;
}



@end
