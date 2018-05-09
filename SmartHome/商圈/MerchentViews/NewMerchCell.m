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
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(12 * temp, 14,66 , 66)];//70 * temp
//    _headImage.layer.borderColor = My_gray.CGColor;
//    _headImage.layer.borderWidth = 1;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(66 + 12 + 10, 10, Sc_w - 100, 20)];//94 * temp
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    //主营项目
    _alongTime = [[UILabel alloc]initWithFrame:CGRectMake(66 + 12 + 10, 37, ScreenW - 94 * temp, 20)];
    _alongTime.font = [UIFont systemFontOfSize:14];
    _alongTime.textColor = [UIColor grayColor];
    
    //产品方案 体验方式
    _mainworkLabel = [[UILabel alloc]initWithFrame:CGRectMake(66 + 12 + 10, 64, 110 * temp, 20)];
    _mainworkLabel.font = [UIFont systemFontOfSize:14];
    _mainworkLabel.textColor = [UIColor grayColor];
    
    _attendWays = [[UILabel alloc]initWithFrame:CGRectMake(66 + 12 + 10+(110) * temp, 64, 125, 20)];
    _attendWays.font = [UIFont systemFontOfSize:14];
    _attendWays.textColor = [UIColor grayColor];
    
    
    
    _shopArea = [[UILabel alloc]initWithFrame:CGRectMake(66 + 12 + 10+105 * temp, 64, 105, 20)];
    _shopArea.font = [UIFont systemFontOfSize:14];
    _shopArea.textColor = [UIColor grayColor];
    
    _distance = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 80, 64, 70, 20)];
    _distance.font = [UIFont systemFontOfSize:12];
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
    
    
    NSString *title = dict[@"merchname"];
    if ([dict[@"istop"] intValue]) {
        if (ScreenW > 400) {
            if (title.length > 10) {
                title = [title substringToIndex:10];
            }
        }
        
        else if (ScreenW > 350) {
            if (title.length > 8) {
                title = [title substringToIndex:8];
            }
        }
        else{
            if (title.length > 6) {
                title = [title substringToIndex:6];
            }
        }
    }
    
    
//    NSString *newTitle = title;
//    if ([title containsString:@"深圳市"]) {
//        newTitle = [title stringByReplacingOccurrencesOfString:@"深圳市" withString:@""];
//    }
//    NSString *finTitle = newTitle;
//    if ([title containsString:@"有限公司"]) {
//        finTitle = [newTitle stringByReplacingOccurrencesOfString:@"有限公司" withString:@""];
//    }
    
    self.titleLabel.text = title;
    if (dict[@"total"]) {
        self.mainworkLabel.text = [NSString stringWithFormat:@"产品方案:%@个",dict[@"total"]];
    }else{
        self.mainworkLabel.text = @"暂无产品方案";
    }
    self.attendWays.text = [NSString stringWithFormat:@"%@",dict[@"tastename"]];//体验方式:
    self.alongTime.text = dict[@"salecate"];
    self.distance.text = [NSString stringWithFormat:@"%.2fkm",[dict[@"distance"] floatValue]];
    
    CGFloat titleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)  options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    
    CGFloat cellX = _titleLabel.dc_x + titleW + 6;
    if ([dict[@"istop"] intValue] == 1) {
        UIImageView *top = [[UIImageView alloc]initWithFrame:CGRectMake(cellX, 12, 45, 15)];
        top.image = [UIImage imageNamed:@"sq_renzheng"];
        cellX += 50;
        [self.contentView addSubview:top];
    }
    
    if ([dict[@"levelname"] isEqualToString:@"加盟"] || [dict[@"levelname"] isEqualToString:@"代理"]) {
        UILabel *level = [[UILabel alloc]initWithFrame:CGRectMake(cellX, 12, 49, 15)];
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
        UILabel *recommand = [[UILabel alloc] initWithFrame:CGRectMake(cellX, 12, 26, 15)];
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
