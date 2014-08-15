//
//  Sticky.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/12.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "Sticky.h"

@implementation Sticky

- (instancetype)initWithStickyID:(NSString*)stickyID
                          RoomID:(NSString*)roomID
                          Poster:(NSString*)poster
                         Content:(NSString*)content
                      Background:(NSString*)background
                       CreatedAt:(NSDate*)createdDate
{
    self = [super init];
    
    if(self){
        self.stickyID = stickyID;
        self.roomID = roomID;
        self.poster = poster;
        self.content = content;
        self.background = background;
        self.createdDate = createdDate;
    }
    
    return self;
}

- (instancetype)initWithRoomID:(NSString*)roomID
                        Poster:(NSString*)poster
                       Content:(NSString*)content
                    Background:(NSString*)background
{
    self = [super init];
    
    if(self){
        self.roomID = roomID;
        self.poster = poster;
        self.content = content;
        self.background = background;
}
    
    return self;
}

- (PFObject*)toPFObject
{
    PFObject *PFObj = [PFObject objectWithClassName:@"Sticky"];
    
    if(PFObj){
        PFObj[@"roomID"] = self.roomID;
        PFObj[@"poster"] = self.poster;
        PFObj[@"content"] = self.content;
        PFObj[@"background"] = self.background;
    }
    
    return PFObj;
}



@end
