//
//  DiscountCell.m
//  SmartMall
//
//  Created by Smart house on 2017/9/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "DiscountCell.h"

@implementation DiscountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = color(245, 245, 245, 1.0);
        
        
        [self addView];
    };
    return self;
}

-(void)addView{
    
    self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, Sc_w - 10, 89)];
    _backView.image = [UIImage imageNamed:@"yhqBackY"];
    _backView.userInteractionEnabled = YES;
    [self.contentView addSubview:_backView];
    
    CGFloat percent = Sc_w/375;
    
    UILabel *mLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * percent, 32+11, 20, 15)];
    mLab.textColor = [UIColor whiteColor];
    mLab.font = [UIFont systemFontOfSize:15];
    mLab.text = @"￥";
    [_backView addSubview:mLab];
    
    self.priceBigger = [[UILabel alloc]initWithFrame:CGRectMake(30 * percent, 32, 100, 30)];
    _priceBigger.textColor = [UIColor whiteColor];
    _priceBigger.font = [UIFont systemFontOfSize:30];
    _priceBigger.text = @"10.0";
    [_backView addSubview:_priceBigger];
    
    self.moneyTitle = [[UILabel alloc]initWithFrame:CGRectMake(145 * percent, 23, 120, 16)];
    _moneyTitle.font = [UIFont systemFontOfSize:15];
    _moneyTitle.text = @"10元商品优惠券";
    [_backView addSubview:_moneyTitle];
    
    self.deadLine = [[UILabel alloc]initWithFrame:CGRectMake(145 * percent, 23 + 34, 220, 20)];
    _deadLine.font = [UIFont systemFontOfSize:12];
    _deadLine.text = @"有效期：2017.8.8-2017.8.9";
    _deadLine.textColor = [UIColor grayColor];
    [_backView addSubview:_deadLine];
    
    self.staleImg = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 88, 13, 61, 62)];
    _staleImg.image = [UIImage imageNamed:@"yishiyong"];
    [_backView addSubview:_staleImg];
    
    self.getBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 100 * percent, 16, 70 * percent, 30)];
    [_getBtn setTitle:@"领取" forState:UIControlStateNormal];
    _getBtn.layer.cornerRadius = 5.0;
    _getBtn.backgroundColor = Color_system;
    _getBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _getBtn.hidden = YES;
    
    [_getBtn addTarget:self action:@selector(getClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_getBtn];
    
    
}

-(void)getClick:(UIButton *)sender{
    self.getBlock(sender);
}

@end
