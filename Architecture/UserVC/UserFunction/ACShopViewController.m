//
//  ACShopViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACShopViewController.h"

@interface ACShopViewController ()<UITextViewDelegate>{
    UITextView *textView;
    NSArray *titleArr;
}

@end

@implementation ACShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    titleArr = @[@{@"title":@"店铺名称",@"detail":@"",@"placeholder":@"请输入店铺名称",@"keyboardType":[NSNumber numberWithInteger:UIKeyboardTypeDefault]},
                 @{@"title":@"姓   名",@"detail":@"",@"placeholder":@"请输入姓名",@"keyboardType":[NSNumber numberWithInteger:UIKeyboardTypeDefault]},
                 @{@"title":@"联系电话",@"detail":@"",@"placeholder":@"请输入联系电话",@"keyboardType":[NSNumber numberWithInteger:UIKeyboardTypeNumberPad]},
                 @{@"title":@"主营范围",@"detail":@"",@"placeholder":@"",@"keyboardType":@""}];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"";
    if (indexPath.row < 3) {
        cellIdentify = @"normalCell";
    }else{
        cellIdentify = @"textCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    if (indexPath.row < 3) {
        [(UILabel *)[cell viewWithTag:1] setText:titleArr[indexPath.row][@"title"]];
        [(UITextField *)[cell viewWithTag:2] setText:titleArr[indexPath.row][@"detail"]];
        [(UITextField *)[cell viewWithTag:2] setPlaceholder:titleArr[indexPath.row][@"placeholder"]];
        [(UITextField *)[cell viewWithTag:2] setKeyboardType:[(NSNumber *)titleArr[indexPath.row][@"keyboardType"] integerValue]];
    }else{
        textView = [cell viewWithTag:2];
    }
    
    return cell;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
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
