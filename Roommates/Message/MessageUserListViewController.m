//
//  MessageUserListViewController.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/14.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "MessageUserListViewController.h"

@interface MessageUserListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tv_userList;

@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) NSMutableArray *onlineUsers;

@property (strong, nonatomic) NSString *toChatUsername;

@end

@implementation MessageUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tv_userList.delegate = self;
    self.tv_userList.dataSource = self;
    
    self.onlineUsers = [NSMutableArray array];
    
    [self connect];
    
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
        NSString *username = @"test";
        XMPPJID *jid = [XMPPJID jidWithString:@"test@zapxmpp"];
        [self.xmppStream setMyJID:jid];
        [self.xmppStream setHostName:@"192.168.1.2"];
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
    NSString *password = @"test";
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
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"not Authenticate: %@", error);
}

//收到好友状态
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
        }
    }
}

//收到好友上线消息时
- (void)newBuddyOnline:(NSString*)buddyName
{
    NSLog(@"buddyGoOnline");
    if(![self.onlineUsers containsObject:buddyName]){
        [self.onlineUsers addObject:buddyName];
        [self.tv_userList reloadData];
    }
}

//收到好友下线消息时
-  (void)buddyWentOffline:(NSString*)buddyName
{
    NSLog(@"buddyWentOffline");
    [self.onlineUsers removeObject:buddyName];
    [self.tv_userList reloadData];
}


//设置好友列表内容
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.onlineUsers count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cellView = [self.tv_userList dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cellView == nil)
    {
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cellView.textLabel.text = (NSString*)[self.onlineUsers objectAtIndex:indexPath.row];
    
    return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发启一个聊天
    self.toChatUsername = (NSString*)[self.onlineUsers objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segue_toChatView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segue_toChatView"]){
        
        id messageChatViewController = segue.destinationViewController;
        [messageChatViewController setValue:self.toChatUsername forKey:@"chatWithUser"];
        [messageChatViewController setValue:self.xmppStream forKey:@"xmppStream"];
    }
}

@end




















