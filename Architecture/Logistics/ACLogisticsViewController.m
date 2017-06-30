//
//  ACLogisticsViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACLogisticsViewController.h"
#import "Helpers.h"
#import "ACLogisticsListViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface ACLogisticsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSString *currentSearch;
    UICollectionView *_collectionView;
}

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *titleViewBg;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *imgArr;

@end

@implementation ACLogisticsViewController

static int page = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.navigationItem.titleView = _titleView;
    self.titleViewBg.layer.cornerRadius = 14;
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        @strongify(self)
        [self requestLogistics];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page ++;
        @strongify(self)
        [self requestLogistics];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"";
    if (indexPath.section == 0) {
        cellIdentify = @"adCell";
    }else{
        cellIdentify = @"Cell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    if (indexPath.section == 0) {
        _collectionView = [cell viewWithTag:1];
    }else{
        
        [(UILabel *)[cell viewWithTag:1] setText:dic[@"express_name"]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imgArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth, 150);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = _imgArr[indexPath.row];
    [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"bigpic"]]]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"listPush"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *dic = self.dataSource[indexPath.row];
        [(ACLogisticsListViewController *)segue.destinationViewController setLogisticsInfo:dic];
    }
}

#pragma mark - UIButton Action

- (IBAction)searchTextDidSearch:(id)sender {
    currentSearch = _searchTextField.text;
    if (_searchTextField.text.length == 0) {
        currentSearch = nil;
    }
    [self requestLogistics];
    [[UIApplication sharedApplication].keyWindow endEditing:true];
}

- (IBAction)searhBtnDidClick:(id)sender {
    currentSearch = _searchTextField.text;
    if (_searchTextField.text.length == 0) {
        currentSearch = nil;
    }
    [self requestLogistics];
    [[UIApplication sharedApplication].keyWindow endEditing:true];
}

- (void)requestLogistics{
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSString stringWithFormat:@"%d",page]}];
    if (currentSearch) {
        [param setObject:currentSearch forKey:@"express_name"];
    }
    [NetworkModel requestWithUrl:@"Express" param:param complete:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            self.dataSource = dic[@"list"];
            self.imgArr = dic[@"img"];
            [self.tableView reloadData];
            [_collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
