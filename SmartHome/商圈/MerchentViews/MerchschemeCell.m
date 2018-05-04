//
//  MerchschemeCell.m
//  SmartHome
//
//  Created by Smart house on 2018/5/3.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchschemeCell.h"

@implementation MerchschemeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }return self;
}

//总高度 50 + 152 * Percentage + 10
-(void)createView{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, ScreenW - 30, 152 * Percentage)];
    imgView.image = [UIImage imageNamed:@"家头部图片"];
    [self.contentView addSubview:imgView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20 + imgView.mj_h, ScreenW - 30, 30)];
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.text = @"智能屋体验版套装";
    
    _subLab = [[UILabel alloc]initWithFrame:CGRectMake(15,_titleLab.mj_y + 30, ScreenW - 30, 30)];
    _subLab.font = [UIFont systemFontOfSize:13];
    _subLab.textColor = [UIColor grayColor];
    _subLab.text = @"8.00万/90平方/现代全屋智能装修";
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_subLab];
}

+(CGFloat)getCellHeight{
    return 10 + 152 * Percentage + 10 + 70;
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
