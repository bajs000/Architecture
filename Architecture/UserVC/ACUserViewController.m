//
//  UserViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACUserViewController.h"
#import "ACKindViewController.h"
#import "ACLoginViewController.h"
#import "Helpers.h"

@interface ACUserViewController ()

@property (weak, nonatomic) IBOutlet UIView *avatarBg;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;

@end

@implementation ACUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarBg.layer.cornerRadius = 43;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
    if ([UserModel shareInstance].userId.length > 0) {
        [self requestUserInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出" message:@"退出登录?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UserModel shareInstance] resetAll];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault removeObjectForKey:@"USERID"];
            [userDefault synchronize];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

 #pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kindPush"]) {
        [(ACKindViewController *)segue.destinationViewController setType:ListTypeHistory];
    }
}

#pragma mark - UIButton Action
- (IBAction)loginBtnDidClick:(id)sender {
    if ([UserModel shareInstance].userId.length > 0) {
        
    }else{
        [self presentViewController:[ACLoginViewController getInstance] animated:true completion:nil];
    }
}

- (void)requestUserInfo{
    [SVProgressHUD show];
    [NetworkModel requestWithUrl:@"User" param:@{@"user_id":[UserModel shareInstance].userId} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            [UserModel saveUserInfoWithDic:dic[@"list"]];
            UserModel *user = [UserModel shareInstance];
            if (user.userName.length > 0) {
                [self.userNameBtn setTitle:user.userName forState:UIControlStateNormal];
            }else{
                [self.userNameBtn setTitle:user.phone forState:UIControlStateNormal];
            }
            [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl]];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
