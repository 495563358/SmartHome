//
//  ModelData.m
//  SmartMall
//
//  Created by Smart house on 2017/8/17.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "ModelData.h"

@interface ModelData()

@end
@implementation ModelData


+(ModelData *)getModelData:(id)thumb andTitle:(NSString *)name andPrcie:(NSString *)price andproductprice:(NSString *)productprice{
    ModelData *data = [[ModelData alloc]init];
    data.thumb = thumb;
    data.title = name;
    data.price = [NSString stringWithFormat:@"¥%@",price];
    data.productprice = [NSString stringWithFormat:@"¥%@",productprice];
    
    return data;
}

@end
