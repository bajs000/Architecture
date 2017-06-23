//
//  Helpers.h
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetworkModel.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]

#define Main_Url @"http://jiancai.cq1b1.com/api.php/"
#define Image_Url @"http://jiancai.cq1b1.com/"

#define RongCloudKey @"cpj2xarlc3hfn"
#define RongCloudSecret @"sDYzkLV0O6htSQ"

@interface Helpers : NSObject

+ (void)item:(UITabBarItem *)tabItem title:(NSString *)title normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg;

+ (NSString*) sha1:(NSString *)hashString;

+ (void)getUserTokenWithUserId:(NSString *)userId name:(NSString *)name avatar:(NSString *)avatarUrl complete:(void(^)(NSString *))complete;

@end
