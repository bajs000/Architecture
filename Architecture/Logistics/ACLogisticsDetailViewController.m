//
//  ACLogisticsDetailViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/30.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACLogisticsDetailViewController.h"
#import "Helpers.h"

@interface ACLogisticsDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIWebViewDelegate>{
    UICollectionView *_collectionView;
    UIWebView *_webView;
    BOOL loading;
}

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSDictionary *dataSource;

@end

@implementation ACLogisticsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self requestDetail];
    loading = false;
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
        return 3;
    }
    return [self.dataSource[@"tuijian"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 38;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return _headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cellIdentify = @"headerCell";
        }else if (indexPath.row == 1) {
            cellIdentify = @"infoCell";
        }else if (indexPath.row == 2) {
            cellIdentify = @"webCell";
        }
    }else{
        cellIdentify = @"Cell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _collectionView = [cell viewWithTag:1];
        }else if (indexPath.row == 1) {
            [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"联系人：%@",self.dataSource[@"list"][@"dot_user"]]];
            NSString *str = [NSString stringWithFormat:@"电  话：%@",self.dataSource[@"list"][@"dot_phone"]];
            NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:str];
            [tempStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xf40101) range:NSMakeRange(5, str.length - 5)];
            [(UILabel *)[cell viewWithTag:2] setAttributedText:tempStr];
            [(UILabel *)[cell viewWithTag:3] setText:[NSString stringWithFormat:@"地  址：%@",self.dataSource[@"list"][@"dot_addre"]]];
            [(UILabel *)[cell viewWithTag:4] setText:[NSString stringWithFormat:@"网  点：%@",self.dataSource[@"list"][@"dot_dot"]]];
        }else if (indexPath.row == 2) {
            _webView = [cell viewWithTag:1];
            _webView.scrollView.scrollEnabled = false;
            if (self.dataSource) {
                if (!loading) {
                    [_webView loadHTMLString:self.dataSource[@"list"][@"jieshao"] baseURL:nil];
                    loading = true;
                }
            }
        }
    }else{
        NSDictionary *dic = self.dataSource[@"tuijian"][indexPath.row];
        [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"dot_img"]]]];
        [(UILabel *)[cell viewWithTag:2] setText:dic[@"dot_name"]];
        [(UILabel *)[cell viewWithTag:3] setText:[NSString stringWithFormat:@"网点：%@",dic[@"dot_dot"]]];
        [(UILabel *)[cell viewWithTag:4] setText:[NSString stringWithFormat:@"地址：%@",dic[@"dot_addre"]]];
        [(UILabel *)[cell viewWithTag:5] setText:[NSString stringWithFormat:@"电话：%@",dic[@"dot_phone"]]];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource[@"list"][@"imglist"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = ScreenWidth;
    CGFloat height = ScreenWidth * 150 / 375;
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[@"list"][@"imglist"][indexPath.row];
    [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"img"]]]];
    return cell;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.tableView beginUpdates];
    [(NSLayoutConstraint *)([_webView constraints][0]) setConstant:webView.scrollView.contentSize.height + 10];
    [self.tableView endUpdates];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailPush"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *dic = self.dataSource[@"tuijian"][indexPath.row];
        [(ACLogisticsDetailViewController *)segue.destinationViewController setTitle:dic[@"dot_name"]];
        [(ACLogisticsDetailViewController *)segue.destinationViewController setLogisticsInfo:dic];
    }
}

- (void)requestDetail {
    [SVProgressHUD show];
    [NetworkModel requestWithUrl:@"Express/express_details" param:@{@"dot_id":_logisticsInfo[@"dot_id"],@"page":@"1"} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            self.dataSource = dic;
            [self.tableView reloadData];
            [_collectionView reloadData];
            [self.tableView beginUpdates];
            [(NSLayoutConstraint *)([_collectionView constraints][0]) setConstant:ScreenWidth * 150 / 375];
            [self.tableView endUpdates];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
