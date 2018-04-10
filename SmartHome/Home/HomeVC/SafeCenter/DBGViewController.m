//
//  DBGViewController.m
//  SmartHome
//
//  Created by Komlin on 16/5/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

#import "DBGViewController.h"
#import "DBGuestureLock.h"
#import "UIWindow+Visible.h"
#import "SmartHome-Swift.h"


@interface DBGViewController ()
@property (strong, nonatomic)  UILabel *label;
@property int ispassow;

@end

@implementation DBGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationController.navigationBar.shadowImage =[UIImage imageNamed:@"透明图片.png"];

    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 50)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];
    self.label.text = NSLocalizedString(@"请输入密码", nil);
    self.label.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.label];
    // Do any additional setup after loading the view from its nib.
    //清除所有密码 重设密码
    if (!self.isLogin) {
        [DBGuestureLock clearGuestureLockPassword];
    }else{
        self.ispassow = 0;
    }
   // [DBGuestureLock clearGuestureLockPassword];
     //just for test

    //Give me a Star: https://github.com/i36lib/DBGuestureLock/
    
    //Working with delegate:
    //DBGuestureLock *lock = [DBGuestureLock lockOnView:self.view delegate:self];
    
    //Working with block:
    DBGuestureLock *lock = [DBGuestureLock lockOnView:self.view onPasswordSet:^(DBGuestureLock *lock, NSString *password) {
        if (lock.firstTimeSetupPassword == nil) {
            //重设密码 第一次
            lock.firstTimeSetupPassword = password;
            NSLog(@"varify your password");
             NSLog(@"1");
            self.label.text = NSLocalizedString(@"请再次输入密码", nil);
        }
    } onGetCorrectPswd:^(DBGuestureLock *lock, NSString *password) {
        if (lock.firstTimeSetupPassword && ![lock.firstTimeSetupPassword isEqualToString:DBFirstTimeSetupPassword]) {
            //重设密码 第二次 输入对的情况下
            
            lock.firstTimeSetupPassword = DBFirstTimeSetupPassword;
            NSLog(@"%@",lock.firstTimeSetupPassword);
            NSLog(@"password has been setup!");
             NSLog(@"2");
            self.label.text = NSLocalizedString(@"密码设置成功", "");
            //popto alert "mima set sucess"
            //userDefualt isSetLock
           [self.navigationController popViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"password"];
            //清除
//            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//            [defaults removeObjectForKey:@"password"];
        } else {        
            NSLog(@"login success");
             NSLog(@"3");
             //登陆成功
            if (self.isLogin) {
                self.label.text = NSLocalizedString(@"登陆成功!", nil);
                [self.navigationController popToRootViewControllerAnimated:true];
            }
        }
    } onGetIncorrectPswd:^(DBGuestureLock *lock, NSString *password) {
          NSLog(@"%@",lock.firstTimeSetupPassword);
        if (![lock.firstTimeSetupPassword isEqualToString:DBFirstTimeSetupPassword]) {
            //重设密码 第二次 输入错的情况下
            NSLog(@"Error: password not equal to first setup!");
             NSLog(@"4");
            self.label.text = NSLocalizedString(@"两次密码不匹配", nil);
        } else {
            //登陆失败
            NSLog(@"login failed");
             NSLog(@"5");
            if (self.ispassow == 0) {
                self.label.text = NSLocalizedString(@"密码错误", nil);
                self.ispassow++;
            } else {
                self.ispassow++;
                self.label.text = [[NSString alloc]initWithFormat:@"%@%d,%@%d%@",NSLocalizedString(@"您输入错误",nil),self.ispassow,NSLocalizedString(@"输入",nil),5-self.ispassow,NSLocalizedString(@"次进入登录界面", nil)];
                if (self.ispassow == 5) {
                    AppDelegate *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
                    LoginVC *login = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
                    UINavigationController * vc = [[UINavigationController alloc]initWithRootViewController:login];
                    app.window.rootViewController = vc;
                
                }
               
            }
            
            // 3 -5 ci to login
            
        }
    }];
    
    [self.view addSubview:lock];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"DBGimg.png"] ];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"透明图片.png"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    if (self.isLogin) {
        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
        returnButtonItem.title = @" ";
        self.navigationItem.leftBarButtonItem = returnButtonItem;
        //[self.navigationItem.leftBarButtonItem setTitle:@" "];
        [self.navigationItem setHidesBackButton:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
