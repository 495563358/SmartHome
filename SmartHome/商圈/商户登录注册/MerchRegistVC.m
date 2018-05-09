//
//  MerchRegistVC.m
//  SmartHome
//
//  Created by Smart house on 2018/5/6.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchRegistVC.h"


//vender
#import <ChuanglanCodeSDK/ChuanglanCodeSDK.h>

#define appKey @"ee18f2279de7e0d2eef361d882baba"
#define appSecrets @"9d4b9573f5b56a80ee52d1a40c61c2"
#define temID @"T24786081"

@interface MerchRegistVC (){
    BOOL haveGetVerificationCode;
}

@property (strong, nonatomic)  UITextField *account;
@property (strong, nonatomic)  UITextField *password;

@property (strong, nonatomic)  UITextField *token;
@property (strong, nonatomic)  UITextField *pwdToken;

@property (strong, nonatomic)  UIButton *getToken;

@end

@implementation MerchRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = My_gray;
    self.navigationItem.title = @"新商户注册";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui(b)"] style:UIBarButtonItemStylePlain target:self action:@selector(backToFront)];
    // Do any additional setup after loading the view.
    
    [self createView];
    
}

-(void)createView{
    //初始化SDK
    ChuanglanVerificationCode *code = [ChuanglanVerificationCode shareSMSCode];
    [code initWithAppKey:appKey appSecret:appSecrets];
    
    CGFloat weight = Sc_w * 340/375;
    
    self.account = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 144, weight - 120, 35)];
    self.token = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 144+50, weight, 35)];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 180, weight, 1)];
    label1.backgroundColor = color(204, 204, 204, 1);
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 180+50, weight, 1)];
    label2.backgroundColor = color(204, 204, 204, 1);
    
    self.getToken = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 120, 144 + 3, 100, 29)];
    [_getToken setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getToken setTitleColor:Color_system forState:UIControlStateNormal];
    _getToken.titleLabel.font = [UIFont systemFontOfSize:14];
    _getToken.layer.cornerRadius = 3.0;
    _getToken.layer.borderColor = Color_system.CGColor;
    _getToken.layer.borderWidth = 1.0f;
    
    [_getToken addTarget:self action:@selector(sendToken:) forControlEvents:UIControlEventTouchUpInside];
    
    _account.borderStyle = UITextBorderStyleNone;
    _token.borderStyle = UITextBorderStyleNone;
    
    _account.placeholder = @"请输入您的手机号码";
    _token.placeholder = @"请输入4位短信验证码";
    _token.secureTextEntry = NO;
    
    _account.clearButtonMode = UITextFieldViewModeAlways;
    _token.clearButtonMode = UITextFieldViewModeAlways;
    
    _account.keyboardType = UIKeyboardTypeNumberPad;
    _token.keyboardType = UIKeyboardTypeNumberPad;
    
    
    [self.view addSubview:_account];
    [self.view addSubview:_token];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:_getToken];
    
    UIButton *load = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, _token.mj_y + _token.mj_h + 30, weight, 45)];
    
    load.backgroundColor = Color_system;
    load.layer.cornerRadius = 10.0f;
    [load setTitle:@"下一步" forState:UIControlStateNormal];
    [load addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:load];
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
            [self openCountdown:sender];
            statusStr = @"发送验证码成功,请注意查收短信";
            sender.userInteractionEnabled = NO;
            haveGetVerificationCode = YES;
            [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            sender.layer.borderColor = [UIColor grayColor].CGColor;
        }else{
            statusStr = [NSString stringWithFormat:@"%zd", statusCode];
        }
        
        [self.view makeToast:statusStr];
        
    }];
    
}

//点击立即注册
-(void)checkClick{
    [self.view endEditing:YES];
    
    if (!haveGetVerificationCode) {
        [self.view makeToast:@"请先获取验证码"];
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
            return;
        }
    }];
    
    
}
// 开启倒计时效果
-(void)openCountdown:(UIButton *)sender{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [sender setTitle:@"重新发送" forState:UIControlStateNormal];
                sender.layer.borderColor = Color_system.CGColor;
                [sender setTitleColor:Color_system forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [sender setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - 简单判断下手机号码是否合法
- (BOOL)checkTel:(NSString *)str
{
    NSString *regex = @"^((13[0-9])|(147)|(157)|(177)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)backToFront{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
