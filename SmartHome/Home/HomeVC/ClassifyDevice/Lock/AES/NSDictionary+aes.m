//
//  NSDictionary+aes.m
//  DeliBaoxiang
//
//  Created by sunzl on 16/6/2.
//  Copyright © 2016年 sunzl. All rights reserved.
//

#import "NSDictionary+aes.h"
#import "NSString+AES.h"
@implementation NSDictionary(aes)
-(NSDictionary *)ase
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *myKeys = [self allKeys];
    for (id key in myKeys ) {
        id  object = [self objectForKey:key];
        
        if ([object isKindOfClass:[NSValue class]]) {
            [dic setObject:object  forKey:key];
        }else{
        [dic setObject:[object AESEncrypt] forKey:key];
        }
   
    }
    return dic;
}
-(NSDictionary *)deAse
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *myKeys = [self allKeys];
    for (NSString * key in myKeys ) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSNumber class]]) {
            [dic setObject:object forKey:key];
        }else if([object isKindOfClass:[NSArray class]]){
//            NSLog(@"11111");
            //针对rows
            NSMutableArray *rowArr = [NSMutableArray array];
            for (NSDictionary *rows in object) {
                 NSArray *rowsKeys = [rows allKeys];
                NSMutableDictionary *row_dic = [NSMutableDictionary dictionary];
                for (NSString * rowskey in rowsKeys) {
                     [row_dic setObject:[rows[rowskey]  AESDecrypt] forKey:rowskey];
                    NSLog(@"%@",[rows[rowskey]  AESDecrypt]);
                }
                [rowArr addObject:row_dic];
            }
            [dic setObject:rowArr forKey:key];
            
        }else  if([object isKindOfClass:[NSNull class]]){
//            NSLog(@"2222");
             [dic setObject:object   forKey:key];
            
        }else{
                        
            [dic setObject:[object AESDecrypt] forKey:key];

        
        }
      
    }
    return dic;
}
@end
