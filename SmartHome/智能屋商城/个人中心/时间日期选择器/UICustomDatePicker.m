//
//  UICustomDatePicker.m
//  在定义日期地点键盘
//
//  Created by Yang on 2017/7/12.
//  Copyright © 2017年 Yang. All rights reserved.
//
#import "UICustomDatePicker.h"


@interface UICustomDatePicker()

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (nonatomic, copy  ) void(^dateBlock)(NSDate *date);
@property (nonatomic, copy  ) void(^cancelBlock)();

//顶部视图
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIButton *btnCancel;
@property (nonatomic, strong)UIButton *btnOK;

//背景视图
@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation UICustomDatePicker


- (instancetype)init
{
    if (self = [super init]) {
        //背景框

        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _backgroundView.layer.masksToBounds = YES;
        
        self.frame = CGRectMake(0, _backgroundView.frame.size.height, _backgroundView.frame.size.width, 302);
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_backgroundView addSubview:self];
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, 44)];
        [self addSubview:_topView];
        _topView.backgroundColor = [UIColor whiteColor];
        
        UILabel * placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 11, 100, 21)];
        placeLabel.text = @"请选择日期";
        [_topView addSubview:placeLabel];
        
        _btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, _topView.frame.size.height)];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(dismissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_btnCancel];
        
        _btnOK = [[UIButton alloc]initWithFrame:CGRectMake(_topView.frame.size.width - 60, 0, 60, _topView.frame.size.height)];
        [_btnOK setTitle:@"确定" forState:UIControlStateNormal];
        [_btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnOK addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_btnOK];
        
        
        //日期选择器
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_topView.frame) + 1,self.frame.size.width,self.frame.size.height - (CGRectGetMaxY(_topView.frame) + 1))];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        
        
        NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
        [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
        NSDate *minDate = [formatter_minDate dateFromString:@"1900-01-01"];
        NSDate *maxDate = [NSDate date];
        
        formatter_minDate = nil;
        [_datePicker setMinimumDate:minDate];
        [_datePicker setMaximumDate:maxDate];
        [self addSubview:_datePicker];
        
    }
    
    return self;
}


+ (void)showCustomDatePickerAtView:(UIView *)superView choosedDateBlock:(void (^)(NSDate *date))date cancelBlock:(void(^)())cancel
{
    if ([superView viewWithTag:718]) {//移除子空间
        [[superView viewWithTag:718] removeFromSuperview];
    }
    UICustomDatePicker *picker = [[UICustomDatePicker alloc]init];
    picker.tag = 718;
    [superView addSubview:picker];
    picker.translatesAutoresizingMaskIntoConstraints = NO;//给pickerView布局  相对父控件
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:picker attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:Sc_h - 302 - 40]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:picker attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:picker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:picker attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    if (date) {
        picker.dateBlock = date;
    }
    if (cancel) {
        picker.cancelBlock = cancel;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //初始化的工作可以在这里完成
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)dismissBtnAction:(id)sender {//点击取消按钮
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}
- (void)confirmBtnAction:(id)sender {//点击确认按钮
    if (self.dateBlock) {
        self.dateBlock(self.datePicker.date);
    }
    [self removeFromSuperview];
}

@end
