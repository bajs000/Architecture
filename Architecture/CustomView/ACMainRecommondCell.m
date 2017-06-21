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

#pragma mark- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.contentView.backgroundColor = [UIColor redColor];
    }else if (indexPath.row == 1) {
        cell.contentView.backgroundColor = [UIColor greenColor];
    }else if (indexPath.row == 2) {
        cell.contentView.backgroundColor = [UIColor blueColor];
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
