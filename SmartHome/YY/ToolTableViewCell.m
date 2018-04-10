//
//  ToolTableViewCell.m
//  SmartHome
//
//  Created by Smart house on 2018/3/29.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "ToolTableViewCell.h"

@implementation ToolTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _content = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w - 72, 55)];
        _content.textColor = [UIColor whiteColor];
        _content.font = [UIFont systemFontOfSize:20];
        _content.textAlignment = NSTextAlignmentRight;
        _content.numberOfLines = 0;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_content];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
