//
//  MessageChatViewController.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/16.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "MessageChatViewController.h"

@interface MessageChatViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tv_chatView;
@property (weak, nonatomic) IBOutlet UITextField *tf_input;

@property (strong, nonatomic) NSString *chatWithUser;
@property (strong, nonatomic) XMPPStream *xmppStream;

@property (strong, nonatomic) NSMutableArray *messages;


@end

@implementation MessageChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setXmppStreamDelegate];
    
    self.messages = [NSMutableArray array];
    self.tv_chatView.delegate = self;
    self.tv_chatView.dataSource = self;
    
}

- (void)setXmppStreamDelegate
{
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

//收到消息
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
    
        [self newMessageReceived:dict];
        
    }
}

- (void)newMessageReceived:(NSDictionary *)messageContent
{
    [self.messages addObject:messageContent];
    
    [self.tv_chatView reloadData];
}

//发送消息
- (IBAction)sentMessage:(UIButton *)sender
{
    NSString *message = self.tf_input.text;
    
    if(message.length > 0){
        
        //生成XML文件
        //生成<body>
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息
        NSXMLElement *msgToSend = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [msgToSend addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [msgToSend addAttributeWithName:@"to" stringValue:self.chatWithUser];
        //由谁发送,需要修改
        [msgToSend addAttributeWithName:@"from" stringValue:@"test@zapxmpp"];
        //组合
        [msgToSend addChild:body];
        
        //发送消息
        [self.xmppStream sendElement:msgToSend];
        
        //设置本地显示
        self.tf_input.text = @"";
        [self.tf_input resignFirstResponder];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:message forKey:@"msg"];
        [dict setObject:@"我" forKey:@"sender"];

        [self.messages addObject:dict];
        
        [self.tv_chatView reloadData];
    }
}

//设置tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"msgCell";
    UITableViewCell *cellView = [self.tv_chatView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cellView == nil)
    {
//        cellView = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSMutableDictionary *dict = [self.messages objectAtIndex:indexPath.row];
    
    cellView.textLabel.text = [dict objectForKey:@"msg"];
    cellView.detailTextLabel.text = [dict objectForKey:@"sender"];
//    cellView.accessoryType = UITableViewCellAccessoryNone;
    
    return cellView;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.tf_input isExclusiveTouch]) {
        [self.tf_input resignFirstResponder];
    }
}



@end
