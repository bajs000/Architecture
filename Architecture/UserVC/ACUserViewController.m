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

@interface ACUserViewController ()

@property (weak, nonatomic) IBOutlet UIView *avatarBg;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;

@end

@implementation ACUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarBg.layer.cornerRadius = 43;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

 #pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kindPush"]) {
        [(ACKindViewController *)segue.destinationViewController setType:ListTypeHistory];
    }
}

#pragma mark - UIButton Action
- (IBAction)loginBtnDidClick:(id)sender {
    [self presentViewController:[ACLoginViewController getInstance] animated:true completion:nil];
}


@end
