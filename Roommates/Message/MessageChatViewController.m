//
//  MessageChatViewController.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/16.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "MessageChatViewController.h"
#import "MessageCell.h"

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
    self.tv_chatView.tableFooterView = [[UIView alloc] init];
    
    //键盘消失
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.tv_chatView addGestureRecognizer:tapGestureRecognizer];
    
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.tf_input resignFirstResponder];
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages count] - 1 inSection:0];
    [self.tv_chatView scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:NO];
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
        [dict setObject:@"me" forKey:@"sender"];

        [self.messages addObject:dict];
        
        [self.tv_chatView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages count] - 1 inSection:0];
        [self.tv_chatView scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:NO];
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

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.messages objectAtIndex:indexPath.row];
    NSString *msg = [dict objectForKey:@"msg"];
    
    CGSize textSize = CGSizeMake(250.0, 10000.0);
    UIFont *font = [UIFont systemFontOfSize:13.0];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize size = [msg boundingRectWithSize:textSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributeDict
                                    context:nil].size;
    
    size.height += 20;
    
    CGFloat height = size.height < 50 ? 50 : size.height;
    
    return height;
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
    
    cellView.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *dict = [self.messages objectAtIndex:indexPath.row];
    
    //文字内容大小
    NSString *msg = [dict objectForKey:@"msg"];
    CGSize textSize = CGSizeMake(220.0, 10000.0);
    UIFont *font = [UIFont systemFontOfSize:13.0];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize size = [msg boundingRectWithSize:textSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributeDict
                                    context:nil].size;
    
    CGFloat height = size.height < 30 ? 30 : size.height;
    
    
    if([[dict objectForKey:@"sender"] isEqualToString:@"me"]) {      //发送的消息
        
        UILabel *l_msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, height)];
        l_msg.text = msg;
        l_msg.textAlignment = NSTextAlignmentRight;
        l_msg.font = [UIFont systemFontOfSize:13.0];
        l_msg.lineBreakMode = NSLineBreakByCharWrapping;
        l_msg.numberOfLines = 0;
        [cellView addSubview:l_msg];
        
        //头像
        UIImageView *iv_userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(260, (height - 20) / 2, 40, 40)];
        iv_userIcon.image = [UIImage imageNamed:@"default_userIcon"];
        iv_userIcon.layer.masksToBounds = YES;
        iv_userIcon.layer.cornerRadius = 20;
        [cellView addSubview:iv_userIcon];
    }else {     //收到的消息
        
        UILabel *l_msg = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 250, height)];
        l_msg.text = msg;
        l_msg.textAlignment = NSTextAlignmentLeft;
        l_msg.font = [UIFont systemFontOfSize:13.0];
        l_msg.lineBreakMode = NSLineBreakByCharWrapping;
        l_msg.numberOfLines = 0;
        [cellView addSubview:l_msg];
        
        //头像
        UIImageView *iv_userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (height - 20) / 2, 40, 40)];
        iv_userIcon.image = [UIImage imageNamed:@"default_userIcon"];
        iv_userIcon.layer.masksToBounds = YES;
        iv_userIcon.layer.cornerRadius = 20;
        [cellView addSubview:iv_userIcon];

    }
    
    
    
    return cellView;

   }


@end




















