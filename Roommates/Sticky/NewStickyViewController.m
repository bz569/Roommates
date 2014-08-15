//
//  NewStickyViewController.m
//  Roommates
//
//  Created by ZhangBoxuan on 14/8/13.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "NewStickyViewController.h"
#import "Sticky.h"
#import <Parse/Parse.h>

@interface NewStickyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iv_stickyBackground;
@property (weak, nonatomic) IBOutlet UITextView *tv_input;

@property (strong, nonatomic) NSString *backgroundName;

@property (weak, nonatomic) id delegate;

@end

@implementation NewStickyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1.0];
    
    self.tv_input.font = [UIFont systemFontOfSize:18.0];
    [self.tv_input setContentInset:UIEdgeInsetsMake(20.0, 0, 0, 0)];
    
    self.backgroundName = @"sticky1";
    // Do any additional setup after loading the view.
}
- (IBAction)pressPublishButton:(id)sender
{
    PFUser *curUser = [PFUser currentUser];
    
    Sticky *newSticky = [[Sticky alloc] initWithRoomID:curUser[@"roomID"]
                                                Poster:curUser[@"name"]
                                               Content:self.tv_input.text
                                            Background:self.backgroundName];
    PFObject *stickyToSave = [newSticky toPFObject];
    [stickyToSave save];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate didReturnStickyView];
}

- (IBAction)changeBackground1:(id)sender
{
    self.iv_stickyBackground.image = [UIImage imageNamed:@"sticky1"];
    self.backgroundName = @"sticky1";
}

- (IBAction)changeBackground2:(id)sender
{
    self.iv_stickyBackground.image = [UIImage imageNamed:@"sticky2"];
    self.backgroundName = @"sticky2";
}

- (IBAction)changeBackground3:(id)sender
{
    self.iv_stickyBackground.image = [UIImage imageNamed:@"sticky3"];
    self.backgroundName = @"sticky3";
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.tv_input isExclusiveTouch]) {
        [self.tv_input resignFirstResponder];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
