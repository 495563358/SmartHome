//
//  NSDictionary+Ping.m
//  HttpDemo
//
//  Created by sunzl on 16/3/9.
//  Copyright © 2016年 sunzl. All rights reserved.
//

#import "NSDictionary+Ping.h"

@implementation NSDictionary(Ping)

-(NSString*)ping{
   
       NSMutableString *resStr= [[NSMutableString alloc]init];
    NSArray *myKeys = [self allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for(id key in sortedKeys) {
        id object = [self objectForKey:key];
        
  
        [resStr appendString:key];
        [resStr appendString:@"="];
        [resStr appendString:object];
        [resStr appendString:@"&"];
    }
    
    [resStr deleteCharactersInRange:NSMakeRange(resStr.length-1,1)];
    return resStr;

}

@end
