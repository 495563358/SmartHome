//
//  BusinessCell.h
//  SmartMall
//
//  Created by Smart house on 2017/11/1.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *mainworkLabel;
@property(nonatomic,strong)UILabel *attendWays;
@property(nonatomic,strong)UILabel *alongTime;
@property(nonatomic,strong)UILabel *shopArea;
@property(nonatomic,strong)UILabel *distance;

@end
