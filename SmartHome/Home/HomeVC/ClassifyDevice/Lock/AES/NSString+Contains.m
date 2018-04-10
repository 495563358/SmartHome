//
//  NSString+Contains.m
//  FanHeater
//
//  Created by SunZlin on 15/7/24.
//  Copyright (c) 2015年 kincony. All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString (Contains)
-(NSString *) utf8ToUnicode

{
    
    return  [self stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
}
-(BOOL)containsString:(NSString *)str{
   
    if ([self rangeOfString:str].location==NSNotFound) {
        return NO;
    }
    return YES;

}
-(NSString *) md5_16 {
    const char * cStrValue = [self UTF8String];
    unsigned char theResult[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, strlen(cStrValue), theResult);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            theResult[0], theResult[1], theResult[2], theResult[3],
            theResult[4], theResult[5], theResult[6], theResult[7],
            theResult[8], theResult[9], theResult[10], theResult[11],
            theResult[12], theResult[13], theResult[14], theResult[15]]lowercaseString];
}
//md5 32位 加密 （小写）
- (NSString *)md5_32{
    
    
    
    const char *cStr = [self UTF8String];
    
    
    
    unsigned char result[32];
    
    
    
    CC_MD5( cStr, strlen(cStr), result );
    
    
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15],result[16], result[17],result[18], result[19],result[20], result[21],result[22], result[23],result[24], result[25],result[26], result[27],result[28], result[29],result[30], result[31]]lowercaseString];
    
}
@end
