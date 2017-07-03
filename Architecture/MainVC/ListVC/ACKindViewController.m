//
//  ACKindViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACKindViewController.h"
#import "Helpers.h"
#import "ACKindSortViewController.h"
#import "ACGoodsDetailViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface ACKindViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSMutableDictionary *currentParam;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *adCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *priceSort;
@property (weak, nonatomic) IBOutlet UIImageView *saleSort;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic, strong) NSMutableArray *goodsList;

@end

@implementation ACKindViewController

static int page = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        page = 1;
        [currentParam setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        [self requestKind:currentParam];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        page++;
        [currentParam setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        [self requestKind:currentParam];
    }];
    [self.collectionView.mj_header beginRefreshing];
    self.title = self.typeInfo[@"bus_title"];
    if (_type == ListTypeHistory) {
        self.title = @"历史记录";
        currentParam = [NSMutableDictionary dictionaryWithDictionary:@{@"user_id":@"1",@"page":[NSString stringWithFormat:@"%d",page]}];
        self.topViewHeight.constant = 0;
    }else if (_type == ListTypeKind){
        _topViewHeight.constant = 0;
        currentParam = [NSMutableDictionary dictionaryWithDictionary:@{@"bus_id":self.typeInfo[@"bus_id"],@"user_id":[UserModel shareInstance].userId,@"page":[NSString stringWithFormat:@"%d",page],@"type_id":_typeId}];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"kind dealloc");
}

#pragma mark- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:_adCollectionView]) {
        return 1;
    }
    return [self.goodsList count];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if ([collectionView isEqual:_adCollectionView]) {
//        return CGSizeZero;
//    }
//    if (_type == ListTypeKind) {
//        return CGSizeMake(ScreenWidth, 150);
//    }
//    return CGSizeMake(ScreenWidth, 0);
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if ([collectionView isEqual:_adCollectionView]) {
//        return nil;
//    }
//    UICollectionReusableView *header = nil;
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
//        _adCollectionView = [header viewWithTag:1];
//    }
//    return header;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if ([collectionView isEqual:_adCollectionView]) {
        NSDictionary *dic = self.dataSource[@"buslist"];
        [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"bus_logo"]]]];
        [(UILabel *)[cell viewWithTag:6] setText:[NSString stringWithFormat:@"%@人",self.dataSource[@"guanzhu_num"]]];
        if ([self.dataSource[@"guanzhu_state"] intValue] == 1) {
            [(UILabel *)[cell viewWithTag:5] setText:@"已关注"];
            [(UILabel *)[cell viewWithTag:5] setTextColor:UIColorFromHex(0xF40000)];
        }else{
            [(UILabel *)[cell viewWithTag:5] setText:@"未关注"];
            [(UILabel *)[cell viewWithTag:5] setTextColor:UIColorFromHex(0x777777)];
        }
        [(UIButton *)[cell viewWithTag:7] addTarget:self action:@selector(attentionBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [(UILabel *)[cell viewWithTag:2] setText:[NSString stringWithFormat:@"主营：%@",self.dataSource[@"buslist"][@"bus_type"]]];
    }else{
        NSDictionary *dic = self.goodsList[indexPath.row];
        [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"graphic"]]]];
        [(UILabel *)[cell viewWithTag:2] setText:dic[@"goods_name"]];
        [(UILabel *)[cell viewWithTag:3] setText:dic[@"price"]];
        [(UILabel *)[cell viewWithTag:4] setText:dic[@"price_y"]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_adCollectionView]) {
        return collectionView.frame.size;
    }
    return CGSizeMake((ScreenWidth - 3) / 2, 270);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"sortPush"]) {
        [(ACKindSortViewController *)segue.destinationViewController setTypeInfo:self.dataSource[@"buslist"]];
        [(ACKindSortViewController *)segue.destinationViewController setChose:^(NSDictionary *dic){
            NSLog(@"%@",dic);
            [self requestKind:@{@"type_id":dic[@"type_id"]}];
        }];
    }else if([segue.identifier isEqualToString:@"goodsPush"]){
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        NSDictionary *dic = self.goodsList[indexPath.row];
        [(ACGoodsDetailViewController *)segue.destinationViewController setGoodsInfo:dic];
        [(ACGoodsDetailViewController *)segue.destinationViewController setPushByShop:true];
    }
}

#pragma mark - UIButton Action
- (IBAction)kindBtnDidClick:(id)sender {
    
}

- (IBAction)priceSortBtnDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSDictionary *dic;
    if (sender.selected) {
        dic = @{@"price":@"price_s"};
        _priceSort.image = [UIImage imageNamed:@"list-sort-up"];
    }else{
        dic = @{@"price":@"price_j"};
        _priceSort.image = [UIImage imageNamed:@"list-sort-down"];
    }
    [currentParam addEntriesFromDictionary:dic];
    [self requestKind:currentParam];
}

- (IBAction)salesVolumeSortBtnDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSDictionary *dic;
    if (sender.selected) {
        dic = @{@"sales":@"sales_s"};
        _saleSort.image = [UIImage imageNamed:@"list-sort-up"];
    }else{
        dic = @{@"sales":@"sales_j"};
        _saleSort.image = [UIImage imageNamed:@"list-sort-down"];
    }
    [currentParam addEntriesFromDictionary:dic];
    [self requestKind:currentParam];
}

- (void)attentionBtnDidClick:(UIButton *)sender{
    if ([UserModel shareInstance].userId.length == 0) {
        [[UserModel shareInstance] checkOutLogin:self];
        return;
    }
    [SVProgressHUD show];
    NSString *url = @"Public/guanzhu_add";
    [NetworkModel requestWithUrl:url param:@{@"bus_id":_typeInfo[@"bus_id"],@"user_id":[UserModel shareInstance].userId} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            [self requestKind:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

- (void)requestKind:(NSDictionary *)dic{
    if (dic) {
        [currentParam addEntriesFromDictionary:dic];
    }
    [SVProgressHUD show];
    NSString *url = @"Public/bus_details";
    if (_type == ListTypeHistory) {
        url = @"Public/history_list";
    }
    [NetworkModel requestWithUrl:url param:currentParam complete:^(NSDictionary *dic) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            self.dataSource = dic;
            if (page == 1) {
                _goodsList = [NSMutableArray array];
            }
            NSString *key = @"goodslist";
            if (_type == ListTypeHistory) {
                key = @"list";
            }
            if ([self.dataSource[key] isKindOfClass:[NSArray class]]) {
                [_goodsList addObjectsFromArray:self.dataSource[key]];
            }
            [self.collectionView reloadData];
            [self.adCollectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
