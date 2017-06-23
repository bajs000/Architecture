//
//  ACMainViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACMainViewController.h"
#import "ACKindViewController.h"
#import "ACMainCell.h"
#import "Helpers.h"
#import <RongIMKit/RongIMKit.h>

@interface ACMainViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *titleViewBg;

@end

@implementation ACMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.navigationItem.titleView = self.titleView;
    self.titleViewBg.layer.cornerRadius = 14;
    
    NSArray *barArr = @[@"首页",@"咨询窗口",@"物流搜索",@"我的"];
    for (int i = 0; i < barArr.count; i++) {
        UITabBarItem *item = self.tabBarController.tabBar.items[i];
        [Helpers item:item title:barArr[i] normalImg:[NSString stringWithFormat:@"tabbar-select-%d",i] selectImg:[NSString stringWithFormat:@"tabbar-unselect-%d",i]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 4) {
        return  1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 4){
        return self.headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"";
    if (indexPath.section == 0) {
        cellIdentify = @"adCell";
    }else if (indexPath.section == 1) {
        cellIdentify = @"kindCell";
    }else if (indexPath.section == 2) {
        cellIdentify = @"recommondCell";
    }else if (indexPath.section == 3) {
        cellIdentify = @"sortCell";
    }else if (indexPath.section == 4) {
        cellIdentify = @"mainCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    if (indexPath.section < 4) {
        [(ACMainCell *)cell setVc:self];
    }
    
    return cell;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kindPush"]) {
        [(ACKindViewController *)segue.destinationViewController setType:ListTypeKind];
    }
}

#pragma mark - UIButton Action
- (IBAction)shopBtnDidClick:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:true];
}

- (IBAction)searchTextDidSearch:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:true];
}

- (IBAction)searhBtnDidClick:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.hidesBottomBarWhenPushed = true;
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = @"2";
    conversationVC.title = @"想显示的会话标题";
    [self.navigationController pushViewController:conversationVC animated:YES];
}


@end
