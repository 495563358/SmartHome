//
//  MerchentDescCell.h
//  SmartHome
//
//  Created by Smart house on 2018/4/28.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchentDescCell : UITableViewCell

@property (nonatomic,assign)CGFloat descHeight;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIButton *showAll;

@property (nonatomic,copy)void(^changeCellHeight)(BOOL showAll);

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDesc:(NSString *)desc andShow:(BOOL)showAll;

@end
