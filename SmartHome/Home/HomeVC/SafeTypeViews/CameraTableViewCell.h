//
//  CameraTableViewCell.h
//  SmartHome
//
//  Created by Smart house on 2018/1/8.
//  Copyright © 2018年 sunzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *statusLab;

@property(nonatomic,strong)UIImageView *imageV;

@property(nonatomic,strong)UILabel *titleL;

@property(nonatomic,strong)UILabel *textL;

@property(nonatomic,strong)UIButton *cameraBtn;

@property(nonatomic,strong)UIButton *warnBtn;

@end
