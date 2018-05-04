//
//  BaseocHttpService.m
//  SmartHome
//
//  Created by Smart house on 2018/4/4.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "BaseocHttpService.h"
#import "ObjectTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "UIWindow+Visible.h"

@implementation BaseocHttpService

typedef void (^successBackBlock) (id responseObject);

+(void)postRequest:(NSString *)urlStr andParagram:(id)paragram success:(successBackBlock)success{
    
    UIView *visibleView = [UIWindow visibleViewController].view;
    [MBProgressHUD showHUDAddedTo:visibleView animated:YES];
    NSMutableDictionary *newParagram = [[NSMutableDictionary alloc]initWithDictionary:paragram];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    
    if (token) {
        newParagram[@"token"] = token;
        newParagram[@"nonce"] = [self GetNonce];
        newParagram[@"timestamp"] = [self getNowTimeTimestamp];
        NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",token];
        newParagram[@"sign"] = [self MD5:signStr];
    }
    
    [[ObjectTools sharedManager] POST:urlStr parameters:newParagram progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"本次请求网址 = %@",urlStr);
        NSLog(@"本次请求参数 = %@",newParagram);
        NSLog(@"本次请求结果 = %@",responseObject);
        
        success(responseObject);
        [MBProgressHUD hideAllHUDsForView:visibleView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:visibleView animated:YES];
        ShowMsg(@"网络似乎不太好哦- -");
    }];
    
    return;
}

+(NSString *)GetNonce{
    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (int i = 0; i < 16; i++) {
        int x = arc4random()%36;
        [mStr appendString:arr[x]];
    }
    return mStr;
}


+ (NSString *)MD5:(NSString *)mdStr
{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

@end
