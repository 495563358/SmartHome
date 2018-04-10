//
//  UICustomDatePicker.h
//  在定义日期地点键盘
//
//  Created by Yang on 2017/7/12.
//  Copyright © 2017年 Yang. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UICustomDatePicker : UIView
/*
 superView 视图需要显示到的superview
 date 选择后的日期
 cancel 取消选择的操作
 */
+ (void) showCustomDatePickerAtView:(UIView *)superView choosedDateBlock:(void (^)(NSDate *date))date cancelBlock:(void(^)())cancel;

@property(nonatomic, assign) BOOL isHidden;

@end
