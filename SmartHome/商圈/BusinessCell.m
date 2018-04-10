//
//  BusinessCell.m
//  SmartMall
//
//  Created by Smart house on 2017/11/1.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "BusinessCell.h"

@implementation BusinessCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addsubview];
    }
    return self;
}

-(void)addsubview{
    
    CGFloat temp = Percentage;
    if (temp >= 1) {
        temp = 1;
    }
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(12 * temp, 19, 70 * temp, 56)];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(94 * temp, 19, Sc_w - 100, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _mainworkLabel = [[UILabel alloc]initWithFrame:CGRectMake(94 * temp, 40, 105, 20)];
    _mainworkLabel.font = [UIFont systemFontOfSize:14];
    _mainworkLabel.textColor = [UIColor grayColor];
    
    _attendWays = [[UILabel alloc]initWithFrame:CGRectMake(94+105 * temp, 40, 125, 20)];
    _attendWays.font = [UIFont systemFontOfSize:14];
    _attendWays.textColor = [UIColor grayColor];
    
    _alongTime = [[UILabel alloc]initWithFrame:CGRectMake(94 * temp, 60, 105, 20)];
    _alongTime.font = [UIFont systemFontOfSize:14];
    _alongTime.textColor = [UIColor grayColor];
    
    _shopArea = [[UILabel alloc]initWithFrame:CGRectMake(94+105 * temp, 60, 105, 20)];
    _shopArea.font = [UIFont systemFontOfSize:14];
    _shopArea.textColor = [UIColor grayColor];
    
    _distance = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 80, 60, 70, 20)];
    _distance.font = [UIFont systemFontOfSize:14];
    _distance.textAlignment = NSTextAlignmentRight;
    _distance.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_headImage];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_mainworkLabel];
    [self.contentView addSubview:_attendWays];
    [self.contentView addSubview:_alongTime];
    [self.contentView addSubview:_shopArea];
    [self.contentView addSubview:_distance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
