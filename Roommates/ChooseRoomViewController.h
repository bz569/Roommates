//
//  ChooseRoomViewController.h
//  Roommates
//
//  Created by Zhang Boxuan on 14-5-26.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "ViewController.h"
#import "ChooseSchoolViewController.h"
#import "ChooseBuildingViewController.h"
#import "XMPP.h"

@interface ChooseRoomViewController : ViewController <UITextFieldDelegate, ReturnSchoolNameDelegate, ReturnBuildingDelegate, XMPPStreamDelegate>

@end
