//
//  CollectCell.m
//  SmartMall
//
//  Created by Smart house on 2017/9/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "CollectCell.h"

@implementation CollectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addView];
    };
    return self;
}

-(void)addView{
    
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 87, 87)];
    _imageview.layer.borderWidth = 1;
    _imageview.layer.borderColor = My_gray.CGColor;
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(115, 23, Sc_w - 115 - 30, 25)];
    _titleL.font = [UIFont systemFontOfSize:14];
    
    self.subtitleL = [[UILabel alloc]initWithFrame:CGRectMake(115, 23 + 23, Sc_w - 115 - 30, 25)];
    _subtitleL.font = [UIFont systemFontOfSize:14];
    _subtitleL.textColor = color(14, 173, 254, 1.0);
    
    self.price = [[UILabel alloc]initWithFrame:CGRectMake(115, 74, 80, 25)];
    _price.font = [UIFont systemFontOfSize:15];
    _price.textColor = [UIColor redColor];
    
    
    self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 50 - 55, 74, 41, 21)];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    _shareBtn.backgroundColor = Color_system;
//    [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.layer.cornerRadius = 5.0;
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    self.deldBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 50, 74, 41, 21)];
    
    [_deldBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deldBtn.backgroundColor = Color_system;
//    [_deldBtn addTarget:self action:@selector(deleClick) forControlEvents:UIControlEventTouchUpInside];
    _deldBtn.layer.cornerRadius = 5.0;
    _deldBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:_imageview];
    [self.contentView addSubview:_titleL];
    [self.contentView addSubview:_subtitleL];
    [self.contentView addSubview:_price];
    [self.contentView addSubview:_shareBtn];
    [self.contentView addSubview:_deldBtn];
    
}




@end
