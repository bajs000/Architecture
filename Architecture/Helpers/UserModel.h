//
//  UserModel.h
//  Architecture
//
//  Created by YunTu on 2017/6/23.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserModel : NSObject

@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) NSString *avatarUrl;
@property (nonatomic, readonly) NSString *passwordMD5;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *shakey;
@property (nonatomic, readonly) NSString *time;
@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *token;

+ (instancetype)shareInstance;
+ (void)saveUserInfoWithDic:(NSDictionary *)dic;

- (void)checkOutLogin:(UIViewController *)vc;

- (void)resetAll;
- (void)resetAvatar:(NSString *)url;
- (void)resetUserName:(NSString *)userName;

@end
