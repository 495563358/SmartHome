//
//  ObjectTools.h
//  SmartHome
//
//  Created by Smart house on 2018/2/1.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface ObjectTools : NSObject

+(void)createPush;

+(void)createShare;

//加载网页端数据 移除网页端导航栏
+(void)removeHead;

+(AFHTTPSessionManager *)sharedManager;

@end
