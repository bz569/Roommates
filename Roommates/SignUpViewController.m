//
//  SignUpViewController.m
//  Roommates
//
//  Created by Zhang Boxuan on 14-5-24.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "MD5.h"

@interface SignUpViewController ()

@property (strong, nonatomic) UIView *v_loginInfo;
@property (strong, nonatomic) UIView *v_loginInfoInput;

@property (strong, nonatomic) UITextField *tf_username;
@property (strong, nonatomic) UITextField *tf_password;
@property (strong, nonatomic) UITextField *tf_passwordConfirm;
@property (strong, nonatomic) UITextField *tf_email;

@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) XMPPStream *xmppStream;

@end

@implementation SignUpViewController

- (void)viewWillLayoutSubviews
{
//    //init loginInfo view
//    self.v_loginInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//    self.v_loginInfo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signUp1"]];
//    [self.view addSubview:self.v_loginInfo];
//    
//    self.v_loginInfoInput = [[UIView alloc] initWithFrame:CGRectMake(36.0, 235.0, 248.0, 254.0)];
//    self.v_loginInfoInput.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:69.0/255.0 blue:90.0/255.0 alpha:1.0];
//    [self.v_loginInfo addSubview:_v_loginInfoInput];
//    
//    [self setLoginInfoInputView];
//    
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 500, 160, 22)];
//    cancelBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:151.0/255.0 blue:29.0/255.0 alpha:1.0];
//    [cancelBtn setTitle:@"取    消" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
//    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelBtn];
}

- (void) setViews
{
    //init loginInfo view
    self.v_loginInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.v_loginInfo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signUp1"]];
    [self.view addSubview:self.v_loginInfo];
    
    self.v_loginInfoInput = [[UIView alloc] initWithFrame:CGRectMake(36.0, 235.0, 248.0, 254.0)];
    self.v_loginInfoInput.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:69.0/255.0 blue:90.0/255.0 alpha:1.0];
    [self.v_loginInfo addSubview:_v_loginInfoInput];
    
    [self setLoginInfoInputView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 500, 160, 22)];
    cancelBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:151.0/255.0 blue:29.0/255.0 alpha:1.0];
    [cancelBtn setTitle:@"取    消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //init loginInfo view
    self.v_loginInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.v_loginInfo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signUp1"]];
    [self.view addSubview:self.v_loginInfo];
    
    self.v_loginInfoInput = [[UIView alloc] initWithFrame:CGRectMake(36.0, 235.0, 248.0, 254.0)];
    self.v_loginInfoInput.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:69.0/255.0 blue:90.0/255.0 alpha:1.0];
    [self.v_loginInfo addSubview:_v_loginInfoInput];
    
    [self setLoginInfoInputView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 500, 160, 22)];
    cancelBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:151.0/255.0 blue:29.0/255.0 alpha:1.0];
    [cancelBtn setTitle:@"取    消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLoginInfoInputView
{
    UIButton *signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(44.0, 214.0, 160, 22)];
    signUpBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:151.0/255.0 blue:29.0/255.0 alpha:1.0];
    [signUpBtn setTitle:@"注   册" forState:UIControlStateNormal];
    signUpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [signUpBtn addTarget:self action:@selector(clickSignUpButton) forControlEvents:UIControlEventTouchUpInside];
    [self.v_loginInfoInput addSubview:signUpBtn];
    
    self.tf_username = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 26.0, 204.0, 28.0)];
    self.tf_username.borderStyle = UITextBorderStyleNone;
    self.tf_username.backgroundColor = [UIColor whiteColor];
    self.tf_username.placeholder = @"用户名";
    self.tf_username.returnKeyType = UIReturnKeyNext;
    self.tf_username.font = [UIFont systemFontOfSize:12.0];
    self.tf_username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_username.leftView = view1;
    self.tf_username.leftViewMode = UITextFieldViewModeAlways;
    self.tf_username.leftView.userInteractionEnabled = NO;
    self.tf_username.delegate = self;
    [self.v_loginInfoInput addSubview:self.tf_username];
    
    self.tf_password = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 72.0, 204.0, 28.0)];
    self.tf_password.borderStyle = UITextBorderStyleNone;
    self.tf_password.backgroundColor = [UIColor whiteColor];
    self.tf_password.placeholder = @"密码";
    self.tf_password.returnKeyType = UIReturnKeyNext;
    self.tf_password.font = [UIFont systemFontOfSize:12.0];
    self.tf_password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.tf_password.secureTextEntry = YES;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_password.leftView = view2;
    self.tf_password.leftViewMode = UITextFieldViewModeAlways;
    self.tf_password.leftView.userInteractionEnabled = NO;
    self.tf_password.delegate = self;
    [self.v_loginInfoInput addSubview:self.tf_password];
    
    self.tf_passwordConfirm = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 118.0, 204.0, 28.0)];
    self.tf_passwordConfirm.borderStyle = UITextBorderStyleNone;
    self.tf_passwordConfirm.backgroundColor = [UIColor whiteColor];
    self.tf_passwordConfirm.placeholder = @"确认密码";
    self.tf_passwordConfirm.returnKeyType = UIReturnKeyNext;
    self.tf_passwordConfirm.font = [UIFont systemFontOfSize:12.0];
    self.tf_passwordConfirm.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.tf_passwordConfirm.secureTextEntry = YES;
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_passwordConfirm.leftView = view3;
    self.tf_passwordConfirm.leftViewMode = UITextFieldViewModeAlways;
    self.tf_passwordConfirm.leftView.userInteractionEnabled = NO;
    self.tf_passwordConfirm.delegate = self;
    [self.v_loginInfoInput addSubview:self.tf_passwordConfirm];
    
    self.tf_email = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 164.0, 204.0, 28.0)];
    self.tf_email.borderStyle = UITextBorderStyleNone;
    self.tf_email.backgroundColor = [UIColor whiteColor];
    self.tf_email.placeholder = @"邮箱";
    self.tf_email.keyboardType = UIKeyboardTypeEmailAddress;
    self.tf_email.returnKeyType = UIReturnKeyDone;
    self.tf_email.font = [UIFont systemFontOfSize:12.0];
    self.tf_email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_email.leftView = view4;
    self.tf_email.leftViewMode = UITextFieldViewModeAlways;
    self.tf_email.leftView.userInteractionEnabled = NO;
    self.tf_email.delegate = self;
    [self.v_loginInfoInput addSubview:self.tf_email];
}

- (void)clickSignUpButton
{
    NSLog(@"signUp");
    
    if(self.tf_username.text.length != 0 && self.tf_password.text.length != 0 && self.tf_passwordConfirm.text.length != 0
       && self.tf_email.text.length != 0 )
    {
        if([self.tf_password.text isEqualToString:self.tf_passwordConfirm.text])
        {
            PFUser *newUser = [PFUser user];
            newUser.username = self.tf_username.text;
            newUser.password = self.tf_password.text;
            newUser.email = self.tf_email.text;
            self.username = self.tf_username.text;
            
            
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                    if(!error)
                                                    {
                                                        NSLog(@"注册成功");
                                                        
                                                        //在XMPP服务器上注册用户
                                                        [self connectXMPPServerToRegister];
                                                        
//                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    }else
                                                    {
                                                        NSString *errorString = [error userInfo][@"error"];
                                                        NSLog(@"%@", errorString);
                                                        if(error.code == 202)
                                                        {
                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                                            message:@"用户名已存在，请重新输入"
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"确定"
                                                                                                  otherButtonTitles:nil];
                                                            [alert show];
                                                            
                                                            NSTimeInterval animationDuration = 0.30f;
                                                            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
                                                            [UIView setAnimationDuration:animationDuration];
                                                            
                                                            self.v_loginInfo.frame = CGRectMake(0.0, 0, 320, 568);
                                                            
                                                            [UIView commitAnimations];
                                                            
                                                        }
                                                    }
                                                }];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"两次密码不一致，请重新输入"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            
            self.v_loginInfo.frame = CGRectMake(0.0, 0, 320, 568);
            
            [UIView commitAnimations];
        }
        
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请输入完整信息"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)clickCancelButton
{
    [self.xmppStream disconnect];
    [self dismissViewControllerAnimated:YES completion:nil];
}
     
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //hide keyboard
    [self.tf_username resignFirstResponder];
    [self.tf_password resignFirstResponder];
    [self.tf_passwordConfirm resignFirstResponder];
    [self.tf_email resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.v_loginInfoInput.frame = CGRectMake(self.v_loginInfoInput.frame.origin.x, 235.0, self.v_loginInfoInput.frame.size.width, self.v_loginInfoInput.frame.size.height);
    [UIView commitAnimations];
}

#define MOVE_HEIGHT 40
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect originFrame1 = self.v_loginInfoInput.frame;
    float offset = originFrame1.origin.y + MOVE_HEIGHT +originFrame1.size.height - (self.view.frame.size.height - 216.0);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
    {
        CGRect rect1 = CGRectMake(originFrame1.origin.x, originFrame1.origin.y - offset, self.v_loginInfoInput.frame.size.width, self.v_loginInfoInput.frame.size.height);
        self.v_loginInfoInput.frame = rect1;
    }
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.tf_username)
    {
        [self.tf_password becomeFirstResponder];
    }else if(textField == self.tf_password)
    {
        [self.tf_passwordConfirm becomeFirstResponder];
    }else if(textField == self.tf_passwordConfirm)
    {
        [self.tf_email becomeFirstResponder];
    }else if(textField == self.tf_email)
    {
        [self.tf_email resignFirstResponder];
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        self.v_loginInfoInput.frame = CGRectMake(self.v_loginInfoInput.frame.origin.x, 235.0, self.v_loginInfoInput.frame.size.width, self.v_loginInfoInput.frame.size.height);
        [UIView commitAnimations];
    }
    
    return YES;
}

//register on XMPP server

- (void)connectXMPPServerToRegister
{
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }

    
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

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    //找到新注册的用户
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.username];
    NSArray *result = [query findObjects];
    PFUser *user = [result objectAtIndex:0];
    
    
    //暂且先用user的objectID作为聊天的密码
    NSString *username = user.username;
    NSString *password = user.objectId;
    
    NSString *jid = [[NSString alloc] initWithFormat:@"%@@%@", username, @"zapxmpp"];
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    
    NSError *error=nil;
    if (![self.xmppStream registerWithPassword:password error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建聊天帐号失败"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"XMPP注册成功");
    [self.xmppStream disconnect];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"xmpp注册失败：%@", error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
