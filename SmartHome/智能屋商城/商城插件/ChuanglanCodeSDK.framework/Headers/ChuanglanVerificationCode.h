//
//  ChuanglanVerificationCode.h
//  ChanglanCode
//
//  Created by Cyrus_huang on 2017/1/11.
//  Copyright © 2017年 Cyrus_huang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 验证码相关回调
 *  @param statusCode 当statusCode为0时表示成功,详见状态码列表
 */
typedef void (^SMSResultHandler) (NSInteger statusCode);

@interface ChuanglanVerificationCode : NSObject

/**类的单例*/
+ (ChuanglanVerificationCode *)shareSMSCode;
/**类初始化方法*/
- (void)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

/**获取验证码*/
- (void)getVerificationCode:(NSString *)phoneNum templateId:(NSString *)templateId result:(SMSResultHandler)result;;
/**检验验证码*/
- (void)checkVerificationCode:(NSString *)code result:(SMSResultHandler)result;;

/**
 *  请先到创蓝云通讯平台注册开发者账号并获取到如下数据
 *
 *  @param  appKey
 *  @param  appSecret
 *  @param  template_id
 *
 *  @return nil
 */
/**唯一识别值*/
@property(nonatomic,copy)NSString *appKey;

/**作为内容完整性验证使用*/
@property(nonatomic,copy)NSString *appSecret;

/**需要发送验证码的手机号*/
@property(nonatomic,copy)NSString *phoneNum;

/**发送短信验证码的模板ID*/
@property(nonatomic,copy)NSString *template_id;

@end
