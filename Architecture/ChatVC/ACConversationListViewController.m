//
//  ACConversationListViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/22.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACConversationListViewController.h"
#import "ACConversationViewController.h"
#import "Helpers.h"

@interface ACConversationListViewController ()<RCIMUserInfoDataSource>

@end

@implementation ACConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 1);
    footerView.backgroundColor = [UIColor clearColor];
    self.conversationListTableView.tableFooterView = footerView;
    self.conversationListTableView.backgroundColor = UIColorFromHex(0xF0F0F0);
    self.title = @"咨询窗口";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    RCUserInfo *user = [[RCUserInfo alloc] init];
    if ([userId  isEqual: [UserModel shareInstance].userId]) {
        user.userId = userId;
        user.name = [UserModel shareInstance].userName;
        user.portraitUri = [UserModel shareInstance].avatarUrl;
    }
    return completion(user);
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ACConversationViewController *conversationVC = [[ACConversationViewController alloc]init];
    conversationVC.hidesBottomBarWhenPushed = true;
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = @"想显示的会话标题";
    [self.navigationController pushViewController:conversationVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
