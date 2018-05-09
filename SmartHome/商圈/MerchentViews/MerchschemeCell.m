//
//  MerchschemeCell.m
//  SmartHome
//
//  Created by Smart house on 2018/5/3.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchschemeCell.h"
#import "UIImageView+WebCache.h"

@implementation MerchschemeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }return self;
}

//总高度 50 + 152 * Percentage + 10
-(void)createView{
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, ScreenW - 30, 152 * Percentage)];
    _imgView.image = [UIImage imageNamed:@"gs_dp_banner"];
    [self.contentView addSubview:_imgView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20 + _imgView.mj_h, ScreenW - 30, 30)];
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.text = @"智能屋体验版套装";
    
    _subLab = [[UILabel alloc]initWithFrame:CGRectMake(15,_titleLab.mj_y + 30, ScreenW - 30, 30)];
    _subLab.font = [UIFont systemFontOfSize:13];
    _subLab.textColor = [UIColor grayColor];
    _subLab.text = @"8.00万/90平方/现代全屋智能装修";
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_subLab];
    
    UILabel *catLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 225, _titleLab.mj_y , 200, 30)];
    catLab.font = [UIFont systemFontOfSize:14];
    catLab.textColor = [UIColor grayColor];
    catLab.textAlignment = NSTextAlignmentRight;
    catLab.text = @"查看全文";
    
    UIImageView *nextImgtip = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20, 8 + _titleLab.mj_y , 7, 13)];
    nextImgtip.image = [UIImage imageNamed:@"gengduo"];
    [self.contentView addSubview:catLab];
    [self.contentView addSubview:nextImgtip];
}

-(void)configcell:(NSDictionary *)info{
    if ([info isKindOfClass:NSDictionary.class]) {
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[AddressPath stringByAppendingString:info[@"resp_img"]]] placeholderImage:[UIImage imageNamed:@"gs_dp_banner"]];
        _titleLab.text = info[@"article_title"];
        _subLab.text = info[@"resp_desc"];
    }
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
