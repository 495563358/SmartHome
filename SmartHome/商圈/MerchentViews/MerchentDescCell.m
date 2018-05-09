//
//  MerchentDescCell.m
//  SmartHome
//
//  Created by Smart house on 2018/4/28.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchentDescCell.h"

#import "DCSpeedy.h"

@implementation MerchentDescCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDesc:(NSString *)desc andShow:(BOOL)showAll{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView:desc andShow:showAll];
    }
    return self;
}


-(void)createView:(NSString *)desc andShow:(BOOL)showAll{
    
    _descHeight = [DCSpeedy dc_calculateTextSizeWithText:desc WithTextFont:13 WithMaxW:ScreenW - 35].height;
    
    int line = _descHeight/18 - 1 ;
    
    if (line == -1) {
        line = 0;
    }
    CGFloat extalH = line * 6;
    
    NSLog(@"cell 高度 = %f,行数 = %i",_descHeight,line);
    
    if (_descHeight > 58.8) {
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, Sc_w - 30, 58.8 + extalH)];
    }else
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, Sc_w - 30, _descHeight + extalH)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:13];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [desc length])];
    _contentLabel.attributedText = attributedString;
    [_contentLabel sizeToFit];
    
    
    
//    _contentLabel.text = desc;
    
    [self.contentView addSubview:self.contentLabel];
    
    if (_descHeight <= 58.8) {
        return;
    }
    
    _showAll = [[UIButton alloc]initWithFrame:CGRectMake(15, 58.8 + 10, Sc_w - 30, 30)];
    [_showAll setImage:[UIImage imageNamed:@"down_black"] forState:UIControlStateNormal];
    [_showAll setImage:[UIImage imageNamed:@"up_black"] forState:UIControlStateSelected];
    [_showAll addTarget:self action:@selector(showClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showAll];
    
    if (showAll) {
        _showAll.selected = YES;
        _contentLabel.frame = CGRectMake(15, 10, Sc_w - 30, _descHeight + extalH);
        _showAll.frame = CGRectMake(15, 10 + _descHeight, Sc_w - 30, 30);
    }else
    {
        _showAll.selected = NO;
        _contentLabel.frame = CGRectMake(15, 10, Sc_w - 30, 58.8);
        _showAll.frame = CGRectMake(15, 58.8 + 10, Sc_w - 30, 30);
    }
}

-(void)showClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        int line = _descHeight/18 - 1 ;
        
        if (line == -1) {
            line = 0;
        }
        CGFloat extalH = line * 6;
        
        _contentLabel.frame = CGRectMake(15, 10, Sc_w - 30, _descHeight + extalH);
        _showAll.frame = CGRectMake(15, 5 + _descHeight + extalH, Sc_w - 30, 30);
    }else{
        _contentLabel.frame = CGRectMake(15, 10, Sc_w - 30, 58.8);
        _showAll.frame = CGRectMake(15, 58.8 + 10, Sc_w - 30, 30);
    }
    [self.contentView reloadInputViews];
    self.changeCellHeight(_showAll.isSelected);
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
