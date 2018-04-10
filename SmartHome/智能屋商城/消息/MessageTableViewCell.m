//
//  MessageTableViewCell.m
//  SmartHome
//
//  Created by Smart house on 2018/3/2.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addView];
    };
    return self;
}

-(void)addView{
    
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 50, 50)];
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 200, 25)];
    _titleL.font = [UIFont systemFontOfSize:14];
    
    self.subtitleL = [[UILabel alloc]initWithFrame:CGRectMake(75, 45, Sc_w - 85, 25)];
    _subtitleL.font = [UIFont systemFontOfSize:14];
    _subtitleL.textColor = [UIColor grayColor];
    
    self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, Sc_w - 105, 25)];
    _timeL.font = [UIFont systemFontOfSize:13];
    _timeL.textAlignment = NSTextAlignmentRight;
    _timeL.textColor = [UIColor grayColor];
    
    
    [self.contentView addSubview:_imageview];
    [self.contentView addSubview:_titleL];
    [self.contentView addSubview:_subtitleL];
    [self.contentView addSubview:_timeL];
    
}

@end
