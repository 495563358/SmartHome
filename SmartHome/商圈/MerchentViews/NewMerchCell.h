//
//  NewMerchCell.h
//  SmartHome
//
//  Created by Smart house on 2018/5/4.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMerchCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *mainworkLabel;
@property(nonatomic,strong)UILabel *attendWays;
@property(nonatomic,strong)UILabel *alongTime;
@property(nonatomic,strong)UILabel *shopArea;
@property(nonatomic,strong)UILabel *distance;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andInfo:(NSDictionary *)info;

@end
