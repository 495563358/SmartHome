//
//  OrderSureCell.m
//  SmartMall
//
//  Created by Smart house on 2017/9/14.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "OrderSureCell.h"

@implementation OrderSureCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createview];
    }
    return self;
}

-(void)createview{
    
    //    商品图片
    _shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 70, 70)];
    
    _shoppingImgView.layer.borderWidth = 1;
    _shoppingImgView.layer.borderColor = My_gray.CGColor;
    
    [self.contentView addSubview:_shoppingImgView];
    
    //    商品标题
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingImgView.frame)+10, 10, Sc_w -CGRectGetMaxX(_shoppingImgView.frame)-15, 21)];
    _title.font=[UIFont systemFontOfSize:14];
    _title.textColor=[UIColor blackColor];
    [self.contentView addSubview:_title];
    
    //    规格
    _typeName = [[UILabel alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_title.frame) + 10, 60, 20)];
    _typeName.font=[UIFont systemFontOfSize:12];
    _typeName.textColor=[UIColor blackColor];
    [self.contentView addSubview:_typeName];
    
    _colortype = [[UIButton alloc]initWithFrame:CGRectMake(_title.frame.origin.x + 60, CGRectGetMaxY(_title.frame) + 10, 70, 20)];
    _colortype.layer.cornerRadius = 3.0;
    _colortype.titleLabel.font = [UIFont systemFontOfSize:12];
    _colortype.backgroundColor = Color_system;
    [self.contentView addSubview:_colortype];
    
    _price = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_typeName.frame)+12, 100, 17)];
    _price.hidden =NO;
    _price.font =  [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_price];
    
    
    _countLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 60, 60, 40, 20)];
    _countLab.font = [UIFont systemFontOfSize:15];
    _countLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_countLab];
    
        
}

@end
