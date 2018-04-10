//
//  ProductImageCell.m
//  IOTMALL
//
//  Created by Smart house on 2018/3/30.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "ProductImageCell.h"

@implementation ProductImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.mainImageView = [UIImageView new];
        [self.contentView addSubview:_mainImageView];
    }
    return self;
}

-(void)setMainImg:(UIImage *)mainImg{
    _mainImg = mainImg;
    _mainImageView.frame = CGRectMake(0, 0, Sc_w, _mainImg.size.height/2);
    _mainImageView.image = _mainImg;
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
