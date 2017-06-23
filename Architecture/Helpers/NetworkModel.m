//
//  NetworkModel.m
//  Architecture
//
//  Created by YunTu on 2017/6/23.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "NetworkModel.h"
#import "Helpers.h"
#import "AFNetworking/AFNetworking.h"

@implementation NetworkModel

+ (void)requestWithUrl:(NSString *)url param:(NSDictionary *)param complete:(void(^)(NSDictionary *))complete{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:param];
    [tempDic setObject:@"1.1" forKey:@"version"];
    [tempDic setObject:@"f74dd39951a0b6bbed0fe73606ea5476" forKey:@"apikey"];
    NSString *paramStr = @"";
    for (NSString *key in tempDic.allKeys) {
        paramStr = [NSString stringWithFormat:@"%@%@=%@&",paramStr,key,tempDic[key]];
    }
    if (paramStr.length > 0) {
        paramStr = [paramStr substringToIndex:paramStr.length - 1];
    }
    NSData *paramData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",paramStr);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Main_Url,url]] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
    [req setHTTPBody:paramData];
    [req setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            if (connectionError) {
                [SVProgressHUD showErrorWithStatus:@"网络问题"];
                NSLog(@"%@",connectionError);
            }else{
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                complete(dic);
            }
        });
    }];
}

@end

@implementation UploadNetworkModel

+ (void)uploadWithUrl:(NSString *)url param:(NSDictionary *)param data:(id)data dataName:(NSString *)dataName complete:(void(^)(NSDictionary *))complete{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:param];
    [tempDic setObject:@"1.1" forKey:@"version"];
    [tempDic setObject:@"f74dd39951a0b6bbed0fe73606ea5476" forKey:@"apikey"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@%@",Main_Url,url] parameters:tempDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *timeName = [[dateformatter stringFromDate:[NSDate date]] stringByAppendingString:@".jpg"];
        NSData *imgData = UIImageJPEGRepresentation((UIImage *)data, 0.2);
        [formData appendPartWithFileData:imgData name:dataName fileName:timeName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted];
        if (uploadProgress.fractionCompleted >= 1) {
            [SVProgressHUD dismiss];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络问题"];
    }];
}


@end

