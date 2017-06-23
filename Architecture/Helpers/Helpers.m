//
//  Helpers.m
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "Helpers.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Helpers

static Helpers *helpers = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helpers = [[self alloc] init];
    });
    return helpers;
}

+ (void)item:(UITabBarItem *)tabItem title:(NSString *)title normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg {
    UIImage *normalImage = [UIImage imageNamed:normalImg];
    UIImage *selectImage = [UIImage imageNamed:selectImg];
    tabItem.image = normalImage;
    tabItem.selectedImage = selectImage;
    [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x777777)} forState:UIControlStateNormal];
    [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x47a9f0)} forState:UIControlStateSelected];
    tabItem.title = title;
}

+ (NSString*) sha1:(NSString *)hashString
{
    const char *cstr = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:hashString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (void)getUserTokenWithUserId:(NSString *)userId name:(NSString *)name avatar:(NSString *)avatarUrl complete:(void(^)(NSString *))complete{
    NSDate *date = [NSDate date];
    NSString *nonce = [NSString stringWithFormat:@"%d",arc4random() % 1000000];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",RongCloudSecret,nonce,timestamp];
    NSString *signature = [self sha1:str];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.cn.ronghub.com/user/getToken.json"]];
    [req setValue:RongCloudKey forHTTPHeaderField:@"RC-App-Key"];
    [req setValue:nonce forHTTPHeaderField:@"RC-Nonce"];
    [req setValue:timestamp forHTTPHeaderField:@"RC-Timestamp"];
    [req setValue:signature forHTTPHeaderField:@"RC-Signature"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"POST"];
    NSString *param = [NSString stringWithFormat:@"userId=%@&name=%@&portraitUri=%@",userId,name,avatarUrl];
    [req setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"%@",connectionError);
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dic);
            complete(dic[@"token"]);
        }
    }];
}

@end
