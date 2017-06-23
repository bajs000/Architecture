//
//  ACNicknameViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACNicknameViewController.h"
#import "Helpers.h"

@interface ACNicknameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickname;

@end

@implementation ACNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nickname.text = [UserModel shareInstance].userName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIButton Action
- (IBAction)save:(id)sender {
    [SVProgressHUD show];
    [NetworkModel requestWithUrl:@"User/unameedit" param:@{@"user_id":[UserModel shareInstance].userId,@"user_name":_nickname.text} complete:^(NSDictionary *dic) {
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


@end
