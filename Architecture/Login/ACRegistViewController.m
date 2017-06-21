//
//  ACRegistViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACRegistViewController.h"
#import "Helpers.h"

@interface ACRegistViewController ()

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
    
}

- (IBAction)regist:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
