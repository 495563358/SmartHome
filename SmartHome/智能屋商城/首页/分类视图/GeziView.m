//
//  GeziView.m
//  UI进阶项目
//
//  Created by mac on 2016/12/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GeziView.h"

@implementation GeziView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatView];
    }return self;
}

-(void)creatView{
    CGFloat btnW = Sc_w/7;
    CGFloat maginY = btnW * 3 / 5 - Sc_w/37.5/2;
    
    CGFloat addMagin = maginY + btnW + Sc_w/37.5;
    
    NSArray *titleArray = @[@"系统主机",@"智能开关",@"智能门锁",@"电动窗帘",@"安防监控",@"家居建材",@"全部商品",@"我的分销"];
    NSArray *imageArray = @[@"znjj",@"znkg",@"znms",@"ddcl",@"spjk",@"jjjc",@"cbfl",@"wdfx"];
    
    for (int i = 0; i < 8 ; i++) {
        if (i<4) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(maginY + addMagin * i, 10, btnW, btnW)];
            btn.tag = i+101;
            [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            
            btn.titleLabel.font = [UIFont systemFontOfSize:0];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            
            
            
            UILabel *decLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w/5, 30)];
            decLabel.center = CGPointMake(btn.center.x-2, btn.center.y+btnW/5*4);
            decLabel.text = titleArray[i];
//            decLabel.font = [UIFont systemFontOfSize:14 weight:0.6];
            decLabel.font = [UIFont systemFontOfSize:15.0];
            decLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:decLabel];
        }else{
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(maginY + addMagin * (i-4), 10+btnW+40, btnW, btnW)];
            btn.tag = i+101;
            [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            
            btn.titleLabel.font = [UIFont systemFontOfSize:0];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            
            
            UILabel *decLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w/5, 30)];
            decLabel.center = CGPointMake(btn.center.x-2, btn.center.y+btnW/5*4);
            decLabel.text = titleArray[i];
//            decLabel.font = [UIFont systemFontOfSize:14 weight:0.6];
            decLabel.font = [UIFont systemFontOfSize:15.0];
            decLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:decLabel];
        }
        
    }
    
}

-(void) btnClick:(UIButton *)sender{
    
    
    NSLog(@"sender = %ld",sender.tag);
    
    NSLog(@"sender = %@",sender.currentTitle);
    if (sender.tag > 1000 || sender.tag == 0) {
        NSString *ID = [NSString stringWithFormat:@"%ld",sender.tag];
        NSString *path = [DetilPath stringByAppendingString:ID];
        NSLog(@"%@",path);
        self.BtnCLickBlock(path,sender.currentTitle);
        
        self.userInteractionEnabled = NO;
        
    }else if ([sender.currentTitle isEqualToString:@"我的分销"]){
        self.commssionBlock();
    }
    else
        NSLog(@"网络错误");
    
}

-(void)getId:(NSInteger)integerID{
}

@end
