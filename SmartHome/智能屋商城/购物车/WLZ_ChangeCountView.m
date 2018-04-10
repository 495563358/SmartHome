//
//  WLZ_ChangeCountView.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ChangeCountView.h"

@implementation WLZ_ChangeCountView


- (instancetype)initWithFrame:(CGRect)frame chooseCount:(NSInteger)chooseCount totalCount:(NSInteger)totalCount
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.totalCount = totalCount;
        self.choosedCount = chooseCount;
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews
{
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, 30,25);
    
    
//    [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_normal"] forState:UIControlStateNormal];
    [_subButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_subButton setTitle:@"-" forState:UIControlStateNormal];
    _subButton.layer.borderWidth = 1;
    _subButton.layer.borderColor = My_gray.CGColor;
    _subButton.layer.cornerRadius = 2.0;
    
    
    
    
//    [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"] forState:UIControlStateDisabled];
    
    _subButton.exclusiveTouch = YES;
    [self addSubview:_subButton];
    if (self.choosedCount <= 1) {
        _subButton.enabled = NO;
    }else{
        _subButton.enabled = YES;
    }
    _numberFD = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_subButton.frame), 0, 40, _subButton.frame.size.height)];
    
    
    _subButton.backgroundColor=[UIColor clearColor];
    _numberFD.textAlignment=NSTextAlignmentCenter;
//    _numberFD.keyboardType=UIKeyboardTypeNumberPad;
    _numberFD.clipsToBounds = YES;
    _numberFD.layer.borderColor = My_gray.CGColor;
    _numberFD.layer.borderWidth = 1;
    _numberFD.textColor = color(51, 51, 51, 1);
    
    _numberFD.font=[UIFont systemFontOfSize:13];
    _numberFD.backgroundColor = [UIColor whiteColor];
    _numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    
    [self addSubview:_numberFD];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(CGRectGetMaxX(_numberFD.frame), 0, 30,25);
    _addButton.backgroundColor=[UIColor clearColor];
    
//    [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_normal"] forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addButton setTitle:@"+" forState:UIControlStateNormal];
    
    _addButton.layer.borderWidth = 1;
    _addButton.layer.borderColor = My_gray.CGColor;
    _addButton.layer.cornerRadius = 2.0;
    
    
//    [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"] forState:UIControlStateDisabled];
    
    _addButton.exclusiveTouch = YES;
    [self addSubview:_addButton];
    if (self.choosedCount >= self.totalCount) {
        _addButton.enabled = NO;
    }else{
        _addButton.enabled = YES;
    }
}

@end
