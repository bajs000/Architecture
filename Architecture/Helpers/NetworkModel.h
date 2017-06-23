//
//  NetworkModel.h
//  Architecture
//
//  Created by YunTu on 2017/6/23.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface NetworkModel : NSObject

+ (void)requestWithUrl:(NSString *)url param:(NSDictionary *)param complete:(void(^)(NSDictionary *))complete;

@end

@interface UploadNetworkModel : NSObject

+ (void)uploadWithUrl:(NSString *)url param:(NSDictionary *)param data:(id)data dataName:(NSString *)dataName complete:(void(^)(NSDictionary *))complete;

@end
