//
//  ChangeMobileViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/8/31.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "ChangeMobileViewController.h"
#import "LoadViewController.h"

#import "FindPWDViewController.h"

#import <ChuanglanCodeSDK/ChuanglanCodeSDK.h>
#import "UIView+Toast.h"

#define appKey @"ee18f2279de7e0d2eef361d882baba"

#define appSecrets @"9d4b9573f5b56a80ee52d1a40c61c2"

#define temID @"T24786081"

#define requestPath @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.bind"

#import "ObjectTools.h"

#import "UIView+Toast.h"

#import <CommonCrypto/CommonDigest.h>

@interface ChangeMobileViewController ()


@property (strong, nonatomic)  UITextField *account;

@property (strong, nonatomic)  UITextField *token;

@property (strong, nonatomic)  UITextField *password;

@property (strong, nonatomic)  UITextField *pwdToken;

@property (strong, nonatomic)  UIButton *getToken;

@end

@implementation ChangeMobileViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更换绑定手机号";
    
    
    //初始化SDK
    ChuanglanVerificationCode *code = [ChuanglanVerificationCode shareSMSCode];
    [code initWithAppKey:appKey appSecret:appSecrets];
    
    
    self.account = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-340)/2, 144, 340, 35)];
    self.token = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-340)/2, 144+50, 200, 35)];
    
    self.getToken = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90, 194 + 5, 80, 25)];
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
    
    _account.placeholder = @"请输入您需要绑定的手机号码";
    _token.placeholder = @"请输入4位短信验证码";
    _token.secureTextEntry = NO;
    
    _account.clearButtonMode = UITextFieldViewModeAlways;
    _token.clearButtonMode = UITextFieldViewModeAlways;
    
    _account.keyboardType = UIKeyboardTypeNumberPad;
    _token.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-340)/2, 144+100, 340, 35)];
    self.pwdToken = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-340)/2, 144+150, 340, 35)];
    
    _password.borderStyle = UITextBorderStyleNone;
    _pwdToken.borderStyle = UITextBorderStyleNone;
    
    _password.placeholder = @"请输入您的登录密码";
    _pwdToken.placeholder = @"请重新确认登录密码";
    _password.secureTextEntry = YES;
    _pwdToken.secureTextEntry = YES;
    
    _password.clearButtonMode = UITextFieldViewModeAlways;
    _pwdToken.clearButtonMode = UITextFieldViewModeAlways;
    
    
    [self.view addSubview:_account];
    [self.view addSubview:_token];
    [self.view addSubview:_password];
    [self.view addSubview:_pwdToken];
    
    UIButton *load = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w-320)/2, 144+220, 320, 35)];
    
    load.backgroundColor = [UIColor whiteColor];
    load.layer.borderWidth = 1.0f;
    load.layer.borderColor= Color_system.CGColor;
    load.layer.cornerRadius = 5.0f;
    [load setTitle:@"立即绑定" forState:UIControlStateNormal];
    [load setTitleColor:Color_system forState:UIControlStateNormal];
    [load addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:load];
    
    
    
    UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 80)/2, 40, 80, 80)];
    [imgBtn setImage:[UIImage imageNamed:@"touxiang-0"] forState:UIControlStateNormal];
    [self.view addSubview:imgBtn];
    
    
    
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

//点击立即注册
-(void)checkClick{
    [self.view endEditing:YES];
    
    
    bool isClick = _getToken.userInteractionEnabled;
    
    if (isClick) {
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
            statusStr = @"验证成功";
        }else{
            statusStr = [NSString stringWithFormat:@"%zd", statusCode];
            statusStr = @"验证失败，请检查后重试";
            [self.view makeToast:statusStr];
        }
        if ([statusStr isEqualToString:@"验证失败，请检查后重试"]) {
            return;
        }
    }];
    
    
    NSString *path = requestPath;
    
    NSString *userphone = _account.text;
    
    NSString *userpwd = _pwdToken.text;
    
    NSString *nonce = [self GetNonce];
    
    NSString *timestamp = [self getNowTimeTimestamp];
    
    NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"sign":_sign,@"token":_userToken,@"userphone":userphone,@"userpwd":userpwd};
    
    NSLog(@"dict = %@",dict);
    
    [[ObjectTools sharedManager] POST:path parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *ddd = (NSDictionary *)responseObject;
        NSLog(@"ddd = %@",ddd);
        NSDictionary *result = ddd[@"result"];
        NSString *message = result[@"message"];
        
        [self.view makeToast:message];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
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
            NSLog(@"213");
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
