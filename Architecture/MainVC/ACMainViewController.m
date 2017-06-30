//
//  ACMainViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACMainViewController.h"
#import "ACAttetionViewController.h"
#import "ACMainCell.h"
#import "Helpers.h"
#import "ACKindViewController.h"
#import "ACLogisticsViewController.h"
#import "ACConversationListViewController.h"
#import "ACUserViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <MJRefresh/MJRefresh.h>

@interface ACMainViewController ()<UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *titleViewBg;
@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic, strong) NSMutableArray *busyList;

@end

@implementation ACMainViewController

static int page = 1;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.navigationItem.titleView = self.titleView;
    self.titleViewBg.layer.cornerRadius = 14;
    self.tabBarController.delegate = self;
    
    NSArray *barArr = @[@"首页",@"咨询窗口",@"物流搜索",@"我的"];
    for (int i = 0; i < barArr.count; i++) {
        UITabBarItem *item = self.tabBarController.tabBar.items[i];
        [Helpers item:item title:barArr[i] normalImg:[NSString stringWithFormat:@"tabbar-select-%d",i] selectImg:[NSString stringWithFormat:@"tabbar-unselect-%d",i]];
    }
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        @strongify(self)
        [self requestMain];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        @strongify(self)
        [self requestMain];
    }];
    [self.tableView.mj_header beginRefreshing];
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
    return self.busyList.count;
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
    if (indexPath.section == 0) {
        [(ACMainCell *)cell setDataSource:self.dataSource[@"img"]];
    }else if (indexPath.section == 1) {
        [(ACMainCell *)cell setDataSource:self.dataSource[@"type"]];
    }else if (indexPath.section == 2) {
        if (self.dataSource[@"tuijian_noe"]) {
            NSMutableArray *arr = [NSMutableArray arrayWithObject:self.dataSource[@"tuijian_noe"]];
            [arr addObjectsFromArray:self.dataSource[@"tuijian_two"]];
            [(ACMainCell *)cell setDataSource:arr];
        }
    }else if (indexPath.section == 3) {
        [(ACMainCell *)cell setDataSource:self.dataSource[@"tuijian_therr"]];
    }else if (indexPath.section == 4) {
        NSDictionary *dic = self.busyList[indexPath.row];
        [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"bus_logo"]]]];
        [(UILabel *)[cell viewWithTag:2] setText:dic[@"bus_title"]];
        [(UILabel *)[cell viewWithTag:3] setText:dic[@"bus_type"]];
        [(UILabel *)[cell viewWithTag:4] setText:dic[@""]];
    }
    return cell;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kindPush"]) {
        [(ACAttetionViewController *)segue.destinationViewController setType:AttentionTypeKind];
        [(ACAttetionViewController *)segue.destinationViewController setTypeInfo:sender];
        [(ACAttetionViewController *)segue.destinationViewController setTitle:sender[@"type_title"]];
    }else if ([segue.identifier isEqualToString:@"shopPush"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *dic = self.busyList[indexPath.row];
        [(ACKindViewController *)segue.destinationViewController setTypeInfo:dic];
        [(ACKindViewController *)segue.destinationViewController setType:ListTypeKind];
        [(ACKindViewController *)segue.destinationViewController setTypeId:@""];
    }
}

#pragma mark- UITabbarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *vc = [(UINavigationController *)viewController topViewController];
    if ([vc isKindOfClass:[ACUserViewController class]] || [vc isKindOfClass:[ACConversationListViewController class]]) {
        if ([UserModel shareInstance].userId.length == 0) {
            [[UserModel shareInstance] checkOutLogin:self];
            return false;
        }
    }
    
    return true;
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


- (void)requestMain{
    [SVProgressHUD show];
    [NetworkModel requestWithUrl:@"Public" param:@{@"page":[NSString stringWithFormat:@"%d",page]} complete:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        self.dataSource = dic;
        if (page == 1) {
            self.busyList = [NSMutableArray array];
        }
        if ([self.dataSource[@"buslist"] isKindOfClass:[NSArray class]]) {
            [self.busyList addObjectsFromArray:self.dataSource[@"buslist"]];
        }
        [self.tableView reloadData];
    }];
}

@end
