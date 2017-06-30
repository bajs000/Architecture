//
//  ACStoreViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACStoreViewController.h"
#import "Helpers.h"

@interface ACStoreViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ACStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestStore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
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
    [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"graphic"]]]];
    [(UILabel *)[cell viewWithTag:2] setText:dic[@"goods_name"]];
    [(UILabel *)[cell viewWithTag:3] setText:dic[@""]];
    [(UILabel *)[cell viewWithTag:4] setText:dic[@"price"]];
    [(UILabel *)[cell viewWithTag:5] setText:dic[@"price_y"]];
    [(UIButton *)[cell viewWithTag:6] addTarget:self action:@selector(deleteBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UIButton Action
- (void)deleteBtnDidClick:(UIButton *)sender{
    UITableViewCell *cell = (UITableViewCell *)[Helpers findSuperViewClass:[UITableViewCell class] view:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dic = self.dataSource[indexPath.row];
    [NetworkModel requestWithUrl:@"Public/shoucang_del" param:@{@"goods_id":dic[@"goods_id"],@"user_id":[UserModel shareInstance].userId} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            [self requestStore];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

- (void)requestStore{
    [NetworkModel requestWithUrl:@"Public/shoucang_list" param:@{@"user_id":[UserModel shareInstance].userId} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            self.dataSource = dic[@"list"];
            [self.tableView reloadData];
        }else{
            self.dataSource = nil;
            [self.tableView reloadData];
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
