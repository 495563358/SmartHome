//
//  FindPWDViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/8/29.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "FindPWDViewController.h"

#import "NewuserViewController.h"

#import "LoadViewController.h"

#import <ChuanglanCodeSDK/ChuanglanCodeSDK.h>

#import "UIView+Toast.h"

#define appKey @"ee18f2279de7e0d2eef361d882baba"

#define appSecrets @"9d4b9573f5b56a80ee52d1a40c61c2"

#define temID @"T15531131"

#import "ObjectTools.h"

#import <CommonCrypto/CommonDigest.h>

@interface FindPWDViewController ()


@end

@implementation FindPWDViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"找回密码";
    
    //初始化SDK
    ChuanglanVerificationCode *code = [ChuanglanVerificationCode shareSMSCode];
    [code initWithAppKey:appKey appSecret:appSecrets];
    
    
    CGFloat weight = Sc_w * 340/375;
    
    self.account = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 144, weight, 35)];
    self.token = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 144+50, 200, 35)];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 180, weight, 1)];
    label1.backgroundColor = color(204, 204, 204, 1);
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 180+50, weight, 1)];
    label2.backgroundColor = color(204, 204, 204, 1);
    
    
    
    self.getToken = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 100, 194 + 5, 80, 25)];
    [_getToken setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getToken setTitleColor:Color_system forState:UIControlStateNormal];
    _getToken.titleLabel.font = [UIFont systemFontOfSize:14];
    _getToken.layer.cornerRadius = 3.0;
    _getToken.layer.borderColor = Color_system.CGColor;
    _getToken.layer.borderWidth = 1.0f;
    [_getToken addTarget:self action:@selector(sendToken:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getToken];
    
    _account.borderStyle = UITextBorderStyleNone;
    _token.borderStyle = UITextBorderStyleNone;
    
    _account.placeholder = @"请输入您的手机号码";
    _token.placeholder = @"请输入4位短信验证码";
    
    _account.clearButtonMode = UITextFieldViewModeAlways;
    _token.clearButtonMode = UITextFieldViewModeAlways;
    
    _account.keyboardType = UIKeyboardTypeNumberPad;
    _token.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 144+100, weight, 35)];
    self.pwdToken = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 144+150, weight, 35)];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 280, weight, 1)];
    label3.backgroundColor = color(204, 204, 204, 1);
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 280+50, weight, 1)];
    label4.backgroundColor = color(204, 204, 204, 1);
    
    _password.borderStyle = UITextBorderStyleNone;
    _pwdToken.borderStyle = UITextBorderStyleNone;
    
    _password.placeholder = @"请输入您的登录密码";
    _pwdToken.placeholder = @"请输入确认登录密码";
    _password.secureTextEntry = YES;
    _pwdToken.secureTextEntry = YES;
    
    _password.clearButtonMode = UITextFieldViewModeAlways;
    _pwdToken.clearButtonMode = UITextFieldViewModeAlways;
    
    _account.font = [UIFont systemFontOfSize:15];
    _token.font = [UIFont systemFontOfSize:15];
    _password.font = [UIFont systemFontOfSize:15];
    _pwdToken.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:_account];
    [self.view addSubview:_token];
    [self.view addSubview:_password];
    [self.view addSubview:_pwdToken];
    
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:label4];
    
    UIButton *load = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 144+230, weight, 45)];
    
    load.backgroundColor = Color_system;
//    load.layer.borderWidth = 1.0f;
//    load.layer.borderColor= Color_system.CGColor;
    load.layer.cornerRadius = 10.0f;
    [load setTitle:@"立即找回" forState:UIControlStateNormal];
//    [load setTitleColor:Color_system forState:UIControlStateNormal];
    [load addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:load];
    
    
    
    UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 80)/2, 40, 80, 80)];
    [imgBtn setImage:[UIImage imageNamed:@"touxiang-0"] forState:UIControlStateNormal];
    [self.view addSubview:imgBtn];
    
    
    UIButton *forget = [[UIButton alloc]initWithFrame:CGRectMake(25, 430, 60, 30)];
    [forget setTitleColor:Color_system forState:UIControlStateNormal];
    [forget setTitle:@"立即注册" forState:UIControlStateNormal];
    [forget addTarget:self action:@selector(gotoReginstView) forControlEvents:UIControlEventTouchUpInside];
    forget.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:forget];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 25 - 60, 430, 60, 30)];
    [sureBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [sureBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(gotoLoadview) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:sureBtn];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)sendToken:(UIButton *)sender{
    
    
    [self.view endEditing:YES];
    
    if (![self checkTel:_account.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    
    [[ChuanglanVerificationCode shareSMSCode] getVerificationCode:self.account.text templateId:temID result:^(NSInteger statusCode) {
        
        NSString *statusStr;
        
        if (0 == statusCode) {
            statusStr = @"发送验证码成功";
            sender.userInteractionEnabled = NO;
            [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            sender.layer.borderColor = [UIColor grayColor].CGColor;
        }else{
            statusStr = [NSString stringWithFormat:@"%zd", statusCode];
        }
        
        [self.view makeToast:statusStr];
        
    }];
    
}

#pragma mark - 简单判断下手机号码是否合法
- (BOOL)checkTel:(NSString *)str
{
    NSString *regex = @"^((13[0-9])|(147)|(157)|(177)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//点击跳往注册
-(void)gotoReginstView{
    NewuserViewController *load = [[NewuserViewController alloc]init];
    [self.navigationController pushViewController:load animated:YES];
}


//点击找回密码
-(void)checkClick{
    [self.view endEditing:YES];
       
    if (_getToken.userInteractionEnabled) {
        [self.view makeToast:@"请先获取验证码"];
        return;
    }
    NSLog(@"%ld",_password.text.length);
    if (_password.text.length < 6) {
        [self.view makeToast:@"密码必须大于6位数"];
        return;
    }
    
    if (![_password.text isEqualToString:_pwdToken.text]) {
        [self.view makeToast:@"两次密码输入不一，请检查后重试"];
        return;
    }
    
    if (self.token.text.length==0||self.token.text == nil)
    {
        [self.view makeToast:@"请先输入验证码"];
        return;
    }
    
    [[ChuanglanVerificationCode shareSMSCode] checkVerificationCode:self.token.text result:^(NSInteger statusCode) {
        NSString *statusStr;
        if (0 == statusCode) {
            
            NSString *path = @"r=account.resetpwd";
            
            NSString *userphone = _account.text;
            
            NSString *userpwd = _pwdToken.text;
            
            NSString *nonce = [self GetNonce];
            
            NSString *timestamp = [self getNowTimeTimestamp];
            
            NSString *sign = [self MD5:[NSString stringWithFormat:@"userphone=%@&userpwd=%@&12345",userphone,userpwd]];
            
            
            NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"sign":sign,@"userphone":userphone,@"userpwd":userpwd};
            
            NSLog(@"%@",dict);
            
            
            [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:path] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *ddd = (NSDictionary *)responseObject;
                
                NSDictionary *result = ddd[@"result"];
                NSString *message = result[@"message"];
                
                [self.view makeToast:message];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.view makeToast:@"网络错误,请检查网络后重试"];
            }];
            
        }else{
            statusStr = [NSString stringWithFormat:@"%zd", statusCode];
            statusStr = @"验证失败，请检查后重试";
            [self.view makeToast:statusStr];
        }
        
    }];
    
   
    
}

-(NSString *)GetNonce{
    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (int i = 0; i < 16; i++) {
        int x = arc4random()%36;
        [mStr appendString:arr[x]];
    }
    NSLog(@"mStr = %@",mStr);
    return mStr;
}

//点击跳往登录
-(void)gotoLoadview{
    
    LoadViewController *load = [[LoadViewController alloc]init];
    [self.navigationController pushViewController:load animated:YES];
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
