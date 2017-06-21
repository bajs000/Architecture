//
//  ACTextFieldFactory.m
//  Architecture
//
//  Created by YunTu on 2017/6/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

#import "ACTextFieldFactory.h"

@interface ACTextFieldFactory()

@end

@implementation ACTextFieldFactory

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (CGRect)borderRectForBounds:(CGRect)bounds{
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, _left, 0, _right));
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, _left, 0, _right));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, _left, 0, _right));
}

@end

@implementation ACPhoneTextFiled

- (void)awakeFromNib{
    [super awakeFromNib];
    if (self.leftImg) {
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:self.leftImg];
        self.leftView = leftImageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        if (self.left == 0) {
            self.left = self.leftImg.size.width;
        }
    }
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.bounds.size.height - 1);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
    CGContextStrokePath(context);
}

@end

@implementation ACPWDTextFiled

- (void)awakeFromNib{
    [super awakeFromNib];
    if (self.rightImg && self.right == 0) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
        [rightBtn setImage:self.rightImg forState:UIControlStateNormal];
        self.rightView = rightBtn;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.right = self.bounds.size.height;
        [rightBtn addTarget:self action:@selector(eyeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)eyeBtnDidClick:(id)sender{
    self.secureTextEntry = !self.secureTextEntry;
}

@end
