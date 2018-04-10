//
//  ShopCarModel.m
//  SmartMall
//
//  Created by Smart house on 2017/9/7.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "ShopCarModel.h"

@implementation ShopCarModel


-(instancetype)init{
    if (self = [super init]) {
//        [self initWithDict:];
    }
    return self;
}


-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        //        [self setValuesForKeysWithDictionary:dict];
        
        self.title = dict[@"title"];
        self.optiontitle = dict[@"optiontitle"];
        self.goodsid = dict[@"goodsid"];
        self.marketprice = dict[@"marketprice"];
        self.thumb = dict[@"pthumb"];
        self.optionstock = dict[@"stock"];
        self.total = dict[@"total"];
        
    }
    return self;
    
}


//- (void)setVm:(ShopCarModel *)vm
//{
//    _vm = vm;
//    [self addObserver:vm forKeyPath:@"isSelect" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//}
//-(void)dealloc
//{
//    
//    
//    [self removeObserver:_vm forKeyPath:@"isSelect"];
//    
//}



@end
