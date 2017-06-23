//
//  ACAvatarViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACAvatarViewController.h"
#import "Helpers.h"

@interface ACAvatarViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end

@implementation ACAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatar.layer.cornerRadius = 58.5;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].avatarUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    if (indexPath.row == 0) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }else{
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:imgPicker animated:true completion:nil];
}

#pragma mark - UIImagePickerViewControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.navigationItem setHidesBackButton:true];
    self.avatar.image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:true completion:nil];
    [UploadNetworkModel uploadWithUrl:@"User/faceedit" param:@{@"user_id":[UserModel shareInstance].userId} data:self.avatar.image dataName:@"face" complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:true];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
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
