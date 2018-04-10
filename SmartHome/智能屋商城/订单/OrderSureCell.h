//
//  OrderSureCell.h
//  SmartMall
//
//  Created by Smart house on 2017/9/14.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSureCell : UITableViewCell

@property(nonatomic ,strong)UIImageView *shoppingImgView;

@property(nonatomic,strong)UILabel *title ;

@property(nonatomic ,strong)UILabel *typeName;

@property(nonatomic ,strong)UILabel *price;


@property(nonatomic ,strong)UILabel *beforePrice;

@property(nonatomic,strong)UILabel *countLab;

@property(nonatomic,strong)UIButton *colortype;

@end
