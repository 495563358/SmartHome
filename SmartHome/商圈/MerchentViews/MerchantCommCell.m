//
//  MerchantCommCell.m
//  SmartHome
//
//  Created by Smart house on 2018/4/28.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchantCommCell.h"

@implementation MerchantCommCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }return self;
}

//总高度 50
-(void)createView{
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 50)];
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.text = @"商户评价";
    
    _totalLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 225, 0, 200, 50)];
    _totalLab.font = [UIFont systemFontOfSize:15];
    _totalLab.textColor = [UIColor grayColor];
    _totalLab.textAlignment = NSTextAlignmentRight;
    _totalLab.text = @"共50个";
    
    UIImageView *nextImgtip = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20, 18, 7, 13)];
    nextImgtip.image = [UIImage imageNamed:@"gengduo"];
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_totalLab];
    [self.contentView addSubview:nextImgtip];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
