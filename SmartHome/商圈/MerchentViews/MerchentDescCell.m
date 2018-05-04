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

-(instancetype)initWithDesc:(NSString *)desc{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"descCell"]) {
        [self createView:desc];
    }
    return self;
}

-(void)createView:(NSString *)desc{
    
    CGFloat descHeight = [DCSpeedy dc_calculateTextSizeWithText:desc WithTextFont:13 WithMaxW:ScreenW - 35].height;
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, Sc_w - 30, descHeight)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.text = desc;
    
    [self.contentView addSubview:self.contentLabel];
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
