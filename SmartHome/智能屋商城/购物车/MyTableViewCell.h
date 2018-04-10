//
//  MyTableViewCell.h
//  个人通讯录
//
//  Created by mac on 2016/11/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLZ_ChangeCountView.h"

@interface MyTableViewCell : UITableViewCell

@property(nonatomic ,strong)WLZ_ChangeCountView *buyCount;

@property(nonatomic ,strong)UIButton *selectBtn;

@property(nonatomic ,strong)UIImageView *shoppingImgView;

@property(nonatomic,strong)UILabel *title ;

@property(nonatomic ,strong)UILabel *typeName;

@property(nonatomic ,strong)UILabel *price;


@property(nonatomic ,strong)UILabel *beforePrice;

@property(nonatomic ,strong)UILabel *beforeCount;


@property(nonatomic,assign)NSInteger optionstock;

@property(nonatomic,assign)NSInteger choosedCount;

@property(nonatomic,copy)void(^selectBlock)(NSInteger choosedCount);

@property(nonatomic,strong)UILabel *countLab;

@property(nonatomic,strong)UIButton *removeBtn;

@property(nonatomic,strong)UIButton *colortype;

@property(nonatomic,copy)void(^removeBlock)();

@end
