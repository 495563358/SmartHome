//
//  LoadViewController.m
//  UI进阶项目
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LoadViewController.h"

#import "SmartHome-Swift.h"

#import "NewuserViewController.h"

#import "FindPWDViewController.h"

#import "UIView+Toast.h"

#import "ObjectTools.h"

#import <CommonCrypto/CommonDigest.h>

#import "UserCenterViewController.h"

@interface LoadViewController ()

@property(nonatomic,strong)NSMutableArray *userdata;

@end

@implementation LoadViewController


-(NSMutableArray *)userdata{
    if (!_userdata) {
        _userdata = [NSMutableArray array];
    }return _userdata;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = My_gray;
    
    self.navigationItem.title = @"智能商城登录";
    
    [self createView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

-(void)backClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)newUserClick{
    NewuserViewController *newuser = [[NewuserViewController alloc]init];
    newuser.accountAndPwd = ^(NSString *acc,NSString *pwd){
        _account.text = acc;
        _password.text = pwd;
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newuser animated:YES];
}

-(void)findPWD{
    FindPWDViewController *findPWD = [[FindPWDViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findPWD animated:YES];
}

-(void)createView{
    CGFloat weight = Sc_w * 340/375;
    
    _account = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 184, weight, 35)];
    _password = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 184+50, weight, 35)];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 220, weight, 1)];
    label1.backgroundColor = color(204, 204, 204, 1);
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 220+50, weight, 1)];
    label2.backgroundColor = color(204, 204, 204, 1);
    
    _account.borderStyle = UITextBorderStyleNone;
    _password.borderStyle = UITextBorderStyleNone;
    
    _account.placeholder = @"  请输入您的手机号码";
    
    _account.font = [UIFont systemFontOfSize:15];
    _password.placeholder = @"  请输入您的登录密码";
    _password.secureTextEntry = YES;
    
    _password.font = [UIFont systemFontOfSize:15];
    
    _account.clearButtonMode = UITextFieldViewModeAlways;
    _password.clearButtonMode = UITextFieldViewModeAlways;
    
    _account.keyboardType = UIKeyboardTypeNumberPad;
    _password.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:_account];
    [self.view addSubview:_password];
    
    [self.view addSubview:label1];
    
    [self.view addSubview:label2];
    
    
    UIImageView *mobileLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 20)];
    mobileLeft.image = [UIImage imageNamed:@"zhanghao"];
    _account.leftView = mobileLeft;
    _account.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIImageView *pwdLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 20)];
    pwdLeft.image = [UIImage imageNamed:@"mima"];
    _password.leftView = pwdLeft;
    _password.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *showPWD = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 13)];
    
    _password.rightViewMode = UITextFieldViewModeAlways;
    _password.rightView = showPWD;
    [showPWD setImage:[UIImage imageNamed:@"buxiansmm"] forState:UIControlStateNormal];
    [showPWD addTarget:self action:@selector(showPWD:) forControlEvents:UIControlEventTouchUpInside];
    showPWD.tag = 1;
    
    [self.account setValue:[NSNumber numberWithInt:12] forKey:@"paddingLeft"];
    
    [self.password setValue:[NSNumber numberWithInt:12] forKey:@"paddingLeft"];
    
    
    
    //账号密码
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *acc = [user objectForKey:@"MallAccount"];
    
    if (acc.length == 11) {
        _account.text = acc;
        //        _password.text = pwd; && pwd.length >= 6 NSString *pwd = [user objectForKey:@"MallPassword"];
    }
    
    
    UIButton *load = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 184+130, weight, 45)];
    
    load.backgroundColor = Color_system;
    load.layer.cornerRadius = 10.0f;
    [load setTitle:@"登录" forState:UIControlStateNormal];
//    [load setTitleColor:Color_system forState:UIControlStateNormal];
    [load addTarget:self action:@selector(loadClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:load];
    
    
    
    UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 80)/2, 47, 80, 80)];
    [imgBtn setImage:[UIImage imageNamed:@"touxiang-0"] forState:UIControlStateNormal];
    [self.view addSubview:imgBtn];
    
    
    UIButton *forget = [[UIButton alloc]initWithFrame:CGRectMake(25, 380, 60, 30)];
    [forget setTitleColor:Color_system forState:UIControlStateNormal];
    [forget setTitle:@"密码找回" forState:UIControlStateNormal];
    forget.titleLabel.font = [UIFont systemFontOfSize:14];
    [forget addTarget:self action:@selector(findPWD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forget];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 25 - 60, 380, 60, 30)];
    [sureBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [sureBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(newUserClick) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:sureBtn];
    
    
}


-(void)showPWD:(UIButton *)sender{
    if (sender.tag == 1) {
        sender.tag = 0;
        [sender setImage:[UIImage imageNamed:@"xiansmm"] forState:UIControlStateNormal];
        _password.secureTextEntry = NO;
    }else{
        sender.tag = 1;
        [sender setImage:[UIImage imageNamed:@"buxiansmm"] forState:UIControlStateNormal];
        _password.secureTextEntry = YES;
    }
}



-(void)loadClick{
    
    [self.view endEditing:YES];
    
    if (![self checkTel:_account.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    
    if (_password.text.length < 6) {
        [self.view makeToast:@"请检查您的账号密码后重试"];
        return;
    }
    NSString *path = @"r=account.logg";
    
    NSString *userphone = _account.text;
    
    NSString *userpwd = _password.text;
    
    NSString *nonce = [self GetNonce];
    
    NSString *timestamp = [self getNowTimeTimestamp];
    
    NSString *sign = [self MD5:[NSString stringWithFormat:@"userphone=%@&userpwd=%@&12345",userphone,userpwd]];
    
    AppDelegate * appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"sign":sign,@"userphone":userphone,@"userpwd":userpwd,@"device_tokens":appd.uPushdeviceToken};
    
//    NSLog(@"%@",dict);
    
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:path] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *ddd = (NSDictionary *)responseObject;
        
        NSDictionary *result = ddd[@"result"];
        NSLog(@"%@",ddd);
        NSString *message = result[@"message"];
        
        
        
        if ([message isEqualToString:@"登录成功"]) {
            [self.view makeToast:message];
            
            NSString *userToken = result[@"token"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:userToken forKey:@"userToken"];
            
            [user setObject:userphone forKey:@"MallAccount"];
            
            [user setObject:userpwd forKey:@"MallPassword"];
            
            [user synchronize];
            
            if (self.isHideSelfOrTurntoUsercenter) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                UserCenterViewController *userCenter = [[UserCenterViewController alloc]init];
                userCenter.token = userToken;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userCenter animated:YES];
            }
        }else{
            [self.view makeToast:@"用户名或密码错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络错误");
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

- (BOOL)checkTel:(NSString *)str
{
    NSString *regex = @"^((13[0-9])|(147)|(157)|(177)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
//    self.userdata = [Model dataFrompath];
    
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
