//
//  NSString+AES.h
//  AESTest
//
//  Created by sunzl on 16/6/1.
//  Copyright © 2016年 杜甲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(AES)
-(NSString *)AESEncrypt;
-(NSString *)AESDecrypt;
- (NSString *)base64String;
@end
