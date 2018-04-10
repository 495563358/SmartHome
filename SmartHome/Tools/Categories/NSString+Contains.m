//
//  NSString+Contains.m
//  FanHeater
//
//  Created by SunZlin on 15/7/24.
//  Copyright (c) 2015年 kincony. All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString (Contains)
-(BOOL)containsString:(NSString *)str{
   
    if ([self rangeOfString:str].location==NSNotFound) {
        return NO;
    }
    return YES;

}
@end
