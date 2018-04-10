//
//  NoticeView.m
//  SmartMall
//
//  Created by Smart house on 2017/8/16.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addView:frame];
    }
    return self;
}

-(void)addView:(CGRect)frame{
    self.backgroundColor = My_gray;
    
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_w/30, Sc_w, frame.size.height - Sc_w/30)];
    mainView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:mainView];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w/20, 10, Sc_w/8, Sc_w/10-20)];
    imageview.image = [UIImage imageNamed:@"gonggou"];
    [mainView addSubview:imageview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w/20 + Sc_w/6, 10, 2, Sc_w/10-20)];
    label.backgroundColor = My_gray;
    [mainView addSubview:label];
}

@end
