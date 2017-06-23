//
//  AppDelegate.m
//  Architecture
//
//  Created by YunTu on 2017/6/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import "Helpers.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RCIM sharedRCIM] initWithAppKey:RongCloudKey];
    //注册推送, 用于iOS8以及iOS8之后的系统
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:(UIUserNotificationTypeBadge |
                                                              UIUserNotificationTypeSound |
                                                              UIUserNotificationTypeAlert)
                                            categories:nil];
    [application registerUserNotificationSettings:settings];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    return YES;
}

//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    [Helpers getUserTokenWithUserId:@"1" name:@"1" avatar:@"http://p1.wmpic.me/article/2016/08/15/1471251423_hgPqiEeX.jpg"/*@"http://pic.wenwen.soso.com/p/20111117/20111117224109-1750539119.jpg"*/ complete:^(NSString *token) {
        [[RCIMClient sharedRCIMClient] connectWithToken:token success:^(NSString *userId) {
            NSLog(@"%@",userId);
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            
        }];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
