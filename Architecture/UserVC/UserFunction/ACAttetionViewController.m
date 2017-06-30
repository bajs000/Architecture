//
//  ACAttetionViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACAttetionViewController.h"
#import "Helpers.h"
#import "ACKindSortViewController.h"
#import "ACKindViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface ACAttetionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ACAttetionViewController

static int page = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        page = 1;
        [self requestAttention];
    }];
    [self.tableView.mj_header beginRefreshing];
    if (_type == AttentionTypeKind) {
        self.topViewHeight.constant = 50;
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            page++;
            [self requestAttention];
        }];
    }else{
        self.topViewHeight.constant = 0;
    }
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
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"bus_logo"]]]];
    [(UILabel *)[cell viewWithTag:2] setText:dic[@"bus_title"]];
    [(UILabel *)[cell viewWithTag:3] setText:dic[@"bus_type"]];
    [(UILabel *)[cell viewWithTag:4] setText:dic[@"bus_phone"]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"kindPush"]) {
        [(ACKindSortViewController *)segue.destinationViewController setTypeInfo:self.typeInfo];
        [(ACKindSortViewController *)segue.destinationViewController setChose:^(NSDictionary *dic){
            NSLog(@"%@",dic);
        }];
    }else if ([segue.identifier isEqualToString:@"shopPush"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *dic = self.dataSource[indexPath.row];
        [(ACKindViewController *)segue.destinationViewController setTypeInfo:dic];
        [(ACKindViewController *)segue.destinationViewController setType:ListTypeKind];
        if (self.typeInfo[@"type_id"]) {
            [(ACKindViewController *)segue.destinationViewController setTypeId:self.typeInfo[@"type_id"]];
        }else{
            [(ACKindViewController *)segue.destinationViewController setTypeId:@""];
        }
        
    }
}

- (void)requestAttention {
    [SVProgressHUD show];
    NSString *url = nil;
    NSDictionary *param = nil;
    if (_type == AttentionTypeMine) {
        self.title = @"我关注的店铺";
        url = @"Public/guanzhu_list";
        param = @{@"user_id":[UserModel shareInstance].userId};
    }else{
        url = @"Public/bus_list";
        param = @{@"type_id":self.typeInfo[@"type_id"],@"page":[NSString stringWithFormat:@"%d",page]};
    }
    [NetworkModel requestWithUrl:url param:param complete:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            if (page == 1) {
                _dataSource = [NSMutableArray array];
            }
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
