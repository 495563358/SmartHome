//
//  WeekButton.h
//  封装敲一遍
//
//  Created by kensla on 15/3/31.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekButton : UIButton

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title;

@property (nonatomic, retain) NSString* buttonName;
@property (nonatomic, retain) NSString* fontColorName;
@property (nonatomic, retain) NSString* fonteColorPressName;

@end
