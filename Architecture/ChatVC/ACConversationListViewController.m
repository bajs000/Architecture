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

@property (nonatomic, strong) NSMutableDictionary *dataSource;

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataSource = [NSMutableDictionary dictionary];
    [self requestConversation];
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
    conversationVC.title = [(RCUserInfo *)_dataSource[model.targetId] name];
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

- (void)requestConversation{
    [SVProgressHUD show];
    [NetworkModel requestWithUrl:@"Public/zixunlist" param:@{} complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD dismiss];
            for (NSDictionary *userInfo in dic[@"list"]) {
                RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userInfo[@"user_id"] name:userInfo[@"user_name"] portrait:[NSString stringWithFormat:@"%@%@",Image_Url,userInfo[@"face"]]];
                [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userInfo[@"user_id"]];
                [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:userInfo[@"user_id"] isTop:true];
                [_dataSource setObject:user forKey:userInfo[@"user_id"]];
            }
            [self refreshConversationTableViewIfNeeded];
            [self.conversationListTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}

@end
