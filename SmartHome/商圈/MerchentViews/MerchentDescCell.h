//
//  MerchentDescCell.h
//  SmartHome
//
//  Created by Smart house on 2018/4/28.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchentDescCell : UITableViewCell

@property (nonatomic,strong)UILabel *contentLabel;

-(instancetype)initWithDesc:(NSString *)desc;

@end
