//
//  ACMainSortCell.m
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACMainSortCell.h"
#import "Helpers.h"

@interface ACMainSortCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ACMainSortCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.contentView.backgroundColor = UIColorFromHex(0xf6e7e7);
    }else if (indexPath.row == 1) {
        cell.contentView.backgroundColor = UIColorFromHex(0xe7f6f4);
    }else if (indexPath.row == 2) {
        cell.contentView.backgroundColor = UIColorFromHex(0xf3e5d5);
    }else if (indexPath.row == 3) {
        cell.contentView.backgroundColor = UIColorFromHex(0xdfe7f3);
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth / 4, collectionView.frame.size.height);
}

@end
