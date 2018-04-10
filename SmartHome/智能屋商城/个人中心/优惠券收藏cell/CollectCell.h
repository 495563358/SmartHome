//
//  CollectCell.h
//  SmartMall
//
//  Created by Smart house on 2017/9/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectCell : UITableViewCell



@property (nonatomic , strong)UIImageView *imageview;

@property (nonatomic , strong)UILabel *titleL;

@property (nonatomic , strong)UILabel *subtitleL;

@property (nonatomic , strong)UILabel *price;

@property (nonatomic , strong)UIButton *shareBtn;

@property (nonatomic , strong)UIButton *deldBtn;

@property (nonatomic , weak)void(^shareBlock)(NSInteger integer);



@end
