//
//  ACKindViewController.h
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ListTypeKind,
    ListTypeHistory,
} ListType;

@interface ACKindViewController : UIViewController

@property (nonatomic, assign) ListType type;

@end
