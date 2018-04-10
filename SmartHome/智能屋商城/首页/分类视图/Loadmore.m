//
//  Loadmore.m
//  UI进阶项目
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "Loadmore.h"

@implementation Loadmore

static Loadmore *shareviews;

+ (instancetype)sharedSingleton{
    
    shareviews = [[Loadmore alloc]initWithFrame:CGRectMake(0, 44, Sc_w, 120)];
    return shareviews;
}

+(instancetype)shareSelf{
    if (!shareviews) {
        shareviews = [[Loadmore alloc]init];
    }
    return shareviews;
}

-(instancetype)initWithFrame:(CGRect)frame{
    NSArray *nameArr = @[@"推荐商品",@"新品上市",@"热卖商品",@"促销商品",@"卖家包邮",@"限时抢购"];
    if (self = [super initWithFrame:frame]) {
        CGFloat magin = (Sc_w * 0.1 - 20) * 0.5;
        for (int i = 0; i<6; i++) {
            
            CGFloat btnW = Sc_w * 0.3;
            CGFloat btnH = 30;
            
            CGFloat btnX = 10 + i * (btnW + magin);
            CGFloat btnY = 10;
            if (i>2) {
                btnX = 10 + (i-3) * (btnW + magin);
                btnY = 10 + btnH + 10;
            }
            
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX,btnY,btnW,btnH)];
            btn.layer.cornerRadius = 5.0;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor grayColor].CGColor;
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            NSString *name = nameArr[i];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitle:name forState:UIControlStateNormal];
            btn.tag = i + 2000;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}


-(void)btnClick:(UIButton *)sender{
    self.btnBlock(sender);
    if ([self.delegate respondsToSelector:@selector(moreViewPushVCWithTag:)]) {
        [self.delegate moreViewPushVCWithTag:sender.tag];
    }
    NSLog(@"进入了Loadmore");
}

@end
