//
//  ACKindSortViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACKindSortViewController.h"
#import "Helpers.h"
#import <MJRefresh/MJRefresh.h>

typedef enum : NSUInteger {
    KindSortTypeShop,
    KindSortTypeBus,
} KindSortType;

@interface ACKindSortViewController (){
    NSIndexPath *currentIndexPath;
    KindSortType type;
    int count;
}

@property (nonatomic, strong) NSDictionary *dataSource;

@end

@implementation ACKindSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestSort];
    }];
    count = 0;
    [self.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTypeInfo:(NSDictionary *)typeInfo{
    _typeInfo = typeInfo;
    if (!_typeInfo[@"type_id"]) {
        type = KindSortTypeBus;
    }else{
        type = KindSortTypeShop;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource[@"list"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell viewWithTag:1].layer.cornerRadius = 8;
    [cell viewWithTag:1].backgroundColor = [UIColor clearColor];
    if (currentIndexPath && currentIndexPath.row == indexPath.row) {
        [cell viewWithTag:1].backgroundColor = UIColorFromHex(0x47a9f0);
    }
    NSDictionary *dic = self.dataSource[@"list"][indexPath.row];
    [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"type_app_img"]]]];
    [(UILabel *)[cell viewWithTag:2] setText:dic[@"type_title"]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (type == KindSortTypeBus) {
        if (count == 1) {
            currentIndexPath = indexPath;
            [collectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.chose) {
                    NSDictionary *dic = self.dataSource[@"list"][indexPath.row];
                    self.chose(dic);
                }
                [self.navigationController popViewControllerAnimated:true];
            });
            return;
        }
        count ++;
        self.dataSource = @{@"list":self.dataSource[@"list"][indexPath.row][@"type_two"]};
        [collectionView reloadData];
        return;
    }
    currentIndexPath = indexPath;
    [collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.chose) {
            NSDictionary *dic = self.dataSource[@"list"][indexPath.row];
            self.chose(dic);
        }
        [self.navigationController popViewControllerAnimated:true];
    });
}

- (void)requestSort {
    [SVProgressHUD show];
    NSDictionary *param = nil;
    NSString *url = @"";
    if (!_typeInfo[@"type_id"]) {
        param = @{@"bus_id":self.typeInfo[@"bus_id"]};
        url = @"Public/type_bus";
    }else{
        param = @{@"type_id":self.typeInfo[@"type_id"]};
        url = @"Public/type_list";
    }
    [NetworkModel requestWithUrl:url param:param complete:^(NSDictionary *dic) {
        [self.collectionView.mj_header endRefreshing];
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            self.dataSource = dic;
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
