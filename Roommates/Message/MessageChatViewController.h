//
//  MessageChatViewController.h
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/16.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "ViewController.h"
#import "XMPP.h"

@interface MessageChatViewController : UIViewController <XMPPStreamDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end
