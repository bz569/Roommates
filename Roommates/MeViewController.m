//
//  MeViewController.m
//  Roommates
//
//  Created by Zhang Boxuan on 14-6-20.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "MeViewController.h"
#import <Parse/Parse.h>
#import "UserIcon.h"

@interface MeViewController ()

@property (weak, nonatomic) IBOutlet UITabBarItem *barItem;
@property (weak, nonatomic) IBOutlet UITableView *tv_aboutMe;
@property (strong, nonatomic) UIActionSheet *as_selectIcon;
@property (strong, nonatomic) UIActionSheet *as_Logout;

@property (strong, nonatomic) PFUser *curUser;
@property (strong, nonatomic) NSString *room;
@property (strong, nonatomic) NSString *building;
@property (strong, nonatomic) NSString *school;

@end

@implementation MeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getUserInfo];
    
    self.tv_aboutMe.delegate = self;
    self.tv_aboutMe.dataSource = self;
    self.tv_aboutMe.tableFooterView = [[UIView alloc] init];
    self.tv_aboutMe.scrollEnabled = NO;
    
}

- (void)getUserInfo
{
    self.curUser = [PFUser currentUser];
    
    //查询寝室
    PFQuery *queryToRoom = [PFQuery queryWithClassName:@"Rooms"];
    PFObject *roomObj = [queryToRoom getObjectWithId:self.curUser[@"roomID"]];
    self.room = roomObj[@"Room"];
    
    //查询宿舍楼
    PFQuery *queryToBuilding = [PFQuery queryWithClassName:@"Buildings"];
    PFObject *buildingObj = [queryToBuilding getObjectWithId:roomObj[@"buildingID"]];
    self.building = buildingObj[@"buildingName"];
    
    //查询学校
    PFQuery *queryToSchool = [PFQuery queryWithClassName:@"Schools"];
    PFObject *schoolObj = [queryToSchool getObjectWithId:roomObj[@"schoolID"]];
    self.school = schoolObj[@"schoolName"];
}

//设置tableView显示页面
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
            
        case 1:
            return 5;
            break;
            
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0){     //头像
            return 64;
        }else {
            return 40;
        }
    }else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            //头像
            cell.frame = CGRectMake(0, 0, 320, 64);
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 34, 64)];
            label.text = @"头像";
            label.font = [UIFont boldSystemFontOfSize:17];
            [cell addSubview:label];
            
            UIImageView *iv_icon = [[UIImageView alloc] initWithFrame:CGRectMake(236, 4, 56, 56)];
            iv_icon.image = [UserIcon getIconWithUserID:self.curUser.objectId];
            iv_icon.layer.masksToBounds = YES;
            iv_icon.layer.cornerRadius = 10;
            [cell addSubview:iv_icon];
        }else if (indexPath.row ==1){
            //用户名
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 64, 50)];
            label.text = @"用户名";
            label.font = [UIFont boldSystemFontOfSize:17];
            label.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label];
            
            UILabel *l_username = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 132, 50)];
            l_username.text = self.curUser.username;
            l_username.font = [UIFont systemFontOfSize:14];
            l_username.textColor = [UIColor grayColor];
            l_username.textAlignment = NSTextAlignmentRight;
            [cell addSubview:l_username];
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            //名字
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 64, 50)];
            label.text = @"名字";
            label.font = [UIFont boldSystemFontOfSize:17];
            label.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label];
            
            UILabel *l_name = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 132, 50)];
            l_name.text = self.curUser[@"name"];
            l_name.font = [UIFont systemFontOfSize:14];
            l_name.textColor = [UIColor grayColor];
            l_name.textAlignment = NSTextAlignmentRight;
            [cell addSubview:l_name];

        }else if(indexPath.row == 1){
            //学校
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 64, 50)];
            label.text = @"学校";
            label.font = [UIFont boldSystemFontOfSize:17];
            label.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label];
            
            UILabel *l_school = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 132, 50)];
            l_school.text = self.school;
            l_school.font = [UIFont systemFontOfSize:14];
            l_school.textColor = [UIColor grayColor];
            l_school.textAlignment = NSTextAlignmentRight;
            [cell addSubview:l_school];
        }else if(indexPath.row == 2){
            //宿舍楼
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 64, 50)];
            label.text = @"宿舍楼";
            label.font = [UIFont boldSystemFontOfSize:17];
            label.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label];
            
            UILabel *l_building = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 132, 50)];
            l_building.text = self.building;
            l_building.font = [UIFont systemFontOfSize:14];
            l_building.textColor = [UIColor grayColor];
            l_building.textAlignment = NSTextAlignmentRight;
            [cell addSubview:l_building];
        }else if(indexPath.row == 3){
            //宿舍
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 64, 50)];
            label.text = @"宿舍";
            label.font = [UIFont boldSystemFontOfSize:17];
            label.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label];
            
            UILabel *l_room = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 132, 50)];
            l_room.text = self.room;
            l_room.font = [UIFont systemFontOfSize:14];
            l_room.textColor = [UIColor grayColor];
            l_room.textAlignment = NSTextAlignmentRight;
            [cell addSubview:l_room];
        }else if(indexPath.row == 4){
            //更改宿舍
            UIButton *btn_changeRoom = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 290, 30)];
            btn_changeRoom.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:151.0/255.0 blue:29.0/255.0 alpha:1.0];
            [btn_changeRoom setTitle:@"更改宿舍" forState:UIControlStateNormal];
            [cell addSubview:btn_changeRoom];
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            //注销
            UIButton *btn_logout = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 290, 30)];
            btn_logout.backgroundColor = [UIColor redColor];
            [btn_logout addTarget:self action:@selector(onClickLogoutBtn) forControlEvents:UIControlEventTouchUpInside];
            [btn_logout setTitle:@"注销" forState:UIControlStateNormal];
            [cell addSubview:btn_logout];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tv_aboutMe deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 0 && indexPath.row == 0){
        [self onClickSetIconBtn];
    }
}

//注销
- (void)onClickLogoutBtn
{
    NSLog(@"Logout");
    
    self.as_Logout = [[UIActionSheet alloc] initWithTitle:@"确认注销？"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"注销", @"取消", nil];
    [self.as_Logout showInView:self.view];

}

- (void)logout
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"segue_meToLogin" sender:self];
    
}


//设置头像
- (void)onClickSetIconBtn
{
    
    self.as_selectIcon = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"从手机相册选择", @"拍照", nil];
    [self.as_selectIcon showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == self.as_selectIcon){
        switch (buttonIndex) {
            case 0: //从手机相册选取
                [self pickIconFromPhotoLibrary];
                break;
                
            case 1:
                [self takePhoto];
                break;
            default:
                NSLog(@"Action Sheet buttion index error");
                break;
        }
    }else if(actionSheet == self.as_Logout)
    {
        switch (buttonIndex) {
            case 0: //从手机相册选取
                [self logout];
                break;
                
            case 1:
                break;
            default:
                NSLog(@"Action Sheet buttion index error");
                break;
        }
    }
    
}

- (void)pickIconFromPhotoLibrary
{
    UIImagePickerController *imagePicker= [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)takePhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //相机可用
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        NSLog(@"Camera Error");
    }
}

//选择头像之后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的是图片时
    if([type isEqualToString:@"public.image"]){
        
        //把图片转换成NSData
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSData *iconData;
        if(UIImagePNGRepresentation(image) == nil){
            iconData = UIImageJPEGRepresentation(image, 1.0);
        }else{
            iconData = UIImagePNGRepresentation(image);
        }
        
        //将图片保存在本地Docums/Icons文件夹中
        NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *iconsPath = [documentsPath stringByAppendingString:@"/Icons"];
//        NSLog(@"iconsPath=%@", iconsPath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:iconsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        //设置图片名称
        PFUser *curUser = [PFUser currentUser];
        NSString *imageName = [NSString stringWithFormat:@"icon_%@.png", curUser.objectId];
        NSString *imagePath = [iconsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", imageName]];
//        NSLog(@"imagePath=%@", imagePath);
        
        //保存图片
        [fileManager createFileAtPath:imagePath contents:iconData attributes:nil];
    
        //将头像上传至Parse数据库
        PFFile *iconFile = [PFFile fileWithName:imageName data:iconData];
        curUser[@"icon"] = iconFile;
        [curUser saveInBackground];
        
        //刷新本地头像文件
        [UserIcon refreshLocalIcons];
        [self.tv_aboutMe reloadData];
        
    }
    
    
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
