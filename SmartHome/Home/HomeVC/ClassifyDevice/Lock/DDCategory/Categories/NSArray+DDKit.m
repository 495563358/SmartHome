//
//  NSArray+DDKit.m
//  DDCategory
//
//  Created by DeJohn Dong on 15/4/25.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "NSArray+DDKit.h"

@implementation NSArray (DDKit)

- (id)dd_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
- (NSArray *) dd_randomizedArray {
    NSMutableArray *results = [NSMutableArray arrayWithArray:self];
    
    int i = (int)[results count];
    while(--i > 0) {
        int j = rand() % (i+1);
        [results exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:results];
}
@end
