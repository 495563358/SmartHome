//
//  ObjectTools.m
//  SmartHome
//
//  Created by Smart house on 2018/2/1.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "ObjectTools.h"
//友盟分享
#import <UMSocialCore/UMSocialCore.h>

#import <UShareUI/UShareUI.h>

#define USHARE_APPKEY @"59bb729265b6d611770006b8"

#import "WXApi.h"

//Push

@implementation ObjectTools

static AFHTTPSessionManager *afnManager = nil;

+(void)createPush{
}

+(void)createShare{
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    
    /* 打开日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    // 打开图片水印
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    
    [WXApi registerApp:@"wxb5f3ab13ecc98335"];
    
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxb5f3ab13ecc98335" appSecret:@"59bb729265b6d611770006b8" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    
    
    //    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106065074"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"685220916"  appSecret:@"fbed324262792cd63c7d3ca5d7b80b90" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}

+(AFHTTPSessionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        afnManager = [AFHTTPSessionManager manager];
        afnManager.requestSerializer.timeoutInterval = 5.0;
        afnManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        afnManager.responseSerializer = [AFJSONResponseSerializer serializer];
        afnManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
    });
    return afnManager;
}

//加载网页端数据 移除网页端导航栏
+(void)removeHead{
    NSString *userAgent = [[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"userAgent :%@", userAgent);
    
    NSString *newAgent = userAgent;
    if (![userAgent hasSuffix:@"/znhome/2.0.6"])
    {
        newAgent = [userAgent stringByAppendingString:@"/znhome/2.0.6"];
    }
    NSDictionary *newdict = @{@"UserAgent":newAgent};
    [[NSUserDefaults standardUserDefaults] registerDefaults:newdict];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
