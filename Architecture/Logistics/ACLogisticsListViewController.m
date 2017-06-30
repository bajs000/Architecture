//
//  ACLogisticsListViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/30.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACLogisticsListViewController.h"
#import "Helpers.h"
#import "ACLogisticsDetailViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface ACLogisticsListViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *titleViewBg;

@end

@implementation ACLogisticsListViewController

static int page = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        @strongify(self)
        [self requestList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        @strongify(self);
        [self requestList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.navigationItem.titleView = self.titleView;
    self.titleViewBg.layer.cornerRadius = 14;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"dot_img"]]]];
    [(UILabel *)[cell viewWithTag:2] setText:dic[@"dot_name"]];
    [(UILabel *)[cell viewWithTag:3] setText:[NSString stringWithFormat:@"网点：%@",dic[@"dot_dot"]]];
    [(UILabel *)[cell viewWithTag:4] setText:[NSString stringWithFormat:@"地址：%@",dic[@"dot_addre"]]];
    [(UILabel *)[cell viewWithTag:5] setText:[NSString stringWithFormat:@"电话：%@",dic[@"dot_phone"]]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailPush"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *dic = self.dataSource[indexPath.row];
        [(ACLogisticsDetailViewController *)segue.destinationViewController setTitle:dic[@"dot_name"]];
        [(ACLogisticsDetailViewController *)segue.destinationViewController setLogisticsInfo:dic];
    }
}

- (void)requestList{
    [SVProgressHUD show];
    [NetworkModel requestWithUrl:@"Express/express_dot" param:@{@"express_id":_logisticsInfo[@"express_id"],@"page":[NSString stringWithFormat:@"%d",page]} complete:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            self.dataSource = dic[@"list"];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
