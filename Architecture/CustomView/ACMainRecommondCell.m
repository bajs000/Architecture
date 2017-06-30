//
//  ACMainRecommondCell.m
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACMainRecommondCell.h"
#import "Helpers.h"

@interface ACMainRecommondCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ACMainRecommondCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDataSource:(NSArray *)dataSource{
    [super setDataSource:dataSource];
    [self.collectionView reloadData];
}

#pragma mark- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    [(UIImageView *)[cell viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_Url,dic[@"img"]]]];
    [(UILabel *)[cell viewWithTag:2] setText:dic[@"title"]];
    if (indexPath.row == 0) {
        [cell viewWithTag:3].hidden = false;
        [cell viewWithTag:4].hidden = true;
    }else if (indexPath.row == 1) {
        [cell viewWithTag:3].hidden = true;
        [cell viewWithTag:4].hidden = false;
    }else{
        [cell viewWithTag:3].hidden = true;
        [cell viewWithTag:4].hidden = true;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return CGSizeMake(ScreenWidth / 2, collectionView.frame.size.height / 2);
    }else if (indexPath.row == 2) {
        return CGSizeMake(ScreenWidth / 2, collectionView.frame.size.height / 2);
    }else{
        return CGSizeMake(ScreenWidth / 2, collectionView.frame.size.height);
    }
}

@end
