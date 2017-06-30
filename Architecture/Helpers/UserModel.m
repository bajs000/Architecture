//
//  UserModel.m
//  Architecture
//
//  Created by YunTu on 2017/6/23.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "UserModel.h"
#import "Helpers.h"
#import "ACLoginViewController.h"

@interface UserModel()

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *passwordMD5;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *shakey;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *token;

@end

@implementation UserModel

static UserModel *user = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[UserModel alloc] init];
    });
    return user;
}

+ (void)saveUserInfoWithDic:(NSDictionary *)dic{
    [[self shareInstance] resetAll];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dic[@"user_id"] forKey:@"USERID"];
    [userDefault setObject:dic[@"face"] forKey:@"AVATARURL"];
    [userDefault setObject:dic[@"password"] forKey:@"PWDMD5"];
    [userDefault setObject:dic[@"phone"] forKey:@"PHONE"];
    [userDefault setObject:dic[@"shakey"] forKey:@"SHAKEY"];
    [userDefault setObject:dic[@"time"] forKey:@"TIME"];
    [userDefault setObject:dic[@"user_name"] forKey:@"USERNAME"];
    [userDefault setObject:dic[@"face"] forKey:dic[@"phone"]];
    [userDefault synchronize];
    [Helpers registRongCloud];
}

- (NSString *)userId{
    if (_userId) {
        return _userId;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]) {
        _userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    }else {
        return @"";
    }
    return _userId;
}

- (NSString *)avatarUrl{
    if (_avatarUrl) {
        return _avatarUrl;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"AVATARURL"]) {
        _avatarUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"AVATARURL"];
        if (![_avatarUrl hasPrefix:@"http://"]) {
            _avatarUrl = [NSString stringWithFormat:@"%@%@",Image_Url,_avatarUrl];
        }
    }else {
        return @"";
    }
    return _avatarUrl;
}

- (NSString *)passwordMD5{
    if (_passwordMD5) {
        return _passwordMD5;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PWDMD5"]) {
        _passwordMD5 = [[NSUserDefaults standardUserDefaults] objectForKey:@"PWDMD5"];
    }else {
        return @"";
    }
    return _passwordMD5;
}

- (NSString *)phone{
    if (_phone) {
        return _phone;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"]) {
        _phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"];
    }else {
        return @"";
    }
    return _phone;
}

- (NSString *)shakey{
    if (_shakey) {
        return _shakey;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SHAKEY"]) {
        _shakey = [[NSUserDefaults standardUserDefaults] objectForKey:@"SHAKEY"];
    }else {
        return @"";
    }
    return _shakey;
}

- (NSString *)time{
    if (_time) {
        return _time;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TIME"]) {
        _time = [[NSUserDefaults standardUserDefaults] objectForKey:@"TIME"];
    }else {
        return @"";
    }
    return _time;
}

- (NSString *)userName{
    if (_userName) {
        return _userName;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"]) {
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    }else {
        return @"";
    }
    return _userName;
}

- (void)resetAll{
    _userId = nil;
    _phone = nil;
    _avatarUrl = nil;
    _passwordMD5 = nil;
    _userName = nil;
    _time = nil;
    _shakey = nil;
}

- (void)resetAvatar:(NSString *)url{
    _avatarUrl = nil;
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"AVATARURL"];
}

- (void)resetUserName:(NSString *)userName{
    _userName = nil;
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"USERNAME"];
}

- (void)checkOutLogin:(UIViewController *)vc{
    if (self.userId.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请登录"];
        [vc presentViewController:[ACLoginViewController getInstance] animated:true completion:nil];
    }
}

@end
