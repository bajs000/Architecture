//
//  ACRegistViewController.h
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RegistTypeRegist,
    RegistTypeFindPWD,
} RegistType;

@interface ACRegistViewController : UITableViewController

@property (nonatomic, assign) RegistType type;

@end
