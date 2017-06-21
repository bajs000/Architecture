//
//  Helpers.m
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+ (void)item:(UITabBarItem *)tabItem title:(NSString *)title normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg {
    UIImage *normalImage = [UIImage imageNamed:normalImg];
    UIImage *selectImage = [UIImage imageNamed:selectImg];
    tabItem.image = normalImage;
    tabItem.selectedImage = selectImage;
    [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x777777)} forState:UIControlStateNormal];
    [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x47a9f0)} forState:UIControlStateSelected];
    tabItem.title = title;
}

@end
