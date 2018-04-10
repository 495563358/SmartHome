//
//  ShopCarModel.h
//  SmartMall
//
//  Created by Smart house on 2017/9/7.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *optiontitle;

@property(nonatomic,copy)NSString *goodsid;

@property(nonatomic,copy)NSString *optionstock;

@property(nonatomic,copy)NSString *thumb;

@property(nonatomic,copy)NSString *total;

@property(nonatomic,copy)NSString *marketprice;

@property(nonatomic,copy)NSString *optionID;

@property(nonatomic,assign)NSInteger section;

@property(nonatomic,assign)NSInteger row;

@property(nonatomic,assign)NSString *cartid;


-(instancetype)initWithDict:(NSDictionary *)dict;


@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,weak)ShopCarModel *vm;

@end
