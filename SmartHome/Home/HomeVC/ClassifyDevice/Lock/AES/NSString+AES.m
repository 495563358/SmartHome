//
//  NSString+AES.m
//  AESTest
//
//  Created by sunzl on 16/6/1.
//  Copyright © 2016年 杜甲. All rights reserved.
//

#import "NSString+AES.h"
#import "NSData+AES.h"
@implementation NSString(AES)
/*加密方法*/
-(NSString *)AESEncrypt
{
    
    return [NSData AESEncrypt:[self base64String]];

}
/*解密方法*/
-(NSString *)AESDecrypt
{
    return [NSData AESDecrypt:self];
}
//空字符串
#define  LocalStr_None  @""

- (NSString *)base64String
{
    if (self && ![self isEqualToString:LocalStr_None]) {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        return [data base64Encode];
    }
    else {
        return LocalStr_None;
    }
}

@end
