//
//  ACGoodsDetailViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/29.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACGoodsDetailViewController.h"
#import "ACKindViewController.h"
#import "Helpers.h"

@interface ACGoodsDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIWebViewDelegate>{
    UICollectionView *_collectionView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSDictionary *dataSource;

@end

@implementation ACGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.title = @"商品";
    self.webView.scrollView.scrollEnabled = false;
    [self requestGoods];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentify = @"";
    if (indexPath.row == 0) {
        cellIdentify = @"headerCell";
    }else if (indexPath.row == 1){
        cellIdentify = @"goodsCell";
    }else{
        cellIdentify = @"moreCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    if (indexPath.row == 0) {
        _collectionView = [cell viewWithTag:1];
    }else if (indexPath.row == 1){
        [(UILabel *)[cell viewWithTag:1] setText:self.dataSource[@"list"][@"goods_name"]];
        NSString *str = [NSString stringWithFormat:@"￥%@",self.dataSource[@"list"][@"price"]];
        NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:str];
        [tempStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
        [(UILabel *)[cell viewWithTag:2] setAttributedText:tempStr];
//        [(UILabel *)[cell viewWithTag:4] setText:self.dataSource[@"list"][@"price"]];
        if ([[NSString stringWithFormat:@"%@",self.dataSource[@"shoucang_state"]]  isEqual: @"1"]){
            [(UIButton *)[cell viewWithTag:3] setImage:[UIImage imageNamed:@"mine-0"] forState:UIControlStateNormal];
        }else{
            [(UIButton *)[cell viewWithTag:3] setImage:[UIImage imageNamed:@"goods-store"] forState:UIControlStateNormal];
        }
        [(UIButton *)[cell viewWithTag:3] addTarget:self action:@selector(storeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [(UILabel *)[cell viewWithTag:5] setText:self.dataSource[@"list"][@"price_y"]];
    }else{
        
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource[@"list"][@"imglist"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth, ScreenWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[@"list"][@"imglist"][indexPath.row];
    [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"graphic"]]]];
    return cell;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.footerView.frame = CGRectMake(0, 0, ScreenWidth, webView.scrollView.contentSize.height + 61);
    [self.tableView beginUpdates];
    self.tableView.tableFooterView = self.footerView;
    [self.tableView endUpdates];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"shopPush"]) {
        [(ACKindViewController *)segue.destinationViewController setTypeInfo:self.dataSource[@"list"]];
        [(ACKindViewController *)segue.destinationViewController setType:ListTypeKind];
        [(ACKindViewController *)segue.destinationViewController setTypeId:@""];
    }
}

#pragma mark- UIButton Action
- (IBAction)shopBtnDidClick:(id)sender {
    if (_pushByShop) {
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [self performSegueWithIdentifier:@"shopPush" sender:self.dataSource];
    }
}

- (void)storeBtnDidClick:(UIButton *)sender{
    if ([UserModel shareInstance].userId.length == 0) {
        [[UserModel shareInstance] checkOutLogin:self];
        return;
    }
    [SVProgressHUD show];
    NSString *url = @"";
    if ([[NSString stringWithFormat:@"%@",self.dataSource[@"shoucang_state"]]  isEqual: @"1"]){
        url = @"Public/shoucang_add";
    }else{
        url = @"Public/shoucang_del";
    }
    [NetworkModel requestWithUrl:url param:@{@"goods_id":_goodsInfo[@"goods_id"],@"user_id":[UserModel shareInstance].userId} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",dic);
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

- (void)requestGoods{
    [SVProgressHUD show];
    [NetworkModel requestWithUrl:@"Public/goods_details" param:@{@"goods_id":_goodsInfo[@"goods_id"],@"user_id":[UserModel shareInstance].userId} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            self.dataSource = dic;
            [self.tableView reloadData];
            [self.webView loadHTMLString:dic[@"list"][@"details"] baseURL:nil];
            [_collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
