//
//  CameraTableViewCell.m
//  SmartHome
//
//  Created by Smart house on 2018/1/8.
//  Copyright © 2018年 sunzl. All rights reserved.
//

#import "CameraTableViewCell.h"

@implementation CameraTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    self.statusLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 150, 0, 110, 100)];
    self.statusLab.font = [UIFont systemFontOfSize:15];
    _statusLab.textAlignment = NSTextAlignmentRight;
    
    self.warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    _warnBtn.center = _statusLab.center;
    _warnBtn.hidden = YES;
    [_warnBtn setImage:[UIImage imageNamed:@"cameraWarn"] forState:UIControlStateNormal];
    [_warnBtn addTarget:self action:@selector(warnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_statusLab];
    [self.contentView addSubview:_warnBtn];
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 120, 90)];
    [self.contentView addSubview:self.imageV];
    
    _titleL = [[UILabel alloc]initWithFrame:CGRectMake(140, 20, 250, 25)];
    _titleL.font = [UIFont systemFontOfSize:15];
    
    _textL = [[UILabel alloc]initWithFrame:CGRectMake(140, 60, 250, 25)];
    _textL.font = [UIFont systemFontOfSize:13];
    _textL.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_titleL];
    [self.contentView addSubview:_textL];
    
    _cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 140, 100)];
    [self.contentView addSubview:_cameraBtn];
}

-(void)warnBtnClick{
    ShowMsg(@"您的密码为初始密码，为了您的安全，请尽快修改密码");
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
