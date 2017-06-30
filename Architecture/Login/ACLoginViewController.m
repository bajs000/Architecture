//
//  ACLoginViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACLoginViewController.h"
#import "ACTextFieldFactory.h"
#import "Helpers.h"
#import "ACRegistViewController.h"

@interface ACLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *avatarBg;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet ACPhoneTextFiled *phoneNum;
@property (weak, nonatomic) IBOutlet ACPWDTextFiled *password;
@property (weak, nonatomic) IBOutlet UILabel *registLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTop;

@end

@implementation ACLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:self.registLabel.text];
    [tempStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x47a9f0) range:NSMakeRange(8, 4)];
    [tempStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(8, 4)];
    self.registLabel.attributedText = tempStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (ACLoginViewController *)getInstance{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"registPush"]) {
        [(ACRegistViewController *)segue.destinationViewController setType:RegistTypeRegist];
    }else if([segue.identifier isEqualToString:@"findPush"]) {
        [(ACRegistViewController *)segue.destinationViewController setType:RegistTypeFindPWD];
    }
}

#pragma mark - UIButton Action
- (IBAction)forgetPwd:(id)sender {
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)login:(id)sender {
    if (self.phoneNum.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (self.password.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    [SVProgressHUD show];
    [NetworkModel requestWithUrl:@"Login" param:@{@"phone":self.phoneNum.text,@"pass":self.password.text} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            [UserModel saveUserInfoWithDic:dic[@"uinfo"]];
            [self dismissViewControllerAnimated:true completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

- (IBAction)regist:(id)sender {
    
}

@end
