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

#define RongCloudKey @"c9kqb3rdcxarj"
#define RongCloudSecret @"evSTCmOinoW"

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif


    #endif
#endif

@interface Helpers : NSObject

+ (void)item:(UITabBarItem *_Nullable)tabItem title:(NSString *_Nullable)title normalImg:(NSString *_Nullable)normalImg selectImg:(NSString *_Nullable)selectImg;

+ (NSString*_Nullable) sha1:(NSString *_Nullable)hashString;

+ (void)getUserTokenWithUserId:(NSString *_Nullable)userId name:(NSString *_Nullable)name avatar:(NSString *_Nullable)avatarUrl complete:(void(^_Nullable)(NSString *_Nullable))complete;

+ (nullable UIView *)findSuperViewClass:(Class _Nullable )class view:(UIView *_Nullable)view;

+ (void)registRongCloud;

@end
