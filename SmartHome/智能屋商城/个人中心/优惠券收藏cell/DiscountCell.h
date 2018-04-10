//
//  DiscountCell.h
//  SmartMall
//
//  Created by Smart house on 2017/9/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCell : UITableViewCell


@property (nonatomic , strong)UILabel *priceBigger;

@property (nonatomic , strong)UILabel *moneyTitle;

@property (nonatomic , strong)UILabel *deadLine;

@property (nonatomic , strong)UIImageView *staleImg;


@property (nonatomic , strong)UIImageView *backView;

@property (nonatomic , strong)UIButton *getBtn;

@property(nonatomic,copy)void(^getBlock)(UIButton *);


@end
