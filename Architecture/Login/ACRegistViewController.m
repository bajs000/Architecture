//
//  ACRegistViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACRegistViewController.h"
#import "Helpers.h"

@interface ACRegistViewController (){
    NSString *verifyCode;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *surePwd;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation ACRegistViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.verifyBtn.layer.cornerRadius = 15;
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:self.protocolLabel.text];
    [tempStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xf40103) range:NSMakeRange(10, tempStr.length - 10)];
    self.protocolLabel.attributedText = tempStr;
    if (_type == RegistTypeFindPWD) {
        [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        self.protocolLabel.hidden = true;
        self.title = @"找回密码";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"regist dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIButton Action
- (IBAction)verifyBtnDidClick:(id)sender {
    if (self.phoneNum.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    [SVProgressHUD show];
    NSString *url = @"";
    if (_type == RegistTypeRegist) {
        url = @"Register/register_yzm";
    }else{
        url = @"Register/gain_yzm";
    }
    [NetworkModel requestWithUrl:url param:@{@"phone":self.phoneNum.text} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",dic);
            verifyCode = dic[@"verify"];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

- (IBAction)regist:(id)sender {
    if (self.phoneNum.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (self.verifyTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (self.password.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (self.surePwd.text != self.password.text) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        return;
    }
    if (!verifyCode) {
        [SVProgressHUD showErrorWithStatus:@"请先获取验证码"];
        return;
    }
    if (verifyCode != self.verifyTextField.text) {
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return;
    }
    [SVProgressHUD show];
    NSString *url = @"";
    if (_type == RegistTypeRegist) {
        url = @"Register";
    }else{
        url = @"Register/pwd_wjedit";
    }
    [NetworkModel requestWithUrl:url param:@{@"phone":self.phoneNum.text,@"pass":self.password.text} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            if (_type == RegistTypeRegist) {
                [UserModel saveUserInfoWithDic:dic[@"uinfo"]];
                [self dismissViewControllerAnimated:true completion:nil];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popViewControllerAnimated:true];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
