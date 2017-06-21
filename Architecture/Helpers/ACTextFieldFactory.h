//
//  ACTextFieldFactory.h
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACTextFieldFactory : UITextField

@property (nonatomic, assign) IBInspectable UIImage *leftImg;
@property (nonatomic, assign) IBInspectable int left;
@property (nonatomic, assign) IBInspectable int right;

@end


@interface ACPhoneTextFiled : ACTextFieldFactory

@end

@interface ACPWDTextFiled : ACPhoneTextFiled

@property (nonatomic, assign) IBInspectable UIImage *rightImg;

@end
