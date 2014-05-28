//
//  ChooseRoomViewController.m
//  Roommates
//
//  Created by Zhang Boxuan on 14-5-26.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "ChooseRoomViewController.h"
#import <Parse/Parse.h>

@interface ChooseRoomViewController ()

@property (strong, nonatomic) UIView *v_roomInfo;
@property (strong, nonatomic) UIView *v_roomInfoInput;

@property (strong, nonatomic) UITextField *tf_name;
@property (strong, nonatomic) UITextField *tf_school;
@property (strong, nonatomic) UITextField *tf_building;
@property (strong, nonatomic) UITextField *tf_room;

@property (strong, nonatomic) NSString *schoolName;

@end

@implementation ChooseRoomViewController

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    //init roomInfo view
//    self.v_roomInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//    self.v_roomInfo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signUp2"]];
//    [self.view addSubview:self.v_roomInfo];
//    
//    self.v_roomInfoInput = [[UIView alloc] initWithFrame:CGRectMake(36.0, 235.0, 248.0, 254.0)];
//    self.v_roomInfoInput.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:69.0/255.0 blue:90.0/255.0 alpha:1.0];
//    [self.v_roomInfo addSubview:self.v_roomInfoInput];
//    
//    [self setRoomInfoInputView];
//    
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 530, 160, 22)];
//    cancelBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:151.0/255.0 blue:29.0/255.0 alpha:1.0];
//    [cancelBtn setTitle:@"取    消" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
//    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelBtn];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //init roomInfo view
    self.v_roomInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.v_roomInfo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signUp2"]];
    [self.view addSubview:self.v_roomInfo];
    
    self.v_roomInfoInput = [[UIView alloc] initWithFrame:CGRectMake(36.0, 235.0, 248.0, 254.0)];
    self.v_roomInfoInput.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:69.0/255.0 blue:90.0/255.0 alpha:1.0];
    [self.v_roomInfo addSubview:self.v_roomInfoInput];
    
    [self setRoomInfoInputView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 500, 160, 22)];
    cancelBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:151.0/255.0 blue:29.0/255.0 alpha:1.0];
    [cancelBtn setTitle:@"取    消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];

    PFUser *curUser = [PFUser currentUser];
    NSString *roomID = [curUser valueForKey:@"roomID"];
    if(roomID.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的宿舍信息为空, 请输入" delegate:self cancelButtonTitle:@"确  认" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setRoomInfoInputView
{
    UIButton *signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(44.0, 214.0, 160, 22)];
    signUpBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:151.0/255.0 blue:29.0/255.0 alpha:1.0];
    [signUpBtn setTitle:@"确  认" forState:UIControlStateNormal];
    signUpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [signUpBtn addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.v_roomInfoInput addSubview:signUpBtn];
    
    self.tf_name = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 26.0, 204.0, 28.0)];
    self.tf_name.borderStyle = UITextBorderStyleNone;
    self.tf_name.backgroundColor = [UIColor whiteColor];
    self.tf_name.placeholder = @"姓名";
    self.tf_name.returnKeyType = UIReturnKeyNext;
    self.tf_name.font = [UIFont systemFontOfSize:12.0];
    self.tf_name.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_name.leftView = view1;
    self.tf_name.leftViewMode = UITextFieldViewModeAlways;
    self.tf_name.leftView.userInteractionEnabled = NO;
    self.tf_name.delegate = self;
    [self.v_roomInfoInput addSubview:self.tf_name];
    
    //setup textfield to input school name
    self.tf_school = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 72.0, 204.0, 28.0)];
    self.tf_school.borderStyle = UITextBorderStyleNone;
    self.tf_school.backgroundColor = [UIColor whiteColor];
    self.tf_school.placeholder = @"学校";
    self.tf_school.returnKeyType = UIReturnKeyNext;
    self.tf_school.font = [UIFont systemFontOfSize:12.0];
    self.tf_school.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_school.leftView = view2;
    self.tf_school.leftViewMode = UITextFieldViewModeAlways;
    self.tf_school.leftView.userInteractionEnabled = NO;
    self.tf_school.delegate = self;
    [self.tf_school addTarget:self action:@selector(clickToSelectSchool) forControlEvents:UIControlEventTouchDown];
    [self.v_roomInfoInput addSubview:self.tf_school];
    
    self.tf_building = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 118.0, 204.0, 28.0)];
    self.tf_building.borderStyle = UITextBorderStyleNone;
    self.tf_building.backgroundColor = [UIColor whiteColor];
    self.tf_building.placeholder = @"宿舍楼";
    self.tf_building.returnKeyType = UIReturnKeyNext;
    self.tf_building.font = [UIFont systemFontOfSize:12.0];
    self.tf_building.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_building.leftView = view3;
    self.tf_building.leftViewMode = UITextFieldViewModeAlways;
    self.tf_building.leftView.userInteractionEnabled = NO;
    self.tf_building.delegate = self;
    [self.v_roomInfoInput addSubview:self.tf_building];
    
    self.tf_room = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 164.0, 204.0, 28.0)];
    self.tf_room.borderStyle = UITextBorderStyleNone;
    self.tf_room.backgroundColor = [UIColor whiteColor];
    self.tf_room.placeholder = @"房间号";
    self.tf_room.returnKeyType = UIReturnKeyDone;
    self.tf_room.font = [UIFont systemFontOfSize:12.0];
    self.tf_room.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_room.leftView = view4;
    self.tf_room.leftViewMode = UITextFieldViewModeAlways;
    self.tf_room.leftView.userInteractionEnabled = NO;
    self.tf_room.delegate = self;
    [self.v_roomInfoInput addSubview:self.tf_room];
}

- (void)clickCancelButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickConfirmButton
{
    NSLog(@"Comfirm");
    
    if(self.tf_name.text.length != 0 && self.tf_school.text.length != 0 && self.tf_building.text.length != 0
       && self.tf_room.text.length != 0)
    {
        PFUser *curUser = [PFUser currentUser];
        
        curUser[@"name"] = self.tf_name.text;
        curUser[@"roomID"] = @"0nuTs0E1AT";
        
        [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error)
            {
                NSLog(@"success");
            }else
            {
                NSLog(@"failed");
            }
        }];
        
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

- (void)clickToSelectSchool
{
    [self performSegueWithIdentifier:@"toSelectSchool" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //hide keyboard
    [self.tf_name resignFirstResponder];
    [self.tf_school resignFirstResponder];
    [self.tf_building resignFirstResponder];
    [self.tf_room resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.v_roomInfoInput.frame = CGRectMake(self.v_roomInfoInput.frame.origin.x, 235.0, self.v_roomInfoInput.frame.size.width, self.v_roomInfoInput.frame.size.height);
    [UIView commitAnimations];
}


#define MOVE_HEIGHT 40
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect originFrame1 = self.v_roomInfoInput.frame;
    float offset = originFrame1.origin.y + MOVE_HEIGHT +originFrame1.size.height - (self.view.frame.size.height - 216.0);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
    {
        CGRect rect1 = CGRectMake(originFrame1.origin.x, originFrame1.origin.y - offset, self.v_roomInfoInput.frame.size.width, self.v_roomInfoInput.frame.size.height);
        self.v_roomInfoInput.frame = rect1;
    }
    
    [UIView commitAnimations];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.tf_name)
    {
        [self.tf_school becomeFirstResponder];
    }else if(textField == self.tf_school)
    {
        [self.tf_building becomeFirstResponder];
    }else if(textField == self.tf_building)
    {
        [self.tf_room becomeFirstResponder];
    }else if(textField == self.tf_room)
    {
        [self.tf_room resignFirstResponder];
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        self.v_roomInfoInput.frame = CGRectMake(self.v_roomInfoInput.frame.origin.x, 235.0, self.v_roomInfoInput.frame.size.width, self.v_roomInfoInput.frame.size.height);
        [UIView commitAnimations];
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toSelectSchool"])
    {
        id chooseSchoolViewController = segue.destinationViewController;
        [chooseSchoolViewController setValue:self.tf_school.text forKey:@"selectedSchoolName"];
        [chooseSchoolViewController setValue:self forKey:@"delegate"];
    }
}

- (void)returnSchoolName:(NSString *)schoolName
{
    self.tf_school.text = schoolName;
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
