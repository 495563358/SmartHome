//
//  MerchentIdeaCell.m
//  SmartHome
//
//  Created by Smart house on 2018/4/28.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchentIdeaCell.h"

@implementation MerchentIdeaCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }return self;
}

//总高度 50 + 152 * Percentage + 10
-(void)createView{
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 50)];
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.text = @"设计方案";
    
    _totalLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 225, 0, 200, 50)];
    _totalLab.font = [UIFont systemFontOfSize:15];
    _totalLab.textColor = [UIColor grayColor];
    _totalLab.textAlignment = NSTextAlignmentRight;
    _totalLab.text = @"全部0个";
    
    UIImageView *nextImgtip = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20, 18, 7, 13)];
    nextImgtip.image = [UIImage imageNamed:@"gengduo"];
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_totalLab];
    [self.contentView addSubview:nextImgtip];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 50, ScreenW - 30, 152 * Percentage)];
    imgView.image = [UIImage imageNamed:@"gs_dp_banner"];
    [self.contentView addSubview:imgView];
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
