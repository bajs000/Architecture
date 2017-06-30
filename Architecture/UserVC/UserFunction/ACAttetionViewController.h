//
//  ACAttetionViewController.h
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AttentionTypeKind,
    AttentionTypeMine,
} AttentionType;

@interface ACAttetionViewController : UIViewController

@property (nonatomic, assign) AttentionType type;
@property (nonatomic, strong) NSDictionary *typeInfo;

@end
