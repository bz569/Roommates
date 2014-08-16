//
//  MessageUserListViewController.h
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/14.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"

@interface MessageUserListViewController : UIViewController <XMPPStreamDelegate, UITableViewDelegate, UITableViewDataSource>

@end
