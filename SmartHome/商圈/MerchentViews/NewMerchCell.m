//
//  NewMerchCell.m
//  SmartHome
//
//  Created by Smart house on 2018/5/4.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "NewMerchCell.h"

@implementation NewMerchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andInfo:(NSDictionary *)info{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addsubview:info];
    }
    return self;
}

-(void)addsubview:(NSDictionary *)dict{
    
    CGFloat temp = Percentage;
    if (temp >= 1) {
        temp = 1;
    }
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(12 * temp, 19, 70 * temp, 56)];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(94 * temp, 16, Sc_w - 100, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _mainworkLabel = [[UILabel alloc]initWithFrame:CGRectMake(94 * temp, 40, 105, 20)];
    _mainworkLabel.font = [UIFont systemFontOfSize:14];
    _mainworkLabel.textColor = [UIColor grayColor];
    
    _attendWays = [[UILabel alloc]initWithFrame:CGRectMake(94+105 * temp, 40, 125, 20)];
    _attendWays.font = [UIFont systemFontOfSize:14];
    _attendWays.textColor = [UIColor grayColor];
    
    _alongTime = [[UILabel alloc]initWithFrame:CGRectMake(94 * temp, 60, ScreenW - 94 * temp - 80, 20)];
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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"logo"]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headImage.image = image;
        });
    });
    self.titleLabel.text = dict[@"merchname"];
    self.mainworkLabel.text = [NSString stringWithFormat:@"产品方案:%@个",dict[@"total"]];
    self.attendWays.text = [NSString stringWithFormat:@"体验方式:%@",dict[@"tastename"]];
    self.alongTime.text = dict[@"salecate"];
//    self.shopArea.text = [NSString stringWithFormat:@"区域:%@",dict[@"city"]];
    self.distance.text = [NSString stringWithFormat:@"%.2fkm",[dict[@"distance"] floatValue]];
    
    
    NSString *title = dict[@"merchname"];
    CGFloat titleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)  options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    
    CGFloat cellX = _titleLabel.dc_x + titleW + 10;
    if ([dict[@"istop"] intValue] == 1) {
        UIImageView *top = [[UIImageView alloc]initWithFrame:CGRectMake(cellX, 19, 45, 15)];
        top.image = [UIImage imageNamed:@"sq_renzheng"];
        cellX += 50;
        [self.contentView addSubview:top];
    }
    
    if ([dict[@"levelname"] isEqualToString:@"加盟"] || [dict[@"levelname"] isEqualToString:@"代理"]) {
        UILabel *level = [[UILabel alloc]initWithFrame:CGRectMake(cellX, 19, 49, 15)];
        level.layer.cornerRadius = 2;
        level.layer.masksToBounds = YES;
        level.layer.borderWidth = 1;
        level.layer.borderColor = [UIColor colorWithRed:254.0/255.0 green:166.0/255.0 blue:14.0/255.0 alpha:1.0].CGColor;
        level.textColor = [UIColor colorWithRed:254.0/255.0 green:166.0/255.0 blue:14.0/255.0 alpha:1.0];
        level.font = [UIFont systemFontOfSize:11];
        level.textAlignment = NSTextAlignmentCenter;
        level.text = [NSString stringWithFormat:@"%@%@年",dict[@"levelname"],dict[@"year"]];
        
        cellX += 55;
        [self.contentView addSubview:level];
    }
    
    if ([dict[@"isrecommand"] intValue]) {
        UILabel *recommand = [[UILabel alloc] initWithFrame:CGRectMake(cellX, 19, 30, 15)];
        recommand.font = [UIFont systemFontOfSize:11];
        recommand.text = @"推荐";
        recommand.layer.cornerRadius = 2;
        recommand.layer.masksToBounds = YES;
        recommand.layer.borderWidth = 1;
        recommand.layer.borderColor = [UIColor colorWithRed:253.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor;
        recommand.textColor = [UIColor colorWithRed:253.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
        recommand.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:recommand];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
