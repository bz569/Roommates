//
//  MessageUserListViewController.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/14.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "MessageUserListViewController.h"
#import <Parse/Parse.h>
#import "Roommate.h"
#import "UserIcon.h"

@interface MessageUserListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tv_userList;

@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) XMPPRoster *xmppRoster;
@property (strong, nonatomic) NSMutableArray *onlineUsers;
@property (strong, nonatomic) NSMutableArray *userList;
@property (strong, nonatomic) NSMutableArray *roommateList;
@property (strong, nonatomic) NSMutableDictionary *unreadMessages;

@property (strong, nonatomic) Roommate *toChatWithRoommate;

@property (strong, nonatomic) PFUser *curUser;

@property (nonatomic) BOOL isFirstTimeRequestRoster;

@end

@implementation MessageUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:187.0/255.0 blue:142.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],  NSForegroundColorAttributeName, nil]];
    
    self.tv_userList.delegate = self;
    self.tv_userList.dataSource = self;
    
    self.tv_userList.tableFooterView = [[UIView alloc] init];
    self.tv_userList.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:1.0];
    self.tv_userList.separatorColor = [UIColor colorWithRed:43.0/255.0 green:48.0/255.0 blue:57.0/255.0 alpha:1.0];
    
    self.onlineUsers = [NSMutableArray array];
    self.userList = [NSMutableArray array];
    self.unreadMessages = [NSMutableDictionary dictionary];
    
    self.curUser = [PFUser currentUser];
    
    self.isFirstTimeRequestRoster = YES;
    
    [self fetchRoommateListFromParse];
    [self connect];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.unreadMessages = [NSMutableDictionary dictionary];
    [self.tv_userList reloadData];
}

- (void)setXmppStreamDelegate
{
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}

- (void)connect
{
    [self setXmppStreamDelegate];
    
    if (![self.xmppStream isConnected]) {
        
        PFUser *user = [PFUser currentUser];
        NSString *username = user.username;
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@zapxmpp", username]];
        [self.xmppStream setMyJID:jid];
//        [self.xmppStream setHostName:@"192.168.1.2"];
        [self.xmppStream setHostName:@"69.127.17.176"];
        NSError *error = nil;
        if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
            NSLog(@"Connect Error: %@", [[error userInfo] description]);
        }else {
            NSLog(@"connect successfully");
        }
    }
}

//验证密码
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    PFUser *user = [PFUser currentUser];
    NSString *password = user.objectId;
    NSError *error = nil;
    if (![self.xmppStream authenticateWithPassword:password error:&error]) {
        NSLog(@"Authenticate Error: %@", [[error userInfo] description]);
    }else {
        NSLog(@"Auth successfully?");
    }
}

//上线
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"goOnline");
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
    
    [self queryRoster];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"not Authenticate: %@", error);
}

//下线
- (void)goOfflineAndDisconnect
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
    [self.xmppStream disconnect];
}

//收到好友状态或好友请求
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
//    NSLog(@"didReceivePresence = %@", presence);
    
    //取得好友状态
    NSString *presenceType = [presence type];
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqual:userId]) {
        //在线状态
        if([presenceType isEqualToString:@"available"]){
            [self newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"zapxmpp"]];
        }else if([presenceType isEqualToString:@"unavailable"]){
            [self buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"zapxmpp"]];
        }else if([presenceType isEqualToString:@"subscribe"]){
            //收到好友请求
            
            if(self.xmppRoster == nil)
            {
                XMPPRosterCoreDataStorage *xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
                self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
                [self.xmppRoster activate:self.xmppStream];
            }
            
            XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",[presence from]]];
            [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
            //刷新好友列表
//            [self queryRoster];
        }
    }
}

//收到好友上线消息时
- (void)newBuddyOnline:(NSString*)buddyName
{
    NSLog(@"buddyGoOnline");
    if(![self.onlineUsers containsObject:buddyName]){
        [self.onlineUsers addObject:buddyName];
        
//        //在userList设置用户状态为在线
//        for(NSMutableDictionary *userInfo in self.userList) {
//            NSString *jid = [userInfo valueForKey:@"jid"];
//            if([jid isEqualToString:buddyName]){
//                [userInfo setObject:@"online" forKey:@"status"];
//            }
//        }

        for(Roommate *roommate in self.roommateList){
            if([roommate.jid isEqualToString:buddyName]){
                roommate.status = @"online";
            }
        }
        
        [self.tv_userList reloadData];
    }
}

//收到好友下线消息时
-  (void)buddyWentOffline:(NSString*)buddyName
{
    NSLog(@"buddyWentOffline");
    [self.onlineUsers removeObject:buddyName];
    
//    //在userList设置用户状态为离线
//    for(NSMutableDictionary *userInfo in self.userList) {
//        NSString *jid = [userInfo valueForKey:@"jid"];
//        if([jid isEqualToString:buddyName]){
//            [userInfo setObject:@"offline" forKey:@"status"];
//        }
//    }
    
    for(Roommate *roommate in self.roommateList){
        if([roommate.jid isEqualToString:buddyName]){
            roommate.status = @"offline";
        }
    }
    
    [self.tv_userList reloadData];
}

//获取好友列表
- (void)queryRoster
{
    self.userList = [NSMutableArray array];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:[self generateID]];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
//    NSLog(@"iq to send = %@", iq);
    [self.xmppStream sendElement:iq];
}

- (NSString*)generateID
{
    int value = arc4random() % 100000;
    
    return [NSString stringWithFormat:@"%d", value];
    
}

//收到iq的响应
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    if ([@"result" isEqualToString:iq.type]) {
//        NSLog(@"%@", iq);
        NSXMLElement *query = iq.childElement;
        if([@"query" isEqualToString:query.name]){
            NSArray *items = [query children];
            for (NSXMLElement *item in items){
                NSString *jid = [[item attributeForName:@"jid"] stringValue];
                NSString *name = [[item attributeForName:@"name"] stringValue];
                NSString *subscription = [[item attributeForName:@"subscription"] stringValue];
                
                if([subscription isEqualToString:@"both"])
                {
                    NSString *status;
                    if([self.onlineUsers containsObject:jid]){
                        status = @"online";
                    }else {
                        status = @"offline";
                    }
                
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:jid, @"jid", name, @"name", status, @"status",nil];
                    [self.userList addObject:dict];
                }
            }
            
            if (self.isFirstTimeRequestRoster) {
                [self willAddRoster];
                self.isFirstTimeRequestRoster = NO;
            }
            
//            [self willAddRoster];
            [self.tv_userList reloadData];
        }

    }
    
        return YES;
}

//收到好友消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSArray *tmp = [from componentsSeparatedByString:@"@"];
    NSString *msgSender = (NSString*) [tmp objectAtIndex:0];
    
    if(msg != nil){
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:msg forKey:@"msg"];
        [dict setObject:msgSender forKey:@"sender"];
        
        NSMutableArray *messagesArray = [self.unreadMessages valueForKey:msgSender];
        if(messagesArray == nil) {
            messagesArray = [NSMutableArray array];
            [messagesArray addObject:dict];
            [self.unreadMessages setObject:messagesArray forKey:msgSender];
        }else {
            [messagesArray addObject:dict];
            [self.unreadMessages setObject:messagesArray forKey:msgSender];
        }
        
        [self.tv_userList reloadData];
    }
}

//添加同宿舍好友
- (void)willAddRoster
{
    if(self.xmppRoster == nil)
    {
        XMPPRosterCoreDataStorage *xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
        
        [self.xmppRoster activate:self.xmppStream];
    }
    
    //从Parse中获取同宿舍用户名单
//    PFUser *currentUser = [PFUser currentUser];
//    [currentUser refresh];
//    NSString *roomID = self.curUser[@"roomID"];
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"roomID" equalTo:roomID];
//    NSArray *roommatesArray = [query findObjects];
    
    //从parse获取roommate名单，不是自己，且不在Roster中得，发送添加好友请求
    for (Roommate *roommate in self.roommateList) {
        NSLog(@"roomate=%@, self=%@", roommate.userName, self.curUser.username);
        
        if(![self isRoommateExistedInRosterWithName:roommate.name]){
            [self addRosterWithUserName:roommate.userName NickName:roommate.name];
        }
        
    }
}

//判断roommate是否已在Roster中
- (BOOL)isRoommateExistedInRosterWithName:(NSString*)name
{
    for(NSMutableDictionary *dict in self.userList){
        if([[dict objectForKey:@"name"] isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}

- (void)addRosterWithUserName:(NSString*)username NickName:(NSString*)nickname
{
    NSLog(@"---add -%@- to Roster", nickname);
    NSString *jidString = [NSString stringWithFormat:@"%@@%@", username, @"zapxmpp"];
    XMPPJID *jid = [XMPPJID jidWithString:jidString];
    [self.xmppRoster addUser:jid withNickname:nickname];
    [self.xmppRoster subscribePresenceToUser:jid];
    
}

//设置好友列表内容
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.onlineUsers count];
//    return [self.userList count];
    return [self.roommateList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cellView = [self.tv_userList dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if(cellView == nil)
//    {
//        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    
//    for(UIView * view in cellView.subviews){
//        if([view isKindOfClass:[UILabel class]])
//        {
//            [view removeFromSuperview];
//        }
//    }

    UITableViewCell *cellView = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    cellView.selectedBackgroundView = [[UIView alloc] initWithFrame:cellView.frame];
    cellView.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:45.0/255.0 blue:53.0/255.0 alpha:1.0];
    cellView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:1.0];
    
//    cellView.textLabel.text = (NSString*)[self.onlineUsers objectAtIndex:indexPath.row];
//    NSMutableDictionary *userInfo = [self.userList objectAtIndex:indexPath.row];
    Roommate *roommate = [self.roommateList objectAtIndex:indexPath.row];
//    cellView.textLabel.text = [userInfo valueForKey:@"name"];

    //设置用户状态显示
    UILabel *l_name = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 250, 50)];
    l_name.text = roommate.name;
    
    NSString *status = roommate.status;
    if([status isEqualToString:@"online"]){
        l_name.textColor = [UIColor whiteColor];
    }else if([status isEqualToString:@"offline"]) {
        l_name.textColor = [UIColor grayColor];
    }
    [cellView addSubview:l_name];
    
    UIImageView *iv_userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
//    iv_userIcon.image = [UIImage imageNamed:@"default_userIcon"];
    iv_userIcon.image = roommate.icon;
    iv_userIcon.layer.masksToBounds = YES;
    iv_userIcon.layer.cornerRadius = 15;
    [cellView addSubview:iv_userIcon];
    
    //显示未读消息个数
    UILabel *l_unreadMsgCount = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 10, 50)];
    l_unreadMsgCount.textColor = [UIColor colorWithRed:0 green:187.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    NSInteger count = 0;
    NSString *jid = roommate.jid;
    NSArray *tmp = [jid componentsSeparatedByString:@"@"];
    NSString *msgSender = (NSString*) [tmp objectAtIndex:0];
    NSMutableArray *messagesArray = [self.unreadMessages valueForKey:msgSender];
    if(messagesArray == nil) {
        count = 0;
    }else {
        count = [messagesArray count];
    }
    
    if(count != 0){
        l_unreadMsgCount.text = [NSString stringWithFormat:@"%ld", (long)count];
    }else {
        l_unreadMsgCount.text = @"";
    }
    
    [cellView addSubview:l_unreadMsgCount];
    
    return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消背景颜色
    [self.tv_userList deselectRowAtIndexPath:indexPath animated:YES];
    
    //发启一个聊天
//    Roommate *toChatWithRoommate = [self.roommateList objectAtIndex:indexPath.row];
//    self.toChatUsername = toChatWithRoommate.jid;
    self.toChatWithRoommate = [self.roommateList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segue_toChatView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segue_toChatView"]){
        
        id messageChatViewController = segue.destinationViewController;
//        [messageChatViewController setValue:self.toChatUsername forKey:@"chatWithUser"];
        [messageChatViewController setValue:self.toChatWithRoommate.jid forKey:@"chatWithUser"];
        [messageChatViewController setValue:self.toChatWithRoommate.icon forKey:@"roommateIcon"];
        [messageChatViewController setValue:self.xmppStream forKey:@"xmppStream"];
        
//        NSString *jidString = self.toChatUsername;
//        NSArray *tmp = [jidString componentsSeparatedByString:@"@"];
//        NSString *msgSender = (NSString*) [tmp objectAtIndex:0];
        NSString *msgSender = self.toChatWithRoommate.userName;
        NSMutableArray *messagesArray = [self.unreadMessages valueForKey:msgSender];
        [messageChatViewController setValue:messagesArray forKey:@"messages"];
    }
}

- (IBAction)onPressCloseButton:(id)sender
{
    [self goOfflineAndDisconnect];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//从parse获取RoommateList
- (void)fetchRoommateListFromParse
{
    self.roommateList = [NSMutableArray array];
    
    if(!self.curUser){
        self.curUser = [PFUser currentUser];
    }
    
    NSString *roomID = self.curUser[@"roomID"];
    PFQuery *query = [PFUser query];
    [query whereKey:@"roomID" equalTo:roomID];
    NSArray *pfRoommatesArray = [query findObjects];
    
    for (PFUser *pfRoommate in pfRoommatesArray) {
//        NSLog(@"roomate=%@, self=%@", roommate[@"username"], self.curUser.username);
        
        if(![pfRoommate.username isEqualToString: self.curUser.username]){
            Roommate *roommate = [[Roommate alloc] init];
            roommate.userID = pfRoommate.objectId;
            roommate.jid = [[NSString stringWithFormat:@"%@@zapxmpp", pfRoommate.username] lowercaseString];
            roommate.userName = pfRoommate.username;
            roommate.name = pfRoommate[@"name"];
            roommate.status = @"offline";
            
            UIImage *icon = [UserIcon getIconWithUserID:roommate.userID];
            if(icon) {
                roommate.icon = icon;
            }else {
                roommate.icon = [UIImage imageNamed:@"default_userIcon"];
            }
            
            [self.roommateList addObject:roommate];
        }
    }

    
}

@end




















