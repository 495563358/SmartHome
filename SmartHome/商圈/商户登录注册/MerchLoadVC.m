//
//  MerchLoadVC.m
//  SmartHome
//
//  Created by Smart house on 2018/5/6.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchLoadVC.h"

@interface MerchLoadVC ()

@property(nonatomic ,strong)UITextField *account;
@property(nonatomic ,strong)UITextField *password;

@end

@implementation MerchLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = My_gray;
    self.navigationItem.title = @"商家登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui(b)"] style:UIBarButtonItemStylePlain target:self action:@selector(backToFront)];
    // Do any additional setup after loading the view.
    
    [self createView];
    
}

-(void)createView{
    CGFloat weight = Sc_w * 340/375;
    
    _account = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 30, weight, 35)];
    _password = [[UITextField alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 30+50, weight, 35)];
    
    _account.borderStyle = UITextBorderStyleRoundedRect;
    _password.borderStyle = UITextBorderStyleRoundedRect;
    
    _account.placeholder = @"用户名";
    _account.font = [UIFont systemFontOfSize:15];
    _password.placeholder = @"密码";
    _password.font = [UIFont systemFontOfSize:15];
    _password.secureTextEntry = YES;
    
    _account.clearButtonMode = UITextFieldViewModeAlways;
    _password.clearButtonMode = UITextFieldViewModeAlways;
    
    _account.keyboardType = UIKeyboardTypeNumberPad;
    _password.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:_account];
    [self.view addSubview:_password];
    
    
    UIView *lefeView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 20)];
    UIImageView *mobileLeft = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 16, 20)];
    mobileLeft.image = [UIImage imageNamed:@"zhanghao"];
    [lefeView1 addSubview:mobileLeft];
    _account.leftView = lefeView1;
    _account.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *lefeView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 20)];
    UIImageView *pwdLeft = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 16, 20)];
    pwdLeft.image = [UIImage imageNamed:@"mima"];
    [lefeView2 addSubview:pwdLeft];
    _password.leftView = lefeView2;
    _password.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
    UIButton *showPWD = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 13)];
    [rView addSubview:showPWD];
    _password.rightViewMode = UITextFieldViewModeAlways;
    _password.rightView = rView;
    [showPWD setImage:[UIImage imageNamed:@"buxiansmm"] forState:UIControlStateNormal];
    [showPWD setImage:[UIImage imageNamed:@"xiansmm"] forState:UIControlStateSelected];
    [showPWD addTarget:self action:@selector(showPWD:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.account setValue:[NSNumber numberWithInt:12] forKey:@"paddingLeft"];
//
//    [self.password setValue:[NSNumber numberWithInt:15] forKey:@"paddingRight"];
    
    //账号密码
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *acc = [user objectForKey:@"MerchantAccount"];
    if (acc.length > 1) {
        _account.text = acc;
    }
    
    
    UIButton *load = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w-weight)/2, 30+130, weight, 45)];
    
    load.backgroundColor = Color_system;
    load.layer.cornerRadius = 10.0f;
    [load setTitle:@"登录" forState:UIControlStateNormal];
    //    [load setTitleColor:Color_system forState:UIControlStateNormal];
    [load addTarget:self action:@selector(loadClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:load];
    
    
    UIButton *forget = [[UIButton alloc]initWithFrame:CGRectMake(25, 380 - 154, 60, 30)];
    [forget setTitleColor:Color_system forState:UIControlStateNormal];
    [forget setTitle:@"密码找回" forState:UIControlStateNormal];
    forget.titleLabel.font = [UIFont systemFontOfSize:14];
    [forget addTarget:self action:@selector(findPWD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forget];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 25 - 60, 380 - 154, 60, 30)];
    [sureBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [sureBtn setTitle:@"商家注册" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(newUserClick) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:sureBtn];
    
    UILabel *noticeL = [[UILabel alloc] initWithFrame:CGRectMake(0, forget.mj_y + forget.mj_h + 10, Sc_w, 30)];
    noticeL.textColor = [UIColor grayColor];
    noticeL.font = [UIFont systemFontOfSize:12];
    noticeL.textAlignment = NSTextAlignmentCenter;
    noticeL.text = @"登录商户管理后台(建议在PC端登录)mall.znhomes.com";
    [self.view addSubview:noticeL];
    
}

-(void)showPWD:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _password.secureTextEntry = NO;
    }else
        _password.secureTextEntry = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)backToFront{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
