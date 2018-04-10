//
//  BaseocHttpService.m
//  SmartHome
//
//  Created by Smart house on 2018/4/4.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "BaseocHttpService.h"
#import "ObjectTools.h"

@implementation BaseocHttpService

typedef void (^successBackBlock) (id responseObject);

+(void)postRequest:(NSString *)urlStr andParagram:(id)paragram success:(successBackBlock)success{
    
    [[ObjectTools sharedManager] POST:urlStr parameters:paragram progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ShowMsg(@"网络似乎不太好哦- -");
    }];
    
    return;
}

@end
