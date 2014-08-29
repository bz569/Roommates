//
//  MeViewController.m
//  Roommates
//
//  Created by Zhang Boxuan on 14-6-20.
//  Copyright (c) 2014年 Boxuan Zhang. All rights reserved.
//

#import "MeViewController.h"
#import <Parse/Parse.h>

@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UITabBarItem *barItem;

@property (strong, nonatomic) UIActionSheet *as_selectIcon;

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
    
    
}

//设置头像
- (IBAction)onClickSetIconBtn:(id)sender {
    
    self.as_selectIcon = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"从手机相册选择", @"拍照", nil];
    [self.as_selectIcon showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
        NSLog(@"iconsPath=%@", iconsPath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:iconsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        //设置图片名称
        PFUser *curUser = [PFUser currentUser];
        NSString *imageName = [NSString stringWithFormat:@"icon_%@.png", curUser.objectId];
        NSString *imagePath = [iconsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", imageName]];
        NSLog(@"imagePath=%@", imagePath);
        
        //保存图片
        [fileManager createFileAtPath:imagePath contents:iconData attributes:nil];
    
        //将头像上传至Parse数据库
        PFFile *iconFile = [PFFile fileWithName:imageName data:iconData];
        curUser[@"icon"] = iconFile;
        [curUser saveInBackground];
        
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
