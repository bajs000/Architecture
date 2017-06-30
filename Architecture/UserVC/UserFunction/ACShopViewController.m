//
//  ACShopViewController.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACShopViewController.h"
#import "Helpers.h"

@interface ACShopViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UITextView *textView;
    NSMutableArray *titleArr;
    UIImage *logo;
}

@end

@implementation ACShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    titleArr = [NSMutableArray arrayWithArray:@[@{@"title":@"店铺名称",@"detail":@"",@"placeholder":@"请输入店铺名称",@"keyboardType":[NSNumber numberWithInteger:UIKeyboardTypeDefault]},
                                                @{@"title":@"姓   名",@"detail":@"",@"placeholder":@"请输入姓名",@"keyboardType":[NSNumber numberWithInteger:UIKeyboardTypeDefault]},
                                                @{@"title":@"联系电话",@"detail":@"",@"placeholder":@"请输入联系电话",@"keyboardType":[NSNumber numberWithInteger:UIKeyboardTypeNumberPad]}/*,@{@"title":@"主营范围",@"detail":@"",@"placeholder":@"",@"keyboardType":@""},@{@"title":@"店铺logo",@"detail":@"",@"placeholder":@"",@"keyboardType":@""}*/]];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"";
    if (indexPath.row < 3) {
        cellIdentify = @"normalCell";
    }else if (indexPath.row == 4){
        cellIdentify = @"logoCell";
    } else{
        cellIdentify = @"textCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    if (indexPath.row < 3) {
        [(UILabel *)[cell viewWithTag:1] setText:titleArr[indexPath.row][@"title"]];
        [(UITextField *)[cell viewWithTag:2] setText:titleArr[indexPath.row][@"detail"]];
        [(UITextField *)[cell viewWithTag:2] setPlaceholder:titleArr[indexPath.row][@"placeholder"]];
        [(UITextField *)[cell viewWithTag:2] setKeyboardType:[(NSNumber *)titleArr[indexPath.row][@"keyboardType"] integerValue]];
        [(UITextField *)[cell viewWithTag:2] addTarget:self action:@selector(textFieldEditingDidChange:) forControlEvents:UIControlEventEditingChanged];
    }else if (indexPath.row == 4){
        [cell viewWithTag:2].layer.borderWidth = 1;
        [cell viewWithTag:2].layer.borderColor = UIColorFromHex(0xCDCDCD).CGColor;
        [(UIImageView *)[cell viewWithTag:3] setImage:logo];
    }else{
        textView = [cell viewWithTag:2];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:true completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.delegate = self;
            [self presentViewController:picker animated:true completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

#pragma mark - UIImagePickerViewDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.navigationItem setHidesBackButton:true];
    logo = info[UIImagePickerControllerOriginalImage];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:true completion:nil];
    
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

#pragma mark- UIButton Action
- (void)textFieldEditingDidChange:(UITextField *)sender{
    UITableViewCell *cell = (UITableViewCell *)[Helpers findSuperViewClass:[UITableViewCell class] view:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:titleArr[indexPath.row]];
    [tempDic setObject:sender.text forKey:@"detail"];
    [titleArr removeObjectAtIndex:indexPath.row];
    [titleArr insertObject:tempDic atIndex:indexPath.row];
}

- (IBAction)makeShopBtnDidClick:(id)sender {
    for (NSDictionary *dic in titleArr) {
        if ([(NSString *)dic[@"detail"] length] == 0) {
            [SVProgressHUD showErrorWithStatus:dic[@"placeholder"]];
            return;
        }
    }
    if (textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入主营范围"];
        return;
    }
    if (logo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择店铺logo"];
        return;
    }
    [SVProgressHUD show];
    [UploadNetworkModel uploadWithUrl:@"User/kaidian" param:@{@"user_id":[UserModel shareInstance].userId,@"bus_title":titleArr[0][@"detail"],@"bus_username":titleArr[1][@"detail"],@"bus_phone":titleArr[2][@"detail"],@"bus_type":textView.text} data:logo dataName:@"bus_logo" complete:^(NSDictionary *dic) {
        if ([dic[@"code"] intValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"申请成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:true];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}


@end
