//
//  BaseocHttpService.h
//  SmartHome
//
//  Created by Smart house on 2018/4/4.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseocHttpService : NSObject

+(void)postRequest:(NSString *)urlStr andParagram:(id)paragram success:(void (^)(id responseObject))success;

@end
