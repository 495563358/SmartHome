//
//  MerchantLoadVC.m
//  SmartHome
//
//  Created by Smart house on 2018/5/8.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchantLoadVC.h"
#import <CommonCrypto/CommonDigest.h>

#import "ObjectTools.h"

#import "MBProgressHUD.h"

#import "UIView+Toast.h"
@interface MerchantLoadVC ()<UIWebViewDelegate>

@end

@implementation MerchantLoadVC

-(void)test{
    NSString *path = @"r=member.appinfo";
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *userToken = [user objectForKey:@"userToken"];
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",userToken];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict1 = @{@"nonce":nonce,@"timestamp":timestamp,@"token":userToken,@"sign":sign};
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:path] parameters:dict1 progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *returnInfo = (NSDictionary *)responseObject;
        
        if ([returnInfo[@"mobile"] length] < 7) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [self.view makeToast:@"您的登录已失效,请重新登录后再试"];
            [self performSelector:@selector(animation) withObject:nil afterDelay:2.0];
            
            NSString *userToken = nil;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:userToken forKey:@"userToken"];
            [user synchronize];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)animation{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商户登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui(b)"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    [self test];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *userToken = [user objectForKey:@"userToken"];
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",userToken];
    NSString *sign = [self MD5:signStr];
    
    NSString *substr = [NSString stringWithFormat:@"&nonce=%@&timestamp=%@&token=%@&sign=%@",nonce,timestamp,userToken,sign];
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:Sc_bounds];
    
    NSString *urlstr = [@"http://mall.znhomes.com/web/merchant.php?c=site&a=entry&m=ewei_shopv2&do=web&r=login" stringByAppendingString:substr];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    webview.userInteractionEnabled = YES;
    webview.delegate = self;
    webview.opaque = NO;
    webview.scalesPageToFit = YES;
    webview.backgroundColor = [UIColor whiteColor];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
    
    [self.view addSubview:webview];
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)GetNonce{
    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (int i = 0; i < 16; i++) {
        int x = arc4random()%36;
        [mStr appendString:arr[x]];
    }
    return mStr;
}


- (NSString *)MD5:(NSString *)mdStr
{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)getNowTimeTimestamp{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}
@end
