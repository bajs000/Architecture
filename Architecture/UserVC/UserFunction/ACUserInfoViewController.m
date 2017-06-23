//
//  ACUserInfoViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACUserInfoViewController.h"
#import "Helpers.h"

@interface ACUserInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation ACUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatar.layer.cornerRadius = 30;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].avatarUrl]];
    self.userName.text = [UserModel shareInstance].userName;
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

@end
