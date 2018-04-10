//
//  NSString+Contains.h
//  FanHeater
//
//  Created by SunZlin on 15/7/24.
//  Copyright (c) 2015年 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (Contains)
-(NSString *) utf8ToUnicode;
-(BOOL)containsString:(NSString *)str;
-(NSString*) md5_16;
-(NSString *)md5_32;
@end
