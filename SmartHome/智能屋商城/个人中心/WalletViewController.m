//
//  WalletViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/10/23.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "WalletViewController.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"
//支付宝签名
#define AlipaySign @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.alisign1"

//支付宝充值成功
#define AlipaySuccess @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.alipay1"


//微信统一下单
#define WeChatOrder @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.createsign1"

//再次获取签名,准备支付
#define WeChatPay @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.createpay1"

//微信充值成功
#define WeChatPaySuccess @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.complete1"



#import <AlipaySDK/AlipaySDK.h>

#import "Order.h"

#import "WXApi.h"

//IP地址
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface WalletViewController ()<WXApiDelegate>{
    UITextField *rechangeAmount;
    
    UIButton *alipayBtn;
    UIButton *wechatBtn;
    
}


@end

@implementation WalletViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账户充值";
    self.view.backgroundColor = My_gray;
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self createHead];
    [self payways];
}

-(void)createHead{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Sc_w, 90)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UILabel *currBalance = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 20, 44)];
    currBalance.font = [UIFont systemFontOfSize:14];
    currBalance.text = [NSString stringWithFormat:@"当前余额    ￥%@",self.credit];
    
    [whiteView addSubview:currBalance];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 44, Sc_w - 20, 1)];
    line.backgroundColor = [UIColor grayColor];
    [whiteView addSubview:line];
    
    
    UILabel *rechangeamountL = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 75, 44)];
    rechangeamountL.text = @"充值金额";
    rechangeamountL.font = [UIFont systemFontOfSize:14];
    
    rechangeAmount = [[UITextField alloc]initWithFrame:CGRectMake(10,45 , Sc_w - 20, 44)];
    rechangeAmount.font = [UIFont systemFontOfSize:14];
//    rechangeAmount.keyboardType = UIKeyboardTypeNumberPad;
    rechangeAmount.textColor = Color_system;
    rechangeAmount.leftView = rechangeamountL;
    rechangeAmount.leftViewMode = UITextFieldViewModeAlways;
    
    [whiteView addSubview:rechangeAmount];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 88, Sc_w - 20, 1)];
    line2.backgroundColor = [UIColor grayColor];
    [whiteView addSubview:line2];
    
    
    [self.view addSubview:whiteView];
}

-(void)payways{
    //110
    UIButton *nextstep = [[UIButton alloc]initWithFrame:CGRectMake(10, 120, Sc_w - 20, 35)];
    nextstep.backgroundColor = Color_system;
    nextstep.titleLabel.font = [UIFont systemFontOfSize:14];
    
    nextstep.layer.cornerRadius = 5.0;
    
    [nextstep addTarget:self action:@selector(nextstepClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextstep setTitle:@"下一步" forState:UIControlStateNormal];
    
    [self.view addSubview:nextstep];
    
    
    alipayBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 + Sc_w, 120, Sc_w - 20, 35)];
    alipayBtn.backgroundColor = Color_system;
    alipayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    alipayBtn.layer.cornerRadius = 5.0;
    
    [alipayBtn addTarget:self action:@selector(alipayClick:) forControlEvents:UIControlEventTouchUpInside];
    [alipayBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    
    [self.view addSubview:alipayBtn];
    
    
    wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 + Sc_w, 170, Sc_w - 20, 35)];
    wechatBtn.backgroundColor = Color_system;
    wechatBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    wechatBtn.layer.cornerRadius = 5.0;
    
    [wechatBtn addTarget:self action:@selector(WechatClick:) forControlEvents:UIControlEventTouchUpInside];
    [wechatBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    
    [self.view addSubview:wechatBtn];
    
}

-(void)onResp:(BaseResp *)resp{
    
    NSLog(@"sad");
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                
            {
                NSLog(@"充值成功");
                [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                
                [[ObjectTools sharedManager] POST:WeChatPaySuccess parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *orderInfoSuc = (NSDictionary *)responseObject;
                    
                    NSLog(@"充值成功信息 %@",orderInfoSuc);
                    
                    //充值成功
                    [self.view makeToast:@"充值成功"];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self.view makeToast:@"网络错误,请检查网络后重试"];
                }];
                
            }
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                if (resp.errCode == -2) {
                    
                    [self.view makeToast:@"您取消了支付"];
                }else if (resp.errCode == -1){
                    [self.view makeToast:@"可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等"];
                }
                break;
        }
    }
}

-(void) onReq:(BaseReq*)req{
    NSLog(@"req------------------------");
    
}
//微信支付
-(void)WechatClick:(UIButton *)sender{
    
    NSString *ordersn = [self getOrdersn];
    
    CGFloat rechangePrice = [rechangeAmount.text floatValue];
    if (rechangePrice <= 0) {
        [self.view makeToast:@"充值金额必须大于零"];
        return;
    }
    NSString *price = [NSString stringWithFormat:@"%.2f",rechangePrice];
    
    NSLog(@"订单号 = %@",ordersn);
    
    NSString *addressIP = [self getIPAddress:YES];
    [_userInfo setObject:addressIP forKey:@"ip"];
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [_userInfo setObject:ordersn forKey:@"ordersn"];
    [_userInfo setObject:price forKey:@"price"];
    
    
    [_userInfo setObject:@"cz" forKey:@"flag"];
    NSString *homepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    NSString *path = [homepath stringByAppendingString:@"/orderinfo.plist"];
    [_userInfo writeToFile:path atomically:YES];
    
    
    NSLog(@"第一次加签传给后台的数据 = %@",_userInfo);
    
    [_userInfo setObject:price forKey:@"price"];
    
    [[ObjectTools sharedManager] POST:WeChatOrder parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"获取预付单签名返回 = %@",dict);
        
        NSString *sign = dict[@"result"];
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [mdict removeObjectForKey:@"result"];
        [mdict removeObjectForKey:@"status"];
        
        [mdict setObject:sign forKey:@"sign"];
        [mdict setObject:@"APP" forKey:@"trade_type"];
        [mdict setObject:@"http://mall.znhomes.com/app/back.php" forKey:@"notify_url"];
        
        NSString *nonce_str = mdict[@"nonce"];
        [mdict removeObjectForKey:@"nonce"];
        [mdict setObject:nonce_str forKey:@"nonce_str"];
        
        
        [mdict setObject:addressIP forKey:@"spbill_create_ip"];
        
        [mdict setObject:@"wxb5f3ab13ecc98335" forKey:@"appid"];
        
        NSLog(@"提交给微信端的数据 = \n%@",mdict);
        
        NSMutableString *mstr = [NSMutableString new];
        
        [mstr appendString:@"<xml>\n"];
        
        
        
        for (NSString *key in mdict.allKeys) {
            [mstr appendString:[NSString stringWithFormat:@"<%@>%@</%@>\n",key,[mdict objectForKey:key],key]];
        }
        [mstr appendString:@"</xml>\n"];
        
        
        NSLog(@"数据转化为xml格式后 = %@\n",mstr);
        
        
        
        
        //1.创建会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        //2.根据会话对象创建task
        NSURL *url = [NSURL URLWithString:@"https://api.mch.weixin.qq.com/pay/unifiedorder"];
        //3.创建可变的请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //4.修改请求方法为POST
        request.HTTPMethod = @"POST";
        //        [request setValue:@"application/json;encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
        //5.设置请求体
        NSString *prame = mstr;
        request.HTTPBody = [prame dataUsingEncoding:NSUTF8StringEncoding];
        //6.根据会话对象创建一个Task(发送请求）
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
            //8.解析数据
            //根据后端数据解析
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"微信返回xml数据 = %@",str);
            
            NSRange range = [str rangeOfString:@"<prepay_id><![CDATA["];
            range.location += range.length;
            range.length = [str length] - range.location;
            
            
            NSRange range2 = [str rangeOfString:@"]]></prepay_id>" options:NSCaseInsensitiveSearch range:range];
            range.length = range2.location - range.location;
            NSString *subStr = [str substringWithRange:range];
            NSLog(@"微信单号 = %@",subStr);
            //
            
            
            [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
            [_userInfo setObject:subStr forKey:@"prepayid"];
            
            [[ObjectTools sharedManager] POST:WeChatPay parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"再次签名返回:%@",responseObject);
                
                NSDictionary *orderInfo = (NSDictionary *)responseObject;
                
                PayReq *request = [[PayReq alloc] init];
                //商户号
                request.partnerId = orderInfo[@"partnerid"];
                
                request.prepayId= subStr;
                
                request.package = @"Sign=WXPay";
                
                request.nonceStr= orderInfo[@"nonce"];
                
                request.timeStamp = [orderInfo[@"timestamp"] intValue];
                
                request.sign= orderInfo[@"result"];
                
                BOOL returnResult = [WXApi sendReq:request];
                
                if (!returnResult) {
                    [self.view makeToast:@"无法打开微信客户端"];
                }else{
                    
                    [self.view makeToast:@"正在与微信客户端连接,请稍后"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.view makeToast:@"网络错误,请检查网络后重试"];
            }];
            
            /* dispatch_async(dispatch_get_main_queue(), ^{
             网络请求自动开启在子线程，UI刷新的代码需要回到主线程操作
             });
             */
        }];
        //7.执行任务
        [dataTask resume];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
}


//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


-(void)alipayClick:(UIButton *)sender{
    
    NSString *ordersn = [self getOrdersn];
    
    CGFloat rechangePrice = [rechangeAmount.text floatValue];
    if (rechangePrice <= 0) {
        [self.view makeToast:@"充值金额必须大于零"];
        return;
    }
    NSString *price = [NSString stringWithFormat:@"%.2f",rechangePrice];
    
    NSLog(@"%@",ordersn);
    
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [_userInfo setObject:ordersn forKey:@"ordersn"];
    [_userInfo setObject:price forKey:@"price"];
    
    
    NSString *homepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    
    NSString *path = [homepath stringByAppendingString:@"/orderinfo.plist"];
    [_userInfo writeToFile:path atomically:YES];
    
    [[ObjectTools sharedManager] POST:AlipaySign parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",(NSDictionary *)responseObject);
        
        NSDictionary *result = (NSDictionary *)responseObject;
        
        NSString *signedString = result[@"orderinfo"];
        
        NSDictionary *conInfo = result[@"con"];
        
        
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order* order = [Order new];
        
        // NOTE: app_id设置
        order.app_id = @"2017082808429788";
        
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        
        // NOTE: 支付版本
        order.version = @"1.0";
        
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = @"RSA2";
        
        // NOTE: 商品数据
        order.biz_content = [BizContent new];
        order.biz_content.body = conInfo[@"body"];
        order.biz_content.subject = conInfo[@"subject"];
        order.biz_content.out_trade_no = conInfo[@"out_trade_no"]; //订单ID（由商家自行制定）
        order.biz_content.timeout_express = conInfo[@"timeout_express"]; //超时时间设置
        order.biz_content.total_amount = conInfo[@"total_amount"]; //商品价格
        
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        NSLog(@"orderSpec = %@",orderInfo);
        
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"SmerHomer2016";
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                NSLog(@"支付回调 = %@",resultDic);
                
                if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                    
                    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                    
                    [[ObjectTools sharedManager] POST:AlipaySuccess parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *orderInfoSuc = (NSDictionary *)responseObject;
                        
                        NSLog(@"充值成功信息 %@",orderInfoSuc);
                        
                        //充值成功
                        [self.view makeToast:@"充值成功,重新进入个人中心即可查看最新余额"];
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self.view makeToast:@"网络错误,请检查网络后重试"];
                    }];
                }else
                    [self.view makeToast:@"充值失败,您取消了支付"];
                
            }];
            
            [[AlipaySDK defaultService]processOrderWithPaymentResult:[NSURL URLWithString:appScheme] standbyCallback:^(NSDictionary *resultDic) {
                
                NSLog(@"意外杀死支付回调 = %@",resultDic);
                
                if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                    
                    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                    
                    [[ObjectTools sharedManager] POST:AlipaySuccess parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *orderInfoSuc = (NSDictionary *)responseObject;
                        
                        NSLog(@"充值成功信息 %@",orderInfoSuc);
                        
                        //充值成功
                        [self.view makeToast:@"充值成功,重新进入个人中心即可查看最新余额"];
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self.view makeToast:@"网络错误,请检查网络后重试"];
                    }];
                    
                }else
                    [self.view makeToast:@"充值失败,您取消了支付"];
                
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
    

}


-(NSString *)getOrdersn{
    
    [rechangeAmount resignFirstResponder];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    
    
    NSString *ordersn = [NSString stringWithFormat:@"CZ%@%@",currentDateString,[self getSubString]];
    return ordersn;
    
    
}

-(NSString *)getSubString{
    NSArray *arr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (int i = 0; i < 6; i++) {
        int x = arc4random()%10;
        [mStr appendString:arr[x]];
    }
    return mStr;
}


- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

//下一步
-(void)nextstepClick:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        sender.frame = CGRectMake(10 - Sc_w, 120, Sc_w - 20, 35);
        alipayBtn.frame = CGRectMake(10, 120, Sc_w - 20, 35);
        wechatBtn.frame = CGRectMake(10, 170, Sc_w - 20, 35);
    }completion:^(BOOL finished) {
        sender.hidden = YES;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    rechangeAmount.text = [NSString stringWithFormat:@"%.2f",[rechangeAmount.text floatValue]];
    
    [self.view endEditing:YES];
    
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
