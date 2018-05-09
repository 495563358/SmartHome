//
//  MerchschemeCell.h
//  SmartHome
//
//  Created by Smart house on 2018/5/3.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchschemeCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *subLab;

-(void)configcell:(NSDictionary *)info;

+(CGFloat)getCellHeight;

@end
