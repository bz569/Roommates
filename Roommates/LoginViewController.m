//
//  LoginViewController.m
//  Roommates
//
//  Created by Zhang Boxuan on 14-5-24.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_userName;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (strong, nonatomic) IBOutlet UIView *v_loginInput;

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    
////    //获取键盘高度
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
    
    [self setTextFields];
}

//- (void)keyboardWillChangeFrame:(NSNotification*)notification
//{
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
////    self.view.frame = CGRectMake(0, 0 - keyboardRect.size.height, 320, 568);
//    //修改输入区域的位置
//    self.v_loginInput.frame = CGRectMake(36, 132, 248, 160);
////    CGRect newframe = self.v_loginInput.frame;
//    [UIView commitAnimations];
//}


- (void)viewWillLayoutSubviews
{
//    [self setTextFields];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self setTextFields];
}

- (void)setTextFields
{
    self.tf_password.delegate = self;
    self.tf_userName.delegate = self;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_userName.leftView = view1;
    self.tf_userName.leftViewMode = UITextFieldViewModeAlways;
    self.tf_userName.leftView.userInteractionEnabled = NO;

    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_password.leftView = view2;
    self.tf_password.leftViewMode = UITextFieldViewModeAlways;
    self.tf_password.leftView.userInteractionEnabled = NO;
}

- (IBAction)pressLoginButton:(id)sender
{
    NSString *userName = self.tf_userName.text;
    NSString *password = self.tf_password.text;
    
    [PFUser logInWithUsernameInBackground: userName
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if(user)
                                        {
                                            PFUser *curUser = [PFUser currentUser];
                                            NSString *roomID = [curUser valueForKey:@"roomID"];
                                            if(roomID.length == 0)
                                            {
                                                [self performSegueWithIdentifier:@"segueFromLoginViewToChooseRoomView" sender:self];
                                            }else
                                            {
                                                NSLog(@"login success");
                                                [self performSegueWithIdentifier:@"segueFromLoginToMain" sender:self];
                                            }
                                        
                                        }else
                                        {
                                            NSLog(@"%@", [error userInfo][@"error"]);
                                            if([error code] == kPFErrorObjectNotFound){
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                                message:@"用户名或密码错误\n请重新输入"
                                                                                               delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                [alert show];
                                            }
                                            
                                        }
                                    }];
    
}
   
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.tf_userName isFirstResponder])
    {
        [self.tf_password becomeFirstResponder];
    }else if([self.tf_password isFirstResponder])
    {
        [self.tf_password resignFirstResponder];
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        self.v_loginInput.frame = CGRectMake(36.0, 281.0, 248.0, 160.0);
        [UIView commitAnimations];
    }
    
    return YES;
}


#define MOVE_HEIGHT 40
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect originFrame = self.v_loginInput.frame;
    float offset = originFrame.origin.y + MOVE_HEIGHT +originFrame.size.height - (self.view.frame.size.height - 216.0);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
    {
//        CGRect rect = CGRectMake(originFrame.origin.x, originFrame.origin.y - offset, self.v_loginInput.frame.size.width, self.v_loginInput.frame.size.height);
        CGRect rect = CGRectMake(36, 132, 248, 160);
        self.v_loginInput.frame = rect;
    }
    

    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.v_loginInput.frame = CGRectMake(36.0, 281.0, 248.0, 160.0);
    [UIView commitAnimations];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tf_password resignFirstResponder];
    [self.tf_userName resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.v_loginInput.frame = CGRectMake(36.0, 281.0, 248.0, 160.0);
    [UIView commitAnimations];
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
