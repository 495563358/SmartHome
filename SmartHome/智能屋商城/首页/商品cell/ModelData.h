//
//  ModelData.h
//  SmartMall
//
//  Created by Smart house on 2017/8/17.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelData : NSObject

@property(nonatomic,strong)id thumb;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *productprice;
@property(nonatomic,copy)NSString *salesreal;
@property(nonatomic,assign)int index;
@property(nonatomic,copy)NSString *gid;


+(ModelData *)getModelData:(id )thumb andTitle:(NSString *)name andPrcie:(NSString *)price andproductprice:(NSString *)productprice;

@end
